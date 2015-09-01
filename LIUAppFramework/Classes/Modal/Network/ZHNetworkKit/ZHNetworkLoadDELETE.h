//
//  ZHNetworkLoadDELETE.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNetworkManager.h"

@interface ZHNetworkLoadDELETE : NSObject <ZHNetworkLoadDataSource>

@property(nonatomic, assign) ZHNetworkManager *manager;

@end
