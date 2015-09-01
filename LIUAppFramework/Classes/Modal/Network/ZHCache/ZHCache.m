//
//  ZHCache.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHCache.h"

#if DEBUG
#define CHECK_FOR_ZHCACHE_PLIST() if([key isEqualToString:@"ZHCache.plist"]) { \
DBLog(@"ZHCache.plist is a reserved key and can not be modified."); \
return; }
#else
#define CHECK_FOR_ZHCACHE_PLIST() if([key isEqualToString:@"ZHCache.plist"]) return;
#endif

static inline NSString* cachePathForKey(NSString* directory, NSString* key) {
    return [directory stringByAppendingPathComponent:key];
}

#pragma mark -
@interface ZHCache () {
    dispatch_queue_t _cacheInfoQueue;
    dispatch_queue_t _frozenCacheInfoQueue;
    dispatch_queue_t _diskQueue;
    NSMutableDictionary* _cacheInfo;
    NSString* _directory;
    BOOL _needsSave;
}

@property(nonatomic,copy) NSDictionary* frozenCacheInfo;

@end

@implementation ZHCache

+ (instancetype)sharedCache {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance setDefaultTimeoutInterval:432000];//86400一天
    });
    
    return instance;
}

- (id)init {
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString* oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"ZHCache"] copy];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
        [[NSFileManager defaultManager] removeItemAtPath:oldCachesDirectory error:NULL];
    }
    
    cachesDirectory = [[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"ZHCache"];
    return [self initWithCacheDirectory:cachesDirectory];
}

