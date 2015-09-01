//
//  ZHNetworkLoadJsonObject.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkLoadJsonObject.h"

#import "ZHNetworkTools.h"
#import "ASIFormDataRequest.h"
#import "ZHNetworkEntityClass.h"

// object to json， 引用的第三方库，
#import "NSObject+MJKeyValue.h"

#define method_KEY @"ZHNETWORK_method"
#define header_KEY @"ZHNETWORK_header"

#define headerValue_KEY @"ZHNETWORK_headerValue"
#define headerName_KEY @"ZHNETWORK_headerName"

@interface ZHNetworkLoadJsonObject ()

@property (nonatomic, strong) NSMutableDictionary *muDict_info;

@end

@implementation ZHNetworkLoadJsonObject

- (id)init {
    
    if ((self=[super init])) {
        
        _muDict_info=[[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setRequestMethod:(NSString *)method{
    
    
    [_muDict_info setObject:method forKey:method_KEY];
}
- (void)addRequestHeader:(NSString *)header value:(NSString *)value{
    //NSMutableArray *tempArr=[NSMutableArray array];
    if ([_muDict_info objectForKey:header_KEY]) {
        NSMutableArray *tempArr=[_muDict_info objectForKey:header_KEY];
        [tempArr addObject:@{headerName_KEY: header,headerValue_KEY: value}];
    } else {
        NSMutableArray *tempArr=[NSMutableArray array];
        [tempArr addObject:@{headerName_KEY: header,headerValue_KEY: value}];
        [_muDict_info setObject:tempArr forKey:header_KEY];
    }
}

- (ASIHTTPRequest *)requestWithZHNetworkLoad:(ZHNetworkManager *)manager {
    self.manager=manager;
    NSString *UTF8WithURLString=[self.manager.URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:UTF8WithURLString]];
    
    NSMutableDictionary  *tempDict=[[NSMutableDictionary alloc]init];
    for (ZHNetworkParameter *parameter in manager.parameters) {
        [tempDict setObject:parameter.parameterValue forKey:parameter.parameterName];
    }
    
    NSData *jsonData = [tempDict JSONData];
    [request appendPostData:jsonData];
    
    if ([_muDict_info objectForKey:method_KEY]) {
        [request setRequestMethod:[_muDict_info objectForKey:method_KEY]];
    }
    if ([_muDict_info objectForKey:header_KEY]) {
        NSMutableArray *tempArr=[_muDict_info objectForKey:header_KEY];
        [tempArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            
            [request addRequestHeader:[obj objectForKey:headerName_KEY] value:[obj objectForKey:headerValue_KEY]];
        }];
    }
    
#if NETWORK_DEBUG_LINKURL
    NETWORK_DEBUG_LOG(@"连接方式:POST--连接地址:%@",UTF8WithURLString);
#endif
#if NETWORK_DEBUG_SENDINFO
    NSString *postStr=[[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
    NETWORK_DEBUG_LOG(@"连接方式:POST  \n------>发送的参数:\n%@\n<------",postStr);
#endif
    jsonData = nil;
    return request;
}

@end

