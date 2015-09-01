//
//  ZHNetworkConfig.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQUST_TIMEOUT 20  //默认超时时间
#define REQUST_RESET 2   //默认失败重置次数

#define PROXY_ADDRESS @"127.0.0.1"
#define PROXY_PORT 8080


# define ZHLOG(...) NSLog(__VA_ARGS__);

#ifndef NETWORK_DEBUG_LOG
#define NETWORK_DEBUG_LOG NSLog
#endif


/*
 *是否开启设置代理
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_PROXY
#define NETWORK_DEBUG_PROXY 0
#endif



/*
 *是否开启调试netWork运行信息
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_FIG
#define NETWORK_DEBUG_FIG (DEBUG)?1:0
#endif

/*
 *是否开启调试netWork发送数据信息
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_SENDINFO
#define NETWORK_DEBUG_SENDINFO (DEBUG)?1:0
#endif

/*
 *是否开启调试netWork连接地址
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_LINKURL
#define NETWORK_DEBUG_LINKURL (DEBUG)?1:0
#endif


/*
 *是否开启调试netWork连接获取的原始数据
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_RESPONSE_STRING
#define NETWORK_DEBUG_RESPONSE_STRING (DEBUG)?1:0
#endif


/*
 *是否开启调试缓存相关信息
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_RESPONSE_CACHE
#define NETWORK_DEBUG_RESPONSE_CACHE (DEBUG)?1:0
#endif

/*
 *是否开启调试解析相关信息
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_ANALYZING
#define NETWORK_DEBUG_ANALYZING (DEBUG)?1:0
#endif


/*
 *是否开启调试取消连接相关信息
 0->off
 1->on
 */
#ifndef NETWORK_DEBUG_CANCEL
#define NETWORK_DEBUG_CANCEL (DEBUG)?1:0
#endif
