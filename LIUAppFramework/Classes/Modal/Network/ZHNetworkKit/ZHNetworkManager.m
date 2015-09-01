//
//  ZHNetworkManager.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkManager.h"
#import "ZHNetworkLoadDefault.h"
#import "ZHNetworkLoadDELETE.h"
#import "ZHNetworkLoadPUT.h"
#import "ZHNetworkLoadSOAP.h"
#import "ZHNetworkLoadJsonObject.h"
#import "ZHCache.h"


#import <Reachability.h>
#import <XMLDictionary.h>
#import <ASIHTTPRequest.h>
#import <ASIDownloadCache.h>



Class object_getClass(id object);

@interface ZHNetworkManager () {
    ASIHTTPRequest *connectRequest;
    dispatch_queue_t workQueue;
}

- (void)performBlockOnMainThread:(ZHBasicBlock)block;
- (void)releaseBlocksOnMainThread;
+ (void)releaseBlocks:(NSArray *)blocks;
- (void)callBlock:(ZHBasicBlock)block;
- (void)ASIHTTPRequestCancel;

- (void )connectTypeWithASIRequest:(ZHNetworkType)type;

@property(nonatomic, assign)Class analyZingdelegateClass;
@property(nonatomic, assign)Class cachedelegateClass;
@property(nonatomic, assign)BOOL isUsedCompelcache;

/**
 取消连接和clear
 */
- (void)cancelAndclear;

@end


@implementation ZHNetworkManager

inline static NSString* cacheKeyForURL(NSString* url, NSString* data) {
    if(data) {
        return [NSString stringWithFormat:@"ZHNETWORKCACHE-%u-%u", url.hash, data.hash];
    } else {
        return [NSString stringWithFormat:@"ZHNETWORKCACHE-%u", url.hash];
    }
}

- (NSString *)getCacheKey{
    
    NSMutableString *str=[NSMutableString stringWithFormat:@"%@",self.URLString];
    for (ZHNetworkParameter *parameter in self.parameters) {
        if ([parameter isKindOfClass:[ZHNetworkParameter class]])
            [str appendFormat:@"%@%@%d",parameter.parameterName,parameter.parameterValue,parameter.parameterType];
        else
            [NSException raise:@"参数错误" format:@"当属性为ZHNetworkParameterTypePUT时候参数必须是NSData类型"];
    }
    return cacheKeyForURL(str, nil);
}


- (void)setAnalyZingDataSource:(id<ZHNetworkAnalyZingDataSource>)analyZingDataSource{
    
    _analyZingDataSource=analyZingDataSource;
    self.analyZingdelegateClass=object_getClass(analyZingDataSource);
#if NETWORK_DEBUG_ANALYZING
    NETWORK_DEBUG_LOG(@"解析--->设置自定义解析DataSource:%@",self.analyZingDataSource);
#endif
}
- (void)setCacheDataSource:(id<ZHNetworkCacheDataSource>)cacheDataSource{
    
    _cacheDataSource=cacheDataSource;
    self.cachedelegateClass=object_getClass(cacheDataSource);
    
#if NETWORK_DEBUG_RESPONSE_CACHE
    NETWORK_DEBUG_LOG(@"缓存--->设置自定义缓存DataSource:%@",_cacheDataSource);
#endif
}

- (void)dealloc{
    [self cancelAndclear];
}

- (void)releaseBlocksOnMainThread{
    
    NSMutableArray *blocks = [NSMutableArray array];
    if (_progressBlocks) {
        [blocks addObject:_progressBlocks];
        _progressBlocks=nil;
    }
    if (_finishBlocks) {
        [blocks addObject:_finishBlocks];
        _finishBlocks=nil;
    }
    if (_failedBlocks) {
        [blocks addObject:_failedBlocks];
        _failedBlocks=nil;
    }
    if (_cancelBlocks) {
        [blocks addObject:_cancelBlocks];
        _cancelBlocks=nil;
    }
    [[self class] performSelectorOnMainThread:@selector(releaseBlocks:) withObject:blocks waitUntilDone:[NSThread isMainThread]];
}
- (void)performBlockOnMainThread:(ZHBasicBlock)block
{
    [self performSelectorOnMainThread:@selector(callBlock:) withObject:block waitUntilDone:[NSThread isMainThread]];
}

- (void)callBlock:(ZHBasicBlock)block
{
    block();
}

// 始终在主线程执行
+ (void)releaseBlocks:(NSArray *)blocks
{
    // 该方法退出时blocks将被释放时，
}

