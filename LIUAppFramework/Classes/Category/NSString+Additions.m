//
//  NSString+Additions.m
//  BookingCar
//
//  Created by Michael Shan on 14-10-5.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

/* 验证email */
- (BOOL)validateEmail {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:self];
}

/* 验证手机号 */
- (BOOL)validatePhone {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578][0-9]\\d{8}"] evaluateWithObject:self];
}

/* 验证昵称 */
- (BOOL)validateNickname {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[\u4e00-\u9fa5a-zA-Z0-9]{1,24}"] evaluateWithObject:self];
}

- (BOOL)validateBusStation {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]{1,4}路"] evaluateWithObject:self];
}


+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (BOOL)isEmpty:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        if ([str length] > 0) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSString *)trim:(NSString *)str {
    while ([str hasPrefix:@" "]) {
        str = [str substringFromIndex:1];
    }
    
    while ([str hasSuffix:@" "]) {
        str = [str substringToIndex:str.length-1];
    }
    
    return str;
}

@end
