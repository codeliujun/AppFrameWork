//
//  ZHNetworkLoadDefault.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkLoadDefault.h"

#import "ZHNetworkTools.h"
#import "ZHNetworkEntityClass.h"
#import <ASIHTTPRequest.h>
#import <ASIFormDataRequest.h>

@interface ZHNetworkLoadDefault () {
    NSMutableArray  *formArr;
    NSMutableArray  *commonArr;
    BOOL             isFirstparameterCommon;
}

- (ASIHTTPRequest *)requestWithGET:(NSArray *)parameters;
- (ASIHTTPRequest *)requestWithPOST:(NSArray *)parameters;
- (void)distributeParameters:(NSArray *)parameters;

@end

@implementation ZHNetworkLoadDefault

- (id)init {
    
    if (self = [super init]) {
        formArr = [[NSMutableArray alloc] init];
        commonArr = [[NSMutableArray alloc] init];
        isFirstparameterCommon = YES;
    }
    return self;
}

- (ASIHTTPRequest *)requestWithZHNetworkLoad:(ZHNetworkManager *)manager{
    self.manager=manager;
    if (self.manager.workType == ZHNetworkTypeGet)
        return [self requestWithGET:manager.parameters];
    else if (self.manager.workType == ZHNetworkTypePost)
        return [self requestWithPOST:manager.parameters];
    return nil;
}

- (void)addStringWithParameter:(ZHNetworkParameter *)parameter isFirst:(BOOL)yesNo Mustring:(NSMutableString *)string{
    
    if (yesNo) {
        [string appendFormat:@"?%@=%@",parameter.parameterName,parameter.parameterValue];
    }else{
        [string appendFormat:@"&%@=%@",parameter.parameterName,parameter.parameterValue];
    }
}

- (void)distributeParameters:(NSArray *)parameters{
    [commonArr removeAllObjects];
    [formArr removeAllObjects];
    
    for (ZHNetworkParameter *parameter in parameters) {
        if ([parameter isKindOfClass:[ZHNetworkParameter class]] && parameter.parameterType == ZHNetworkParameterTypeDefault) {
            [commonArr addObject:parameters];
        }else if ([parameter isKindOfClass:[ZHNetworkParameter class]]){
            [formArr addObject:parameters];
        }
    }
    
}
- (ASIHTTPRequest *)requestWithGET:(NSArray *)parameters{
    
    NSMutableString *URLString=[[NSMutableString alloc] initWithString:
                                self.manager.URLString];
    NSRange range=[self.manager.URLString rangeOfString:@"?"];
    id request=nil;
    [self distributeParameters:parameters];
    for (int i=0; i<commonArr.count; i++) {
        
        ZHNetworkParameter *parameter=[parameters objectAtIndex:i];
        if (i==0 && range.location==NSNotFound)
            [self addStringWithParameter:parameter isFirst:YES Mustring:URLString];
        else
            [self addStringWithParameter:parameter isFirst:NO Mustring:URLString];
    }
    
    if (formArr.count>0) {
        request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        for (int i=0; i<formArr.count; i++) {
            
            ZHNetworkParameter *parameter=[parameters objectAtIndex:i];
            if (parameter.parameterType == ZHNetworkParameterTypeForm) {
                if ([parameter.parameterValue isKindOfClass:[NSData class]])
                    [request addData:parameter.parameterValue forKey:parameter.parameterName];
                else
                    [NSException raise:@"参数错误" format:@"当属性为ZHNetworkParameterTypeForm时候参数必须是NSData类型"];
                
            } else if(parameter.parameterType == ZHNetworkParameterTypeFormPath) {
                
                if ([parameter.parameterValue isKindOfClass:[NSString class]])
                    [request setFile:parameter.parameterValue forKey:parameter.parameterName];
                else
                    [NSException raise:@"参数错误" format:@"当属性为ZHNetworkParameterTypeFormPath时候参数必须是路径"];
            }
            
        }
        
    }else
        request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
#if NETWORK_DEBUG_LINKURL
    NETWORK_DEBUG_LOG(@"连接方式:GET--连接地址:%@",[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
#endif
#if NETWORK_DEBUG_SENDINFO
    NSMutableString *logInfoStr=[[NSMutableString alloc] init];
    for (int i=0; i<self.manager.parameters.count; i++) {
        ZHNetworkParameter *parameter = [parameters objectAtIndex:i];
        [logInfoStr appendFormat:@"\n-> %d  参数名:%@  参数值:%@  参数形式:%ld",i+1,parameter.parameterName,parameter.parameterValue, parameter.parameterType];
    }
    NETWORK_DEBUG_LOG(@"连接方式:GET--发送的参数:%@",logInfoStr);
#endif
    
    return request;
}

- (ASIHTTPRequest *)requestWithPOST:(NSArray *)parameters{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.manager.URLString]];
    for (ZHNetworkParameter *parameter in parameters) {
        
        if (parameter.parameterType == ZHNetworkParameterTypeDefault)
            [request setPostValue:parameter.parameterValue forKey:parameter.parameterName];
        else if (parameter.parameterType == ZHNetworkParameterTypeForm) {
            if ([parameter.parameterValue isKindOfClass:[NSData class]])
                @try {
                    [UIImage imageWithData:parameter.parameterValue];
                    [request setData:parameter.parameterValue withFileName:@"user.jpg" andContentType:@"image/jpeg" forKey:parameter.parameterName];
                }@catch (NSException *exception) {
                    [request addData:parameter.parameterValue forKey:parameter.parameterName];
                }
            else
                [NSException raise:@"参数错误" format:@"当属性为ZHNetworkParameterTypeForm时候参数必须是NSData类型"];
        } else if (parameter.parameterType == ZHNetworkParameterTypeFormPath) {
            
            if ([parameter.parameterValue isKindOfClass:[NSString class]])
                [request setFile:parameter.parameterValue forKey:parameter.parameterName];
            else
                [NSException raise:@"参数错误" format:@"当属性为ZHNetworkParameterTypeFormPath时候参数必须是路径"];
        }
    }
    
#if NETWORK_DEBUG_LINKURL
    NETWORK_DEBUG_LOG(@"连接方式:POST--连接地址:%@",self.manager.URLString);
#endif
#if NETWORK_DEBUG_SENDINFO
    NSMutableString *logInfoStr=[[NSMutableString alloc] init];
    for (int i=0; i<self.manager.parameters.count; i++) {
        ZHNetworkParameter *parameter=[parameters objectAtIndex:i];
        if ([parameter.parameterValue respondsToSelector:@selector(length)]) {
            NSInteger length = (NSInteger)[parameter.parameterValue performSelector:@selector(length) withObject:nil];
            if (length > 100) {
                [logInfoStr appendFormat:@"\n-> %d  参数名:%@  data大小:%ld  参数形式:%ld",i+1,parameter.parameterName,[(NSData *)parameter.parameterValue length], parameter.parameterType];
            }
        } else {
            [logInfoStr appendFormat:@"\n-> %d  参数名:%@  参数值:%@  参数形式:%ld",i+1,parameter.parameterName,parameter.parameterValue, parameter.parameterType];
        }
    }
    NETWORK_DEBUG_LOG(@"连接方式:POST--发送的参数:%@",logInfoStr);
#endif
    
    
    return request;
}

@end
