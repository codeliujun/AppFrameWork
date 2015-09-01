//
//  ZHNetworkTools.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZHNetworkTools.h"
#import "ZHNetworkEntityClass.h"
#import "ZHNetworkDelegate.h"

/*
 *添加参数方法 parameterType为nil时候为默认值ZHNetworkParameterTypeDefault
 */
@interface NSMutableArray(addParameter)

- (void)addParameter:(NSString *)name
      parameterValue:(id)value
       parameterType:(ZHNetworkParameterType)Type;
@end

@implementation NSMutableArray(addParameter)
- (void)addParameter:(NSString *)name
      parameterValue:(id)value
       parameterType:(ZHNetworkParameterType)type{
    
    if (value && name) {
        ZHNetworkParameter *par=[[ZHNetworkParameter alloc] init];
        par.parameterName=name;
        par.parameterValue=value;
        if (type)
            par.parameterType=type;
        else
            par.parameterType=ZHNetworkParameterTypeDefault;
        [self addObject: par];//切换ARC所需加的参数
    }
}
@end

/*
 *删除NSString两边空格
 */
@interface NSString(whitespaceAndNewline)
- (NSString *)removeWhitespaceAndNewline;
@end
@implementation NSString(isJSONString)
- (NSString *)removeWhitespaceAndNewline{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end

/**
 *判断NSString是否是xml格式
 */
@interface NSString(XMLString)
- (BOOL)isXMLString;
@end
@implementation NSString(XMLString)
- (BOOL)isXMLString{
    if (self.length>5 && [[[self removeWhitespaceAndNewline] substringToIndex:5] isEqualToString:@"<?xml"])
        return YES;
    else
        return NO;
}
@end

/*
 *判断NSString是否是JSON格式
 */
@interface NSString(JSONString)
- (BOOL)isJSONString;
@end
@implementation NSString(JSONString)
- (BOOL)isJSONString{
    
    NSString *tempStr=[self removeWhitespaceAndNewline];
    NSString *a=[tempStr substringToIndex:1];
    NSString *b=[tempStr substringFromIndex:(tempStr.length-1)];
    if (([a isEqualToString:@"("] || [a isEqualToString:@"{"])&& ([b isEqualToString:@")"] || [b isEqualToString:@"}"])&&(([a isEqualToString:@"("] && [b isEqualToString:@")"])||([a isEqualToString:@"{"] && [b isEqualToString:@"}"])))
        return YES;
    else
        return NO;
}
@end

/*
 *NSString删除特殊字符
 */
@interface NSString(specialCharacters)
- (NSString *)removeSpecialCharacters;
@end
@implementation NSString(specialCharacters)
- (NSString *)removeSpecialCharacters{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSCharacterSet *set =[NSCharacterSet characterSetWithCharactersInString: @" ￡¤￥|§¨￠￢￣~——+|《》$_€"];
//    ZHLOG(@"self:%@",self);
    
    NSString *tempString=[[[[self stringByReplacingOccurrencesOfString:@"" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"null" withString:@"\"\"" ] stringByReplacingOccurrencesOfString:@"NULL" withString:@"\"\""];
//    ZHLOG(@"tempString:%@",tempString);
    
    return [self stringByTrimmingCharactersInSet:set];
}
@end

/*
 *NSString删除特殊字符
 */
@interface NSString(addXMLHeader)
- (NSString *)addXMLHeader;
@end
@implementation NSString(addXMLHeader)
- (NSString *)addXMLHeader{
    
    return [NSString stringWithFormat:@"%@%@",@"<?xml version=\"1.0\" encoding=\"utf-8\"?>",self];
}

@end
