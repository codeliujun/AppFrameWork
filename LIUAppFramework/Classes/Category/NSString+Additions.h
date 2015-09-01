//
//  NSString+Additions.h
//  BookingCar
//
//  Created by Michael Shan on 14-10-5.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Additions)

/* 验证email */
- (BOOL)validateEmail;

/* 验证手机号 */
- (BOOL)validatePhone;

/* 验证昵称 */
- (BOOL)validateNickname;

+ (NSString *)md5:(NSString *)str;

+ (BOOL)isEmpty:(NSString *)str;

+ (NSString *)trim:(NSString *)str;

@end