- (void)ASIHTTPRequestCancel {
    [connectRequest clearDelegatesAndCancel];
}
- (void)cancelConnect{
    
    
#if NETWORK_DEBUG_CANCEL
    NETWORK_DEBUG_LOG(@"连接方式:%d--连接地址:%@\n--->取消连接",_workType,_URLString);
#endif
    if (self.cancelBlocks)
        [self performBlockOnMainThread:^{ if(self.cancelBlocks) self.cancelBlocks();}];
    
    [self ASIHTTPRequestCancel];
}
- (void)cancelAndclear{
    //[self ASIHTTPRequestCancel];
    [self releaseBlocksOnMainThread];
}
- (id)init{
    if ((self=[super init])){
        workQueue = dispatch_queue_create("com.ZHNetwork.workQueue", DISPATCH_QUEUE_CONCURRENT);
        self.analyZingType=ZHNetworkAnalyZingTypeNone;
        self.cacheType=ZHNetworkCacheTypeNone;
        self.dataSourceObject=nil;
        connectRequest=nil;
        self.isUsedCompelcache=NO;
    }
    return self;
}
- (id)initWithOperationQueue:(NSOperationQueue *)queue{
    
    if ((self=[self init])) {
        self.networkQueue=queue;
        connectRequest=nil;
    }
    return self;
}


/**
 设置SOAP参数
 只在设置使用SAOP协议时候有用,其它请求方式不必使用
 */
- (void)setSoapConfigInfo:(NSString *)soapName
                soapXmlns:(NSString *)xmlns
             soapXmlnsXsd:(NSString *)xsd
             soapXmlnsXsi:(NSString *)xsi
                 bodyName:(NSString *)bodyName
                bodyXmlns:(NSString *)bodyXmlns{
    
    ZHNetworkSOPAEntityClass *soap=[[ZHNetworkSOPAEntityClass alloc]init];
    soap.soapName=soapName;
    soap.soapXmlns=xmlns;
    soap.soapXmlnsXsd=xsd;
    soap.soapXmlnsXsi=xsi;
    soap.soapBodyName=bodyName;
    soap.soapBodyXmlns=bodyXmlns;
    
    self.soapConfig=soap;
}

- (void )connectWithNetworkType:(ZHNetworkType)type{
    self.workType=type;
    if (self.cacheType==ZHNetworkCacheTypeSystem || self.cacheType==ZHNetworkCacheTypeSystemStorage)
        [self connectTypeWithASIRequest:type];
    else if (self.cacheType==ZHNetworkCacheTypeCompel){
        Reachability *r = [Reachability reachabilityForInternetConnection];
        if (r.currentReachabilityStatus==NotReachable) {
#if NETWORK_DEBUG_RESPONSE_CACHE
            NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  当前没有网络,将获取缓存对象",self.URLString);
#endif
            self.isUsedCompelcache=YES;
            dispatch_async(workQueue, ^{
                NSString *keyStr = [self getCacheKey];
                NSData *tempData = [[ZHCache sharedCache] dataForKey:keyStr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (tempData){
                        [self analyZingWithData:tempData];
#if NETWORK_DEBUG_RESPONSE_CACHE
                        NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  获取到强制缓存对象",self.URLString);
#endif
                    } else{
                        [self connectTypeWithASIRequest:type];
#if NETWORK_DEBUG_RESPONSE_CACHE
                        NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  获取到强制缓存失败",self.URLString);
#endif
                    }
                });
            });
            
        }else
            [self connectTypeWithASIRequest:type];
        
    }
    else if (self.cacheType==ZHNetworkCacheTypeCustom){
        dispatch_async(workQueue, ^{
            NSData *tempData=(self.cachedelegateClass==object_getClass(self.cacheDataSource) && self.cacheDataSource &&[self.cacheDataSource respondsToSelector:@selector(ZHNetworkManager:cacheWithZHNetworkType:)])?[self.cacheDataSource ZHNetworkManager:self cacheWithZHNetworkType:type]:nil;
#if NETWORK_DEBUG_RESPONSE_CACHE
            NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  返回缓存对象以提供解析",self.URLString);
#endif
            dispatch_async(dispatch_get_main_queue(), ^{
                if (tempData)
                    [self analyZingWithData:tempData];
                else
                    [self connectTypeWithASIRequest:type];
            });
        });
        
    }else
        [self connectTypeWithASIRequest:type];
}