- (id)initWithCacheDirectory:(NSString*)cacheDirectory {
    if((self = [super init])) {
        
        _cacheInfoQueue = dispatch_queue_create("com.kj.zhcache.info", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(priority, _cacheInfoQueue);
        
        _frozenCacheInfoQueue = dispatch_queue_create("com.kj.zhcache.info.frozen", DISPATCH_QUEUE_SERIAL);
        priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(priority, _frozenCacheInfoQueue);
        
        _diskQueue = dispatch_queue_create("com.kj.zhcache.disk", DISPATCH_QUEUE_CONCURRENT);
        priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_set_target_queue(priority, _cacheInfoQueue);
        
        
        _directory = cacheDirectory;
        
        _cacheInfo = [[NSDictionary dictionaryWithContentsOfFile:cachePathForKey(_directory, @"ZHCache.plist")] mutableCopy];
        
        if(!_cacheInfo) {
            _cacheInfo = [[NSMutableDictionary alloc] init];
        }
        
        [[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:NULL];
        
        NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
        NSMutableArray* removedKeys = [[NSMutableArray alloc] init];
        
        for(NSString* key in _cacheInfo) {
            if([_cacheInfo[key] timeIntervalSinceReferenceDate] <= now) {
                [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
                [removedKeys addObject:key];
            }
        }
        
        [_cacheInfo removeObjectsForKeys:removedKeys];
        self.frozenCacheInfo = _cacheInfo;
    }
    
    return self;
}

- (void)clearCache {
    dispatch_sync(_cacheInfoQueue, ^{
        for(NSString* key in _cacheInfo) {
            [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
        }
        
        [_cacheInfo removeAllObjects];
        
        dispatch_sync(_frozenCacheInfoQueue, ^{
            self.frozenCacheInfo = [_cacheInfo copy];
        });
        
        [self setNeedsSave];
    });
}

- (void)removeCacheForKey:(NSString*)key {
    CHECK_FOR_ZHCACHE_PLIST();
    
    dispatch_async(_diskQueue, ^{
        [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
    });
    
    [self setCacheTimeoutInterval:0 forKey:key];
}

- (BOOL)hasCacheForKey:(NSString*)key {
    __block NSDate* date = nil;;
    
    dispatch_sync(_frozenCacheInfoQueue, ^{
        date = (self.frozenCacheInfo)[key];
    });
    
    if(!date) return NO;
    if([date compare:[NSDate date]] != NSOrderedDescending) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(_directory, key)];
}

- (void)setCacheTimeoutInterval:(NSTimeInterval)timeoutInterval forKey:(NSString*)key {
    NSDate* date = timeoutInterval > 0 ? [NSDate dateWithTimeIntervalSinceNow:timeoutInterval] : nil;
    
    dispatch_sync(_frozenCacheInfoQueue, ^{
        NSMutableDictionary* info = [self.frozenCacheInfo mutableCopy];
        
        if(date) {
            info[key] = date;
        } else {
            [info removeObjectForKey:key];
        }
        
        self.frozenCacheInfo = info;
    });
    
    
    dispatch_async(_cacheInfoQueue, ^{
        if(date) {
            _cacheInfo[key] = date;
        } else {
            [_cacheInfo removeObjectForKey:key];
        }
        
        dispatch_sync(_frozenCacheInfoQueue, ^{
            self.frozenCacheInfo = [_cacheInfo copy];
        });
        
        [self setNeedsSave];
    });
}

#pragma mark -
#pragma mark Copy file methods

- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key {
    [self copyFilePath:filePath asKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    dispatch_async(_diskQueue, ^{
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:cachePathForKey(_directory, key) error:NULL];
    });
    
    [self setCacheTimeoutInterval:timeoutInterval forKey:key];
}

#pragma mark -
#pragma mark Data methods

- (void)setData:(NSData*)data forKey:(NSString*)key {
    [self setData:data forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    CHECK_FOR_ZHCACHE_PLIST();
    
    NSString* cachePath = cachePathForKey(_directory, key);
    
    dispatch_async(_diskQueue, ^{
        [data writeToFile:cachePath atomically:YES];
    });
    
    [self setCacheTimeoutInterval:timeoutInterval forKey:key];
}

- (void)setNeedsSave {
    dispatch_async(_cacheInfoQueue, ^{
        if(_needsSave) return;
        _needsSave = YES;
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, _cacheInfoQueue, ^(void){
            if(!_needsSave) return;
            [_cacheInfo writeToFile:cachePathForKey(_directory, @"ZHCache.plist") atomically:YES];
            _needsSave = NO;
        });
    });
}

- (NSData*)dataForKey:(NSString*)key {
    if([self hasCacheForKey:key]) {
        return [NSData dataWithContentsOfFile:cachePathForKey(_directory, key) options:0 error:NULL];
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark NSDictionary methods
- (NSDictionary*)dictionaryForKey:(NSString*)key {
    NSData *data = [self dataForKey:key];
    if (data != nil) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dictionary = [unarchiver decodeObjectForKey:@"Some"];
        [unarchiver finishDecoding];
        return dictionary;
    }
    return nil;
}

- (void)setDictionary:(NSDictionary*)dictionary forKey:(NSString*)key{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dictionary forKey:@"Some"];
    [archiver finishEncoding];
    [self setData:data forKey:key];
}

- (void)setDictionary:(NSDictionary*)dictionary forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dictionary forKey:@"Some"];
    [archiver finishEncoding];
    [self setData:data forKey:key withTimeoutInterval:timeoutInterval];
}

#pragma mark -
#pragma mark MutableArray methods
- (NSMutableArray*)mutableArrayForKey:(NSString*)key{
    if ([self hasCacheForKey:key]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForKey:key]];
    }else{
        return [[NSMutableArray alloc] init];
    }
}

- (void)setMutableArray:(NSMutableArray*)mutableArray forKey:(NSString*)key{
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:mutableArray] forKey:key];
}

- (void)setMutableArray:(NSMutableArray*)mutableArray forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval{
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:mutableArray] forKey:key withTimeoutInterval:timeoutInterval];
}

#pragma mark -
#pragma mark String methods

- (NSString*)stringForKey:(NSString*)key {
    return [[NSString alloc] initWithData:[self dataForKey:key] encoding:NSUTF8StringEncoding];
}

