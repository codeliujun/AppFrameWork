//
//  ZHRequestManager.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkInterface.h"

#define kServerIP       @"http://api.coolgou.com"
//#define kServerIP       @"http://192.168.0.233"
#define kApiUrl                 [NSString stringWithFormat:@"%@/api", kServerIP]
#define kGetRequestUrl(method)  [NSString stringWithFormat:@"%@/%@", kApiUrl, method]
#define kGetImageUrl(relativePath)    [NSString stringWithFormat:@"%@%@", kServerIP, relativePath]
#define kLoginUrl                   @"User/login" //登录
#define kRegisterUrl                @"User/register" //注册
#define kAuthcodeUrl                @"User/authcode" //获取验证码
#define kGetHotVocabulary           @"Product/hotkey"//获取热门词汇
#define kSearchGoods                @"Product/search"//搜索商品
#define kAddGood                    @"Cart/add"//添加到购物车
#define kGetCartGood                @"Cart/list"//获取购物车
#define kChangeGoodCOunt            @"Cart/updatecount"//更改数量
#define kDeletedGood                @"Cart/delete"//删除购物车
#define kGetGoodComment             @"Goods/comments"//获取商品评论
#define kCreatOrder                 @"Cart/settlement"//将商品转换为订单
#define kCreatNo                    @"Cart/BuildNo"
#define KGetOrderList               @"Order/list"//获取订单列表
#define kGetAddressList             @"Address/list"//获取地址列表
#define kGetFirstCater              @"Category/top"//获取一级分类
#define kGetSecondCater             @"Category/second"//获取二级分类
#define kGetInventor                @"Shop/inventory" //获取库存
#define kAddAddress                 @"Address/add"
#define kUpdataAddress              @"Address/update"
#define kPayOrder                   @"Order/pay"
#define kAddComment                 @"Goods/addcomment"
#define kGetRecomment               @"Product/hotproducts"


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
