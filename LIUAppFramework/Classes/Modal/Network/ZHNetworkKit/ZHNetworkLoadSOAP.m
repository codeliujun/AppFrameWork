//
//  ZHNetworkLoadSOAP.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkLoadSOAP.h"

#import <XMLDictionary.h>
#import <ASIFormDataRequest.h>

#import "ZHNetworkEntityClass.h"
#import "ZHNetworkTools.h"

@interface ZHNetworkLoadSOAP () {
    
    ZHNetworkSOPAEntityClass *soapConfig;
}

- (void)buildXMLDict;

@end

@implementation ZHNetworkLoadSOAP

- (id)init{
    
    if ((self=[super init])) {
        _XMLDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (ASIHTTPRequest *)requestWithZHNetworkLoad:(ZHNetworkManager *)manager {
    self.manager = manager;
    soapConfig = manager.soapConfig;
    [self buildXMLDict];
    NSString *UTF8WithURLString=[self.manager.URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:UTF8WithURLString]];
    NSString *soapStr = [[self.XMLDict XMLString] addXMLHeader];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", [soapStr length]];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:msgLength];
    [request appendPostData:[soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    
#if NETWORK_DEBUG_LINKURL
    NETWORK_DEBUG_LOG(@"连接方式:SOAP--连接地址:%@",manager.URLString);
#endif
    
#if NETWORK_DEBUG_SENDINFO
    NETWORK_DEBUG_LOG(@"连接方式:SOAP--发送的数据:%@",soapStr);
#endif
    return request;
}
- (void)buildXMLDict{
    
    [_XMLDict setObject:soapConfig.soapName forKey:@"__name"];
    [_XMLDict setObject:soapConfig.soapXmlns forKey:@"_xmlns:soap"];
    [_XMLDict setObject:soapConfig.soapXmlnsXsd forKey:@"_xmlns:xsd"];
    [_XMLDict setObject:soapConfig.soapXmlnsXsi forKey:@"_xmlns:xsi"];
    NSMutableDictionary *bodyDict=[NSMutableDictionary dictionary];
    for (ZHNetworkParameter *parameter in self.manager.parameters) {
        [bodyDict setObject:parameter.parameterValue forKey:parameter.parameterName];
    }
    [bodyDict setObject:soapConfig.soapBodyName forKey:@"__name"];
    [bodyDict setObject:soapConfig.soapBodyXmlns forKey:@"_xmlns"];
    NSDictionary *soapDict=[NSDictionary dictionaryWithObjectsAndKeys:bodyDict,soapConfig.soapBodyName,@"soap:Body",@"__name", nil];
    [_XMLDict setObject:soapDict forKey:@"soap:Body"];
}

@end