- (void)setString:(NSString*)aString forKey:(NSString*)key {
    [self setString:aString forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setString:(NSString*)aString forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [self setData:[aString dataUsingEncoding:NSUTF8StringEncoding] forKey:key withTimeoutInterval:timeoutInterval];
}

#pragma mark -
#pragma mark Image methds

- (UIImage*)imageForKey:(NSString*)key {
    UIImage* image = nil;
    
    @try {
        image = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePathForKey(_directory, key)];
    } @catch (NSException* e) {
        
    }
    
    return image;
}

- (void)setImage:(UIImage*)anImage forKey:(NSString*)key {
    [self setImage:anImage forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setImage:(UIImage*)anImage forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    @try {
        [self setData:[NSKeyedArchiver archivedDataWithRootObject:anImage] forKey:key withTimeoutInterval:timeoutInterval];
    } @catch (NSException* e) {
    }
}

#pragma mark -
#pragma mark Property List methods

- (NSData*)plistForKey:(NSString*)key; {
    NSData* plistData = [self dataForKey:key];
    
    return [NSPropertyListSerialization propertyListFromData:plistData
                                            mutabilityOption:NSPropertyListImmutable
                                                      format:nil
                                            errorDescription:nil];
}

- (void)setPlist:(id)plistObject forKey:(NSString*)key; {
    [self setPlist:plistObject forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setPlist:(id)plistObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval; {
    NSData* plistData = [NSPropertyListSerialization dataFromPropertyList:plistObject
                                                                   format:NSPropertyListBinaryFormat_v1_0
                                                         errorDescription:NULL];
    
    [self setData:plistData forKey:key withTimeoutInterval:timeoutInterval];
}

#pragma mark -
#pragma mark Object methods

- (id<NSCoding>)objectForKey:(NSString*)key {
    if([self hasCacheForKey:key]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForKey:key]];
    } else {
        return nil;
    }
}

- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key {
    [self setObject:anObject forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:anObject] forKey:key withTimeoutInterval:timeoutInterval];
}

#pragma mark -
#pragma mark info methods

- (NSArray *)getAllCacheList{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsAtPath: _directory];
    return  files;
    
}

- (NSString *)getCachePathStr:(NSString *)key{
    
    if ([self hasCacheForKey:key]) {
        
        return cachePathForKey(_directory, key);
    }
    return @"";
}

//+ (NSString *)fileName:(NSString *)fileName {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:kDataPath];
//
//    BOOL dirExist = NO;
//    [[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory isDirectory:&dirExist];
//    if (!dirExist) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//
//    return [documentsDirectory stringByAppendingPathComponent:fileName];
//}
//
//+ (void)saveData:(id)cacheData fileName:(NSString *)fileName {
//    NSString *filePath = [self fileName:fileName];
//    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//    if (!fileExist){
//        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
//    }
//    BOOL success = [NSKeyedArchiver archiveRootObject:cacheData toFile:filePath];
//    if (!success) {
//        NSLog(@"写入失败");
//    }else{
//        NSLog(@"写入成功");
//    }
//}
//
//+ (id)getCacheData:(NSString *)fileName {
//    NSString *filePath = [self fileName:fileName];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        id cacheData =  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//        if (!cacheData) {
//            NSLog(@"读取失败");
//        }
//        return cacheData;
//    }
//    return nil;
//}
//
//#pragma mark -
//#pragma mark - save and load
//
//+ (id)loadInfoWithKey:(NSString *)key {//读取
//    NSData *data = [ZHCache getCacheData:key];
//    if (!data) {
//        return nil;
//    }
//    
//    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    id infoObject = [unArchiver decodeObjectForKey:key];
//    return infoObject;
//}
//
//+ (void)saveInfo:(id)infoObject withKey:(NSString *)key {//保存
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:infoObject forKey:key];
//    [archiver finishEncoding];
//    
//    [ZHCache saveData:data fileName:key];
//}
//
//+ (void)removeCache {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:kDataPath];
//    [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
//    
//    return;
//}

@end
