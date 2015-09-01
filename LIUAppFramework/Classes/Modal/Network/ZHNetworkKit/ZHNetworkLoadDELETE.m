//
//  ZHNetworkLoadDELETE.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkLoadDELETE.h"

#import "ZHNetworkTools.h"
#import "ASIFormDataRequest.h"
#import "ZHNetworkEntityClass.h"

@implementation ZHNetworkLoadDELETE

- (ASIHTTPRequest *)requestWithZHNetworkLoad:(ZHNetworkManager *)manager{
    self.manager=manager;
    
    NSMutableString *URLString=[[NSMutableString alloc] initWithString:
                                [self.manager.URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSRange range=[self.manager.URLString rangeOfString:@"?"];
    for (int i=0; i<manager.parameters.count; i++) {
        
        ZHNetworkParameter *parameter=[manager.parameters objectAtIndex:i];
        if (i==0 && range.location==NSNotFound)
            [self addStringWithParameter:parameter isFirst:YES Mustring:URLString];
        else
            [self addStringWithParameter:parameter isFirst:NO Mustring:URLString];
    }
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request setRequestMethod:@"DELETE"];
    
#if NETWORK_DEBUG_LINKURL
    NETWORK_DEBUG_LOG(@"连接方式:DELETE--连接地址:%@",URLString);
#endif
    
#if NETWORK_DEBUG_SENDINFO
    NSMutableString *logInfoStr=[[NSMutableString alloc] init];
    for (int i=0; i<self.manager.parameters.count; i++) {
        ZHNetworkParameter *parameter=[self.manager.parameters objectAtIndex:i];
        [logInfoStr appendFormat:@"\n-> %d  参数名:%@  参数值:%@  参数形式:%ld",i+1,parameter.parameterName,parameter.parameterValue,parameter.parameterType];
    }
    NETWORK_DEBUG_LOG(@"连接方式:DELETE--发送的参数:%@",logInfoStr);
#endif
    return request;
}

- (void)addStringWithParameter:(ZHNetworkParameter *)parameter isFirst:(BOOL)yesNo Mustring:(NSMutableString *)string{
    
    if (yesNo) {
        [string appendFormat:@"?%@=%@",parameter.parameterName,parameter.parameterValue];
    }else{
        [string appendFormat:@"&%@=%@",parameter.parameterName,parameter.parameterValue];
    }
}

@end
