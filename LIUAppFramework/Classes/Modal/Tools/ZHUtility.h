//
//  ZHUtility.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ZHUtility : NSObject

+ (void)saveSetting:(id)value withKey:(NSString *)key;
+ (id)getValueWithKey:(NSString *)key;
+ (id)restoreSetting:(NSString *)key;

+ (AppDelegate *)appDelegate;
+ (UIWindow *)appKeyWindow;

+ (void)viewAutoLay:(UIView *)allView;

@end
