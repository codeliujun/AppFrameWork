//
//  ZHNetworkValidate.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkValidate.h"

@implementation ZHNetworkValidate

static ZHNetworkValidate* __validate;
/*
 单例模式
 */
+ (ZHNetworkValidate *)sharedValidate{
    if (!__validate) {
        __validate = [[ZHNetworkValidate alloc] init];
    }
    return __validate;
}

/*
 验证email
 */
- (BOOL)validateEmail:(NSString*)email
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:email];
}
/*
 验证手机号
 */
- (BOOL)validatePhone:(NSString*)phone{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[3458][0-9]\\d{8}"] evaluateWithObject:phone];
}

/*
 验证昵称
 */
- (BOOL)validateNickname:(NSString*)nickname{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[\u4e00-\u9fa5a-zA-Z0-9]{1,24}"] evaluateWithObject:nickname];
}

@end
