//
//  GlobalConfigs.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

/**
 * 定义macro
 */

#ifndef ZHTourist_GlobalConfigs_h
#define ZHTourist_GlobalConfigs_h

#pragma mark- UINavigationBar
//导航栏高度
#define kNavigationBarHeight 44

#pragma mark- UIStatusBar
//状态栏高度
#define kStatusBarHeight      20

#pragma mark- UIDevice

//系统版本
#define kSystemVersion                  [[[UIDevice currentDevice]systemVersion] floatValue]
#define kAppName                        [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleNameKey]
#define kAppVersion                     [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey]
#define kAppBundleIdentifier            [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey]

#pragma mark- UIScreen
//屏幕宽
#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height

//手机屏幕
#define IPHONE_4S_SCREEN_HEIGHT          480
#define IPHONE_5_5S_SCREEN_HEIGHT        568
#define IPHONE_6_SCREEN_HEIGHT           667
#define IPHONE_6P_SCREEN_HEIGHT          736

#define AutoSizeScaleX                  ((kScreenHeight > 480)?(kScreenWidth/320):1.0)
#define AutoSizeScaleY                  ((kScreenHeight > 480)?(kScreenHeight/568):1.0)

#define CGRectMake1(x,y,width,height)   CGRectMake((x)*AutoSizeScaleX, (y)*AutoSizeScaleY, (width)*AutoSizeScaleX, (height)*AutoSizeScaleY)
#define CGPointMake1(x,y)               CGPointMake((x)*AutoSizeScaleX, (y)*AutoSizeScaleY)


#pragma mark- UIColor
#define kColorRGB(R,G,B)                [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]
#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kColorHexString(hexStr)         [UIColor colorWithHexString:hexStr]

/*
 *__FILE__              当前调试所在的源文件名 [文件名:%s]    __FILE__
 *__FUNCTION__          当前调试所在的函数名称 [函数名:%s]    __FUNCTION__
 *__PRETTY_FUNCTION__   当前调试所在的函数名称 [函数名:%s]    __PRETTY_FUNCTION__
 *__LINE__              当前调试所在的行号     [行号:%d]     __LINE__
 *__VA_ARGS__           当前调试可携带的参数     fmt         __VA_ARGS__
 */

#ifdef DEBUG
#define DBLog(fmt,...) NSLog((@"\n函数名:%s\n行号:%d\n"fmt"\n\n"),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DBLog(...)
#endif

#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#pragma mark- GCD
#define kGlobalQueue(block)         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kMainQueue(block)           dispatch_async(dispatch_get_main_queue(),block)

#pragma mark- WeakSelf
#define WS(weakSelf) __weak __typeof(&*self)weakSelf=self


#endif