- (void )connectTypeWithASIRequest:(ZHNetworkType)type{
    
    if (connectRequest)
        [self ASIHTTPRequestCancel];
    switch (type) {
        case ZHNetworkTypeGet:
            _dataSourceObject = [[ZHNetworkLoadDefault alloc] init];
            break;
        case ZHNetworkTypePost:
            _dataSourceObject = [[ZHNetworkLoadDefault alloc] init];
            break;
        case ZHNetworkTypePUT:
            _dataSourceObject = [[ZHNetworkLoadPUT alloc] init] ;
            break;
        case ZHNetworkTypeDELETE:
            _dataSourceObject = [[ZHNetworkLoadDELETE alloc] init] ;
            break;
        case ZHNetworkTypeSoap:
            if (!self.soapConfig)
                [NSException raise:@"设置错误" format:@"当使用SOAP协议时候必须设置soapConfig"];
            _dataSourceObject = [[ZHNetworkLoadSOAP alloc] init];
            break;
        case ZHNetworkTypeCustom:
            if (!self.dataSourceObject)
                [NSException raise:@"设置错误" format:@"还未设置自定义的dataSourceObject"];
            break;
        default:
            [NSException raise:@"设置错误" format:@"不确定的连接类型,请明确设置"];
            break;
    }
    
    
    connectRequest = [self.dataSourceObject requestWithZHNetworkLoad:self];
    if (connectRequest) {
        [connectRequest setNumberOfTimesToRetryOnTimeout:REQUST_RESET ];
        [connectRequest setPersistentConnectionTimeoutSeconds:REQUST_TIMEOUT];
#if NETWORK_DEBUG_PROXY
        [connectRequest setProxyHost:PROXY_ADDRESS];
        [connectRequest setProxyPort:PROXY_PORT];
#endif
        [connectRequest setFailedBlock:^{
            
#if NETWORK_DEBUG_CANCEL
            if (connectRequest.error.code==4)
                NETWORK_DEBUG_LOG(@"连接方式:%d--连接地址:%@\n--->取消连接:%@",_workType,_URLString,connectRequest.error);
#endif
            if (connectRequest.error.code==4 && self.cancelBlocks)
                [self performBlockOnMainThread:^{ if(self.cancelBlocks) self.cancelBlocks();}];
            else if(self.failedBlocks){
                [self performBlockOnMainThread:^{ if(self.failedBlocks)self.failedBlocks(connectRequest.error);}];
            }
            //[self ASIHTTPRequestCancel];
        }];
        [connectRequest setCompletionBlock:^{
#if NETWORK_DEBUG_RESPONSE_STRING
            NETWORK_DEBUG_LOG(@"连接方式:%d--连接地址:%@\n--->获取的数据:\n%@\n<---\n\n\n",_workType,_URLString,connectRequest.responseString);
#endif
            if(self.finishBlocks)
                //[self analyZingWithData:connectRequest.responseData];
                [self analyZingWithDataByString:connectRequest.responseString];
            //由于接口原因进行调整
            //[self ASIHTTPRequestCancel];
        }];
        if (self.cacheType==ZHNetworkCacheTypeSystem){
            [connectRequest setDownloadCache:[ASIDownloadCache sharedCache]];
            [connectRequest setCachePolicy:ASIUseDefaultCachePolicy];
        }else if (self.cacheType==ZHNetworkCacheTypeSystemStorage){
            [connectRequest setDownloadCache:[ASIDownloadCache sharedCache]];
            [connectRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        }
        [connectRequest setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
            if(self.progressBlocks){
                [self performBlockOnMainThread:^{ if(self.progressBlocks) self.progressBlocks([connectRequest totalBytesRead]+[connectRequest partialDownloadSize],total);}];
            }
        }];
        [self.networkQueue addOperation:connectRequest];
    }
}

