//
//  ZHNetworkValidate.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNetworkValidate : NSObject

/*
 单例模式
 */
+ (ZHNetworkValidate *)sharedValidate;

/*
 验证email
 */
- (BOOL)validateEmail:(NSString*)email;
/*
 验证手机号
 */
- (BOOL)validatePhone:(NSString*)phone;

/*
 验证昵称
 */
- (BOOL)validateNickname:(NSString*)nickname;

@end
