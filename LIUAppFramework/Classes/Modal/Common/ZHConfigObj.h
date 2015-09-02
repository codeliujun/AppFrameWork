//
//  ZHConfigObj.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZHUserObject.h"

@interface ZHConfigObj : NSObject {
    
}

+ (instancetype)configObject;

- (void)save;//保存用户数据

@property (nonatomic, strong) ZHUserObject *userObject;

@end
