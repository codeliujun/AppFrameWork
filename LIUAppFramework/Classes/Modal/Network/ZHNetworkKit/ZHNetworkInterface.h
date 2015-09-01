//
//  ZHNetworkInterface.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetwork.h"
#import "ZHNetworkDelegate.h"
#import <MBProgressHUD.h>

#define HUD_STRING_DEFAULT @"正在加载.."

typedef NS_ENUM(NSInteger, ZHLoadHUDStyle) {
    
    //不显示加载视图
    ZHLoadHUDStyleNone               = 0,

    ///默认的加载模式
    ZHLoadHUDStyleDefault            = 1,

    //环状的进度条显示
    ZHLoadHUDStyleAnnularDeterminate = 2,

    //圆饼的进度条显示
    ZHLoadHUDStyleDeterminate        = 3,

    //自定义的视图显示
    ZHLoadHUDStyleCustomView         = 4,
    
} ;

@interface ZHNetworkQueue : NSObject

@property(nonatomic, strong) NSOperationQueue *queque;

+ (id)sharedQueue;
- (void)cancelAll;

@end

@interface ZHNetworkInterface : NSObject <ZHNetworkAnalyZingDataSource,ZHNetworkCacheDataSource>

@property(nonatomic, copy)ZHLoadFinishBlock loadFinshBlock;
@property(nonatomic, copy)ZHLoadFailedBlock loadFaildBlock;
@property(nonatomic, copy)ZHProgressBlock loadProgressBlock;
@property(nonatomic, copy)ZHLoadCancelBlock loadCancelBlock;
@property(nonatomic, copy)NSString  *URLString;
@property(nonatomic, assign)ZHNetworkType connectType;
@property(nonatomic, assign)ZHLoadHUDStyle HUDStyle;
@property(nonatomic, retain)MBProgressHUD  *MBHUDView;



@property(nonatomic, assign)ZHNetworkAnalyZingType analyZingType;
@property(nonatomic, assign)ZHNetworkCacheType cacheType;



//覆盖的HUD用径向渐变的背景视图。默认为NO
@property(nonatomic, assign)BOOL dimBackground;
//是否相应用户触摸事件。默认为NO
@property(nonatomic, assign)BOOL HUDUserInteractionEnabled;

+ (void)cancelAll;

- (void)cancel;



/**
 设置自定义请求方法
 只在设置使用自定义请求时候有用,其它请求方式不必使用,默认提供4种请求
 */
- (void)setZHNetworkLoadDataSource:(id<ZHNetworkLoadDataSource>)dataSourceObject;


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

- (void)starLoadInformationWithParameters:(NSArray *)arr URLString:(NSString *)string connectType:(ZHNetworkType)type;


+(id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                  faildBlock:(void (^)(NSError *err))faildBlock;


+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock;


+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
            HUDBackgroundView:(UIView *)view;


+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock
            HUDBackgroundView:(UIView *)view;



+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
            HUDBackgroundView:(UIView *)view;


+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
            HUDBackgroundView:(UIView *)view;


+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
                    HUDString:(NSString *)string
            HUDBackgroundView:(UIView *)view;


+ (id)interfaceWithFinshBlock:(void (^)(id responseObje))finshBlock
                   faildBlock:(void (^)(NSError *err))faildBlock
                  cancelBlock:(void(^)())cancelBlock
                 interFaceHUD:(ZHLoadHUDStyle)style
                    HUDString:(NSString *)string
            HUDBackgroundView:(UIView *)view;

@end
