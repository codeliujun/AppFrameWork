//
//  ZHNetworkInterface.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkInterface.h"
#import "ZHNetworkManager.h"

@implementation ZHNetworkQueue

- (id)init{
    if ((self=[super init])){
        _queque = [[NSOperationQueue alloc]init];
        [_queque setMaxConcurrentOperationCount:4];
    }
    return self;
}

- (NSOperationQueue *)queque {
    return _queque;
}

- (void)cancelAll {
    
    [_queque cancelAllOperations];
}

+ (id)sharedQueue
{
    static dispatch_once_t pred = 0;
    __strong static ZHNetworkQueue *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

@end

/**
 *  ZHNetworkInterface 私有变量
 */
@interface ZHNetworkInterface()

@property(nonatomic,assign) UIView *HUDBackgroundView;
@property(nonatomic,copy) NSString *HUDString;
@property(nonatomic,strong) ZHNetworkManager *manager;
/**
 soapConfig是soap配置参数,只有在使用soap连接的时候有用
 */
@property(nonatomic, retain) ZHNetworkSOPAEntityClass *soapConfig;

- (id)initWithBlocks:(ZHLoadFinishBlock)finshBlick faildBlock:(ZHLoadFailedBlock)faildBlock cancelBlock:(ZHLoadCancelBlock)cancelBlock connectType:(ZHNetworkType)type URLString:(NSString *)urlString interFaceHUD:(ZHLoadHUDStyle)style HUDString:(NSString *)string HUDBackgroundView:(UIView *)backgroundView;


- (void)performBlockOnMainThread:(ZHBasicBlock)block;
- (void)releaseBlocksOnMainThread;
- (void)releaseSelf;
+ (void)releaseBlocks:(NSArray *)blocks;
- (void)callBlock:(ZHBasicBlock)block;

@end


@implementation ZHNetworkInterface

- (void)setAnalyZingType:(ZHNetworkAnalyZingType)analyZingType{
    _analyZingType = analyZingType;
    if (_analyZingType == ZHNetworkAnalyZingTypeCustom) {
        [self.manager setAnalyZingDataSource:self];
    }
}
- (void)setCacheType:(ZHNetworkCacheType)cacheType{
    _cacheType = cacheType;
    if (_cacheType == ZHNetworkCacheTypeCustom) {
        [self.manager setCacheDataSource:self];
    }
}

- (void)setSoapConfig:(ZHNetworkSOPAEntityClass *)soapConfig{
    _soapConfig = soapConfig;
    [self.manager setSoapConfig:_soapConfig];
}

// 始终在主线程执行
+ (void)releaseBlocks:(NSArray *)blocks
{
    // 该方法退出时blocks将被释放时，
}
- (void)performBlockOnMainThread:(ZHBasicBlock)block
{
    [self performSelectorOnMainThread:@selector(callBlock:) withObject:[block copy] waitUntilDone:[NSThread isMainThread]];
}
- (void)callBlock:(ZHBasicBlock)block
{
    block();
}
- (void)releaseSelf{
    
    NSMutableArray *blocks = [NSMutableArray array];
    [blocks addObject:self];
    [[self class] performSelectorOnMainThread:@selector(releaseBlocks:) withObject:blocks waitUntilDone:[NSThread isMainThread]];
}
- (void)releaseBlocksOnMainThread{
    
    NSMutableArray *blocks = [NSMutableArray array];
    if (_loadFinshBlock) {
        [blocks addObject:_loadFinshBlock];
        _loadFinshBlock = nil;
    }
    if (_loadFaildBlock) {
        [blocks addObject:_loadFaildBlock];
        _loadFaildBlock = nil;
    }
    if (_loadProgressBlock) {
        [blocks addObject:_loadProgressBlock];
        _loadProgressBlock = nil;
    }
    if (_loadCancelBlock) {
        [blocks addObject:_loadCancelBlock];
        _loadCancelBlock = nil;
    }
    [[self class] performSelectorOnMainThread:@selector(releaseBlocks:) withObject:blocks waitUntilDone:[NSThread isMainThread]];
}

+ (void)cancelAll {
    [[ZHNetworkQueue sharedQueue] cancelAll];
}

- (void)cancel {
    
    [_manager cancelConnect];
}

- (void)dealloc {
    [self.MBHUDView removeFromSuperview];
    [self releaseBlocksOnMainThread];
}

- (id)init {
    if ((self=[super init])) {
        
        self.cacheType                 = ZHNetworkCacheTypeNone;
        self.analyZingType             = ZHNetworkAnalyZingTypeNone;
        self.HUDUserInteractionEnabled = NO;
        self.dimBackground             = NO;
        _manager = [[ZHNetworkManager alloc] initWithOperationQueue:[[ZHNetworkQueue sharedQueue] queque]];
    }
    return  self;
}

- (id)initWithBlocks:(ZHLoadFinishBlock)finshBlick faildBlock:(ZHLoadFailedBlock)faildBlock cancelBlock:(ZHLoadCancelBlock)cancelBlock connectType:(ZHNetworkType)type URLString:(NSString *)urlString interFaceHUD:(ZHLoadHUDStyle)style HUDString:(NSString *)string HUDBackgroundView:(UIView *)backgroundView{
    
    if ((self=[self init])) {
        self.loadFinshBlock  = finshBlick;
        self.loadFaildBlock  = faildBlock;
        self.loadCancelBlock = cancelBlock;
        self.connectType     = type;
        
        if (backgroundView)
            self.HUDBackgroundView = backgroundView;
        else
            self.HUDBackgroundView = [[UIApplication sharedApplication] keyWindow];
        
        self.HUDString = string;
        self.HUDStyle  = style;
        self.URLString = urlString;
        
    }
    return self;
}

- (MBProgressHUDMode )getHUDMode{
    
    switch (self.HUDStyle) {
        case ZHLoadHUDStyleDefault: return MBProgressHUDModeIndeterminate;
        case ZHLoadHUDStyleAnnularDeterminate: return MBProgressHUDModeAnnularDeterminate;
        case ZHLoadHUDStyleDeterminate: return MBProgressHUDModeDeterminate;
        case ZHLoadHUDStyleCustomView: return MBProgressHUDModeCustomView;
        default: return MBProgressHUDModeIndeterminate;
    }
}
- (void)starLoadInformationWithParameters:(NSArray *)arr URLString:(NSString *)string connectType:(ZHNetworkType)type{
    self.URLString = string;
    self.connectType = type;
    if (self.HUDStyle > 0) {
        self.MBHUDView = [[MBProgressHUD alloc] initWithView:self.HUDBackgroundView];
        [self.HUDBackgroundView addSubview:self.MBHUDView];
        self.MBHUDView.labelText = self.HUDString;
        self.MBHUDView.mode = [self getHUDMode];
        self.MBHUDView.removeFromSuperViewOnHide=YES;
        [self.MBHUDView show:YES];
    }
    _manager.URLString=string;
    [_manager setAnalyZingType:self.analyZingType];
    [_manager setCacheType:self.cacheType];
    
    WS(ws);
    
    [_manager setFinishBlocks:^(id responseObje) {
        [ws.MBHUDView hide:YES];
        
        id object = responseObje;
        if (ws.loadFinshBlock) {
            [ws performBlockOnMainThread:^{ if(ws.loadFinshBlock) ws.loadFinshBlock(object);}];
        }
    }];
    [_manager setFailedBlocks:^(NSError *err){
        [ws.MBHUDView hide:YES];
        
        NSError *error = err;
        if (ws.loadFaildBlock) {
            [ws performBlockOnMainThread:^{ if(ws.loadFaildBlock) ws.loadFaildBlock(error);}];
        }
    }];
    [_manager setCancelBlocks:^(){
        [ws.MBHUDView hide:YES];
        
        if (ws.loadCancelBlock) {
            [ws performBlockOnMainThread:^{ if(ws.loadCancelBlock) ws.loadCancelBlock();}];
        }
    }];
    [_manager setProgressBlocks:^(unsigned long long size, unsigned long long total){
        if (ws.MBHUDView) {
            float progressAmount = (float)((size*1.0)/(total*1.0));
            [ws.MBHUDView setProgress:progressAmount];
        }
        if (ws.loadProgressBlock) {
            [ws performBlockOnMainThread:^{ if(ws.loadProgressBlock) ws.loadProgressBlock(size,total);}];
        }
    }];
    [_manager setParameters:arr];
    [_manager connectWithNetworkType:type];
}
/**
 设置自定义请求方法
 只在设置使用自定义请求时候有用,其它请求方式不必使用,默认提供4种请求
 */
- (void)setZHNetworkLoadDataSource:(id<ZHNetworkLoadDataSource>)dataSourceObject{
    
    [self.manager setDataSourceObject:dataSourceObject];
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
    soap.soapName      = soapName;
    soap.soapXmlns     = xmlns;
    soap.soapXmlnsXsd  = xsd;
    soap.soapXmlnsXsi  = xsi;
    soap.soapBodyName  = bodyName;
    soap.soapBodyXmlns = bodyXmlns;
    self.soapConfig    = soap;
    
}
+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock{
    
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:nil connectType:0 URLString:nil interFaceHUD:0 HUDString:nil HUDBackgroundView:nil];
}
+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock{
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:cancelBlock connectType:0 URLString:nil interFaceHUD:0 HUDString:nil HUDBackgroundView:nil];
}
+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
            HUDBackgroundView:(UIView *)view{
    
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:nil connectType:0 URLString:nil interFaceHUD:ZHLoadHUDStyleDefault HUDString:HUD_STRING_DEFAULT HUDBackgroundView:view];
}

