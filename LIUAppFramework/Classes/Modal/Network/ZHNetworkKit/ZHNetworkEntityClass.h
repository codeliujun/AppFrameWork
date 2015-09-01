//
//  ZHNetworkEntityClass.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkDelegate.h"

@interface ZHNetworkEntityClass : NSObject

@end

/**
 参数实体类
 */
@interface ZHNetworkParameter : NSObject
@property(nonatomic, copy)NSString *parameterName;//参数名称
@property(nonatomic, copy)id parameterValue;//参数值
@property(nonatomic )ZHNetworkParameterType parameterType;//参数类型
@end


/**
 SOAP配置实体类
 */
@interface ZHNetworkSOPAEntityClass : NSObject
@property(nonatomic, copy)NSString *soapName;
@property(nonatomic, copy)NSString *soapXmlns;
@property(nonatomic, copy)NSString *soapXmlnsXsd;
@property(nonatomic, copy)NSString *soapXmlnsXsi;
@property(nonatomic, copy)NSString *soapBodyName;
@property(nonatomic, copy)NSString *soapBodyXmlns;
@end