- (void)analyZingWithData:(NSData *)data{
    
    __block id object=nil;
    __block NSError *err=nil;
    __block NSData *responseData=[[NSData alloc]initWithData:data];
    
    dispatch_async(workQueue, ^{
        
        if (self.analyZingType==ZHNetworkAnalyZingTypeJSON) {
            object = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
        }else if (self.analyZingType==ZHNetworkAnalyZingTypeXML){
            object = [NSDictionary dictionaryWithXMLData:responseData];
        }else if (self.analyZingType==ZHNetworkAnalyZingTypeCustom && self.analyZingdelegateClass==object_getClass(self.analyZingDataSource) && [ self.analyZingDataSource respondsToSelector:@selector(ZHNetworkManager:analyZingWithData:error:)]){
            object = [self.analyZingDataSource ZHNetworkManager:self analyZingWithData:responseData error:&err];
#if NETWORK_DEBUG_ANALYZING
            NETWORK_DEBUG_LOG(@"解析--->连接地址:%@  获取自定义的解析对象",self.URLString);
#endif
        } else if (self.analyZingType==ZHNetworkAnalyZingTypeNone) {
            object = responseData;
        } else if(self.analyZingType==ZHNetworkAnalyZingTypeString) {
            object = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err || !object) {
                if(self.failedBlocks){
                    [self performBlockOnMainThread:^{ if(self.failedBlocks)self.failedBlocks([NSError errorWithDomain:@"数据解析失败" code:1 userInfo:nil]);}];
#if NETWORK_DEBUG_ANALYZING
                    NETWORK_DEBUG_LOG(@"解析--->连接地址:%@  解析失败",self.URLString);
#endif
                }
            }else{
                if (self.finishBlocks)[self performBlockOnMainThread:^{ if(self.finishBlocks)self.finishBlocks(object);}];
                if (self.cacheType==ZHNetworkCacheTypeCustom && self.cachedelegateClass==object_getClass(self.cacheDataSource) && self.cacheDataSource &&[ self.cacheDataSource respondsToSelector:@selector(ZHNetworkManager:responseData:)]) {
                    [self.cacheDataSource ZHNetworkManager:self responseData:responseData];
#if NETWORK_DEBUG_RESPONSE_CACHE
                    NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  正常网络连接获取到将要缓存的对象,请自行处理",self.URLString);
#endif
                }else if (self.cacheType==ZHNetworkCacheTypeCompel && !self.isUsedCompelcache){
                    
                    [[ZHCache sharedCache] setData:responseData forKey:[self getCacheKey]];
#if NETWORK_DEBUG_RESPONSE_CACHE
                    NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  跟新缓存信息",self.URLString);
#endif
                }
            }
        });
    });
}

- (void)analyZingWithDataByString:(NSString *)data{
    
    __block id object=nil;
    __block NSError *err=nil;
    __block NSData *responseData=[[NSData alloc]initWithData:[data dataUsingEncoding: NSUTF8StringEncoding]];
    
    dispatch_async(workQueue, ^{
        
        if (self.analyZingType == ZHNetworkAnalyZingTypeJSON) {
            object = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
        } else if (self.analyZingType == ZHNetworkAnalyZingTypeXML){
            object = [NSDictionary dictionaryWithXMLData:responseData];
        } else if (self.analyZingType == ZHNetworkAnalyZingTypeCustom && self.analyZingdelegateClass == object_getClass(self.analyZingDataSource) && [ self.analyZingDataSource respondsToSelector:@selector(ZHNetworkManager:analyZingWithData:error:)]){
            object = [self.analyZingDataSource ZHNetworkManager:self analyZingWithData:responseData error:&err];
#if NETWORK_DEBUG_ANALYZING
            NETWORK_DEBUG_LOG(@"解析--->连接地址:%@  获取自定义的解析对象",self.URLString);
#endif
        } else if (self.analyZingType == ZHNetworkAnalyZingTypeNone) {
            object = responseData;
        } else if(self.analyZingType == ZHNetworkAnalyZingTypeString)
            object=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err || !object) {
                if(self.failedBlocks){
                    [self performBlockOnMainThread:^{ if(self.failedBlocks)self.failedBlocks([NSError errorWithDomain:@"数据解析失败" code:1 userInfo:nil]);}];
#if NETWORK_DEBUG_ANALYZING
                    NETWORK_DEBUG_LOG(@"解析--->连接地址:%@  解析失败",self.URLString);
#endif
                }
            }else{
                if (self.finishBlocks)[self performBlockOnMainThread:^{ if(self.finishBlocks)self.finishBlocks(object);}];
                if (self.cacheType==ZHNetworkCacheTypeCustom && self.cachedelegateClass==object_getClass(self.cacheDataSource) && self.cacheDataSource &&[ self.cacheDataSource respondsToSelector:@selector(ZHNetworkManager:responseData:)]) {
                    [self.cacheDataSource ZHNetworkManager:self responseData:responseData];
#if NETWORK_DEBUG_RESPONSE_CACHE
                    NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  正常网络连接获取到将要缓存的对象,请自行处理",self.URLString);
#endif
                }else if (self.cacheType==ZHNetworkCacheTypeCompel && !self.isUsedCompelcache){
                    
                    [[ZHCache sharedCache] setData:responseData forKey:[self getCacheKey]];
#if NETWORK_DEBUG_RESPONSE_CACHE
                    NETWORK_DEBUG_LOG(@"缓存--->连接地址:%@  跟新缓存信息",self.URLString);
#endif
                }
            }
        });
    });
}
/**
 特别修改版本,提高灵活性
 */
- (ASIHTTPRequest *)request{
    
    return connectRequest;
}

@end
