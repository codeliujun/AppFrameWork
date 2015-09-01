//
//  ZHNetworkLoadJsonObject.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkManager.h"

/*===================>
 针对发送参数为json字符串
 <===================*/

@interface ZHNetworkLoadJsonObject : NSObject<ZHNetworkLoadDataSource>

@property(nonatomic, assign) ZHNetworkManager *manager;

- (void)setRequestMethod:(NSString *)method;
- (void)addRequestHeader:(NSString *)header value:(NSString *)value;

@end
