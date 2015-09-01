//
//  ZHNetworkManager.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkConfig.h"
#import "ZHNetworkDelegate.h"
#import "ZHNetworkEntityClass.h"

@interface ZHNetworkManager : NSObject

/**
 dataSourceObject默认是使用ZHNetworkLoadDefault,当有比如POST,PUT,SOAP请求的时候可以使用其他类
 当然,也可以使用定制的,前提是你继承<ZHNetworkLoadDataSource>协议返回ASIHTTPRequest提供连接.
 */
@property(nonatomic, retain)id<ZHNetworkLoadDataSource> dataSourceObject;

/**
 初始化方法,当ASINetworkQueue为nil的时候默认是用ASINetworkQueue全局默认queue,但这个queue默认最多只允许4个连接
 同时进行,当然你可以修改最大连接数(暂未实现).
 */
- (id)initWithOperationQueue:(NSOperationQueue *)queue;
/**
 全局的networkQueue,注意这个并非是当前对象初始化的,所以你可以不用管它的生命周期,这个由其他对象来控制
 */
@property(nonatomic, retain)NSOperationQueue *networkQueue;


/**
 URLString是连接的地址
 */
@property(nonatomic, copy)NSString *URLString;


/**
 parameters是参数数组
 */
@property(nonatomic, retain)NSArray *parameters;


/**
 soapConfig是soap配置参数,只有在使用soap连接的时候有用
 */
@property(nonatomic, retain)ZHNetworkSOPAEntityClass *soapConfig;


/**
 workType是参数类型
 */
@property(nonatomic )ZHNetworkType workType;


/**
 用来显示下载进度的回调block
 */
@property(nonatomic, copy)ZHProgressBlock progressBlocks;


/**
 ZHLoadFinishBlock是连接过程成功并返回数据回调block
 */
@property(nonatomic, copy)ZHLoadFinishBlock finishBlocks;

/**
 ZHLoadFailedBlock是连接过程中失败回调block
 */
@property(nonatomic, copy)ZHLoadFailedBlock failedBlocks;


/**
 ZHLoadCancelBlock是连接过程手动取消的回调block
 */
@property(nonatomic, copy)ZHLoadCancelBlock cancelBlocks;


/**
 设置SOAP参数
 只在设置使用SAOP协议时候有用,其它请求方式不必使用
 */
- (void)setSoapConfigInfo:(NSString *)soapName
                soapXmlns:(NSString *)xmlns
             soapXmlnsXsd:(NSString *)xsd
             soapXmlnsXsi:(NSString *)xsi
                 bodyName:(NSString *)bodyName
                bodyXmlns:(NSString *)bodyXmlns;
/**
 开始连接
 */
- (void )connectWithNetworkType:(ZHNetworkType)Type;


/**
 取消连接
 */
- (void)cancelConnect;


/**
 设置解析配置.默认为ZHNetworkAnalyZingTypeNone
 */
@property(nonatomic, assign)ZHNetworkAnalyZingType analyZingType;


/**
 当你使用自定义解析方法时候需要使用它
 */
@property(nonatomic, assign)id<ZHNetworkAnalyZingDataSource>analyZingDataSource;


/**
 设置缓存类型,默认是ZHNetworkCacheTypeNone
 */
@property(nonatomic, assign)ZHNetworkCacheType cacheType;


/**
 当你使用自定义缓存方法时候需要使用它
 */
@property(nonatomic, assign)id<ZHNetworkCacheDataSource>cacheDataSource;


/**
 特别修改版本,提高灵活性
 */
- (ASIHTTPRequest *)request;


@end
