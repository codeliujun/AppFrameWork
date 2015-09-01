//
//  ZHImageCache.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHImageCache.h"

@interface ZHImageCache ()

@property (strong, nonatomic) NSString *diskCachePath;
@property (strong, nonatomic) dispatch_queue_t ioQueue;

@end

static ZHImageCache *sharedInstance = nil;
@implementation ZHImageCache

+ (instancetype)sharedCache {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _ioQueue = dispatch_queue_create("com.xky.ZHImageCache", DISPATCH_QUEUE_SERIAL);
        
        NSString *fullNamespace = [@"com.xky.zhlv." stringByAppendingString:@"default"];
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    }
    
    return self;
}

- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [self.diskCachePath stringByAppendingPathComponent:filename];
}

#pragma mark - methods
- (void)storeImage:(UIImage *)image data:(NSData *)imageData key:(NSString *)key {
    if (!image || !key)
    {
        return;
    }
   
    dispatch_async(self.ioQueue, ^{
        NSData *data = imageData;
        
        if (!data)
        {
            if (image)
            {
                data = UIImageJPEGRepresentation(image, (CGFloat)1.0);
            }
        }
        
        if (data)
        {
            // Can't use defaultManager another thread
            NSFileManager *fileManager = NSFileManager.new;
            
            if (![fileManager fileExistsAtPath:_diskCachePath])
            {
                [fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            [fileManager createFileAtPath:[self cachePathForKey:key] contents:data attributes:nil];
        }
    });
}

- (UIImage *)imageFromKey:(NSString *)key {
    NSFileManager *fileManager = NSFileManager.new;
    NSData *data = nil;
    if ([fileManager fileExistsAtPath:[self cachePathForKey:key]]) {
        data = [NSData dataWithContentsOfFile:[self cachePathForKey:key]];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}


@end
