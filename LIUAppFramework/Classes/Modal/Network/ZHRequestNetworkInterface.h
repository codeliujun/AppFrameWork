//
//  ZHRequestManager.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkInterface.h"

#define kServerIP       @"http://218.17.122.211:8080"
//#define kServerIP       @"http://192.168.0.233"
#define kApiUrl                 [NSString stringWithFormat:@"%@/Api", kServerIP]
#define kGetRequestUrl(method)  [NSString stringWithFormat:@"%@/%@", kApiUrl, method]
#define kGetImageUrl(relativePath)    [NSString stringWithFormat:@"%@%@", kServerIP, relativePath]

#define kRegistUrl                  @"user/register"                //注册
#define kLogin                      @"user/login"                   //登录
#define kCreatOrder                 @"order/createOrder"            //下单
#define kGetCityList                @"seting/getLetterArea"         //获取城市列表
#define kGetAttr                    @"seting/getAttr"               //获取语言，性别等
#define kGetSightList               @"seting/getSightList"          //获取旅游景点
#define kGetOrderDetail             @"order/findGuideOrderDetai"    //获取订单详情
#define kGetOrderList               @"order/touristFindGuideOrder"
#define kPayOrder                   @"order/touristPayOrder"
#define kConStartServe              @"order/touristConStartServe"   //订单开始
#define kConEndServe                @"order/touristConEndServe"     //订单完成
#define kEvalOrder                  @"order/touristEvalOrder"       //评价
#define kCancleOrder                @"order/touristCancelOrder"     //取消订单
#define kGetCoupon                  @"tourist/myCoupon"             //获取优惠券
#define kSendInsuranceInfo          @"tourist/saveInsuranceInfo"    //保存保险信息
#define kGetOrderPusNum             @"order/getOrderPushNum"        //获取推送导游个数
#define kGetChangeStatusLog         @"order/orderChangeStatusLog"   //获取订单日志
#define kSaveTouristInfo            @"tourist/saveInfo"             //保存游客信息
#define kRefreshOrderPush           @"order/refreshOrderPush"       //再次推送

typedef void (^ResultBlock)(NSDictionary *result);
typedef void (^ImageLoadBlock)(UIImage *image);

@interface ZHRequestNetworkInterface : ZHNetworkInterface

//+ (instancetype)requestManager;

/**
 *  @brief 网络请求
 *  @param type 请求类型
 *  @param parameters 请求参数
 *  @param successHandler 成功获取的处理方法
 *  @param errorHandler 获取失败的处理方法
 */
- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters successHandler:(ResultBlock)successBlock errorHandler:(ResultBlock)errorBlock;

/**
 *  @brief 获取图片
 *  @param url 图片url
 *  @param resultHandler 结果处理
 */
- (void)getImageWithUrl:(NSString *)url resultHandler:(ImageLoadBlock)block;

@end
