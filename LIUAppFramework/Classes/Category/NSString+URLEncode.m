//
//  NSString+URLEncode.m
//  BookingCar
//
//  Created by Michael Shan on 14-12-14.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

// URL encode a string
+ (NSString *)URLEncodeString:(NSString *)string {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("% '\"?=&+<>;:-"), kCFStringEncodingUTF8));
    return result ;
}

// Helper function
- (NSString *)URLEncodeString {
    return [NSString URLEncodeString:self];
}

// Helper function 主要针对待办附件请求单独添加的方法
- (NSString *)URLEncodeDocument{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!$&'()*+,-./:;=?@_~%#[]"),kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)stringWithJsonObject:(id)jsonObject {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        DBLog(@"error:%@",error);
        return nil;
    }
    NSString *encodeStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    DBLog(@"encodeStr before:%@",encodeStr);
    encodeStr =  [encodeStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DBLog(@"encodeStr after :%@",encodeStr);
    return encodeStr;
}

@end
