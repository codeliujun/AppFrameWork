//
//  NSString+URLEncode.h
//  BookingCar
//
//  Created by Michael Shan on 14-12-14.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

// URL encode a string
+ (NSString *)URLEncodeString:(NSString *)string;
+ (NSString *)stringWithJsonObject:(id)jsonObject;

// Helper function
- (NSString *)URLEncodeString;

// Helper function 主要针对待办附件请求单独添加的方法
- (NSString *)URLEncodeDocument;

@end