+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock
            HUDBackgroundView:(UIView *)view{
    
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:cancelBlock connectType:0 URLString:nil interFaceHUD:ZHLoadHUDStyleDefault HUDString:HUD_STRING_DEFAULT HUDBackgroundView:view];
}

+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
            HUDBackgroundView:(UIView *)view{
    
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:nil connectType:0 URLString:nil interFaceHUD:style HUDString:HUD_STRING_DEFAULT HUDBackgroundView:view];
}

+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
            HUDBackgroundView:(UIView *)view{
    
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:cancelBlock connectType:0 URLString:nil interFaceHUD:style HUDString:HUD_STRING_DEFAULT HUDBackgroundView:view];
}


+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
                    HUDString:(NSString *)string
            HUDBackgroundView:(UIView *)view{
    
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:nil connectType:0 URLString:nil interFaceHUD:style HUDString:string HUDBackgroundView:view];
}

+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
                    HUDString:(NSString *)string
            HUDBackgroundView:(UIView *)view{
    
    return [[self alloc] initWithBlocks:finshBlock faildBlock:faildBlock cancelBlock:cancelBlock connectType:0 URLString:nil interFaceHUD:style HUDString:string HUDBackgroundView:view];
}
#pragma -mack DataSource
- (id)ZHNetworkManager:(ZHNetworkManager *)manager analyZingWithData:(NSData *)data error:(NSError **)error{
    
    if (error!=NULL) {
        *error=[NSError errorWithDomain:@"未设置自定义解析方法" code:5 userInfo:nil];
    }
    return nil;
}
- (NSData *)ZHNetworkManager:(ZHNetworkManager *)manager cacheWithZHNetworkType:(ZHNetworkType)type{
    [NSException raise:@"自定义缓存错误" format:@"缓存方法未实现"];
    return nil;
}
- (void)ZHNetworkManager:(ZHNetworkManager *)manager responseData:(NSData *)data{
    
}

@end
