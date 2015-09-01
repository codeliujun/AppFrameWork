//
//  ZHNetworkDelegate.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZHNetworkType) {
    /// 默认连接类型,大多数时候都使用这个
    ZHNetworkTypeGet = 1,
    
    /// POST请求
    ZHNetworkTypePost = 2,
    
    /// PUT请求,当接口要求使用直接POST一段json或者其他数据
    ZHNetworkTypePUT = 3,
    
    
    /// PUT请求,当接口要求使用直接POST一段json或者其他数据
    ZHNetworkTypeDELETE = 4,
    
    /// SOAP请求
    ZHNetworkTypeSoap = 5,
    
    
    /// 自定义请求,需要设置dataSourceObject
    ZHNetworkTypeCustom = 6
};
typedef NS_ENUM(NSInteger, ZHNetworkParameterType) {
    
    /// 默认参数类型,大多数时候都使用这个
    ZHNetworkParameterTypeDefault = 1,
    
    /// 当出现表单提交图片或者文件的时候使用,提交的参数是NSData类型
    ZHNetworkParameterTypeForm = 2,
    
    /// 提交表单是路径的参数,通常使用在上传的文件比较大的情况下
    ZHNetworkParameterTypeFormPath = 3,
    
    /// PUT提交参数,参数只有一个
    ZHNetworkParameterTypePUT = 4
};

typedef NS_ENUM(NSInteger, ZHNetworkAnalyZingType) {
    
    /// 默认类型,拿到原始数据
    ZHNetworkAnalyZingTypeNone = 1,
    
    /// 使用JSON解析
    ZHNetworkAnalyZingTypeJSON = 2,
    
    /// 使用XML解析
    ZHNetworkAnalyZingTypeXML = 3,
    
    /// 定制解析 需要是实现ZHNetworkAnalyZingDataSource
    ZHNetworkAnalyZingTypeCustom = 4,
    
    /// 默认类型,拿到原始字符串数据
    ZHNetworkAnalyZingTypeString = 5,
};

typedef NS_ENUM(NSInteger, ZHNetworkCacheType) {
    
    /// 默认无缓存
    ZHNetworkCacheTypeNone = 1,
    
    ///设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
    ZHNetworkCacheTypeSystem = 2,
    
    /// 把缓存数据永久保存在本地
    ZHNetworkCacheTypeSystemStorage=3,
    
    /// 强制使用缓存,只要没有网络连接,就从缓存里查找数据,有网络就是用网络数据
    ZHNetworkCacheTypeCompel = 4,
    
    /// 定制缓存 需要是实现缓存使用策略ZHNetworkCacheDataSource
    ZHNetworkCacheTypeCustom = 5
};

#import <Foundation/Foundation.h>
///#import "ASIHTTPRequest.h"
@class ASIHTTPRequest;
@class ZHNetworkManager;


/**
 BasicBlock
 */
typedef void (^ZHBasicBlock)(void);

/**
 ZHProgressBlock是连接过程中返回数据每次下载的数据大小
 */
typedef void (^ZHProgressBlock)(unsigned long long size, unsigned long long total);
/**
 ZHLoadFailedBlock是连接过程中失败回调block
 */
typedef void (^ZHLoadFailedBlock)(NSError *error);
/**
 ZHLoadFinishBlock是连接过程成功并返回数据回调block
 */
typedef void (^ZHLoadFinishBlock)(id responseObje);
/**
 ZHLoadCancelBlock是连接过程手动取消的回调block
 */
typedef void (^ZHLoadCancelBlock)();

@protocol ZHNetworkLoadDataSource<NSObject>

/**
 requestWithZHNetworkLoad默认是ZHDownLoadManager在使用的时候用ZHNetworkLoadDataSource返回的ASIHTTPRequest
 进行连接.
 */
@required
- (ASIHTTPRequest *)requestWithZHNetworkLoad:(ZHNetworkManager *)manager;

@end

@protocol ZHNetworkAnalyZingDataSource<NSObject>

/**
 进行自定义的解析,目的是使解析更加灵活,特别适用语于XML里面包JSON格式或者反之,当然还有更加复杂结构,只要你想,你都能做到.
 注意,本身已经使用异步,请勿在此方法再次异步
 */
@required
- (id)ZHNetworkManager:(ZHNetworkManager *)manager analyZingWithData:(NSData *)data error:(NSError **)error;

@end


/**
 进行自定义的缓存,目的是使缓存更加灵活,特别适用复杂的缓存策略
 注意,本身已经使用异步,请勿在此方法再次异步
 */
@protocol ZHNetworkCacheDataSource <NSObject>

@required
- (NSData *)ZHNetworkManager:(ZHNetworkManager *)manager cacheWithZHNetworkType:(ZHNetworkType)type;
- (void)ZHNetworkManager:(ZHNetworkManager *)manager responseData:(NSData *)data;

@end
