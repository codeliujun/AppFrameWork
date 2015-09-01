//
//  ZHNetworkLoadPUT.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkLoadPUT.h"

#import "ZHNetworkTools.h"
#import "ASIFormDataRequest.h"
#import "ZHNetworkEntityClass.h"

@implementation ZHNetworkLoadPUT

- (ASIHTTPRequest *)requestWithZHNetworkLoad:(ZHNetworkManager *)manager{
    self.manager = manager;
    NSString *UTF8WithURLString=[self.manager.URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:UTF8WithURLString]];
    for (ZHNetworkParameter *parameter in manager.parameters) {
        if ([parameter.parameterValue isKindOfClass:[NSData class]]){
            
            [request appendPostData:parameter.parameterValue];
            [request setRequestMethod:@"PUT"];
        }
        else
            [NSException raise:@"参数错误" format:@"当属性为ZHNetworkParameterTypePUT时候参数必须是NSData类型"];
    }
    
#if NETWORK_DEBUG_LINKURL
    NETWORK_DEBUG_LOG(@"连接方式:PUT--连接地址:%@",UTF8WithURLString);
#endif
#if NETWORK_DEBUG_SENDINFO
    NSString *postStr = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
    NETWORK_DEBUG_LOG(@"连接方式:PUT--发送的参数:%@",postStr);
#endif
    return request;
}


@end
