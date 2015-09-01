//
//  ZHCache.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCache : NSObject

/*
 单例模式
 */
+ (instancetype)sharedCache;

/*
 使用自定义缓存
 */
- (id)initWithCacheDirectory:(NSString*)cacheDirectory;

/*
 清空缓存
 */
- (void)clearCache;
- (void)removeCacheForKey:(NSString*)key;

/*
 判断是否有缓存
 */
- (BOOL)hasCacheForKey:(NSString*)key;

/*
 NSData存取
 */
- (NSData*)dataForKey:(NSString*)key;
- (void)setData:(NSData*)data forKey:(NSString*)key;
- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 *NSDictionary存取
 */
- (NSDictionary*)dictionaryForKey:(NSString*)key;
- (void)setDictionary:(NSDictionary*)dictionary forKey:(NSString*)key;
- (void)setDictionary:(NSDictionary*)dictionary forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 *NSMutableArray存取
 */
- (NSMutableArray*)mutableArrayForKey:(NSString*)key;
- (void)setMutableArray:(NSMutableArray*)mutableArray forKey:(NSString*)key;
- (void)setMutableArray:(NSMutableArray*)mutableArray forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 NSString存取
 */
- (NSString*)stringForKey:(NSString*)key;
- (void)setString:(NSString*)aString forKey:(NSString*)key;
- (void)setString:(NSString*)aString forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 UIImage存取
 */
#if TARGET_OS_IPHONE
- (UIImage*)imageForKey:(NSString*)key;
- (void)setImage:(UIImage*)anImage forKey:(NSString*)key;
- (void)setImage:(UIImage*)anImage forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;
#else
- (NSImage*)imageForKey:(NSString*)key;
- (void)setImage:(NSImage*)anImage forKey:(NSString*)key;
- (void)setImage:(NSImage*)anImage forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;
#endif

/*
 Plist存取
 */
- (NSData*)plistForKey:(NSString*)key;
- (void)setPlist:(id)plistObject forKey:(NSString*)key;
- (void)setPlist:(id)plistObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 拷贝文件放到缓存
 */
- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key;
- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 对象序列化
 */
- (id<NSCoding>)objectForKey:(NSString*)key;
- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key;
- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 获取缓存列表
 */
-(NSArray *)getAllCacheList;

/*
 获取缓存地址
 */
-(NSString *)getCachePathStr:(NSString *)key;

/*
 缓存有效期 默认是一天
 */
@property(nonatomic,assign) NSTimeInterval defaultTimeoutInterval;

////持久化数据对象 ,数据对象要实现NSCoding 协议
//
//+ (void)saveData:(id)cacheData fileName:(NSString *)fileName;
//+ (id)getCacheData:(NSString *)fileName;
//
///**
// *  Object 的存储和加载
// */
//+ (id)loadInfoWithKey:(NSString *)key;
//+ (void)saveInfo:(id)infoObject withKey:(NSString *)key;
//
//+ (void)removeCache;

@end
