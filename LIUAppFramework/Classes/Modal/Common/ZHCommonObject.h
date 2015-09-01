//
//  ZHCommonObject.h
//  BookingCar
//
//  Created by Michael Shan on 14-10-9.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCommonObject : NSObject

+ (instancetype)sharedObject;

+ (void)deselectTable:(UITableView *)tableView animated:(BOOL)animated;
//+ (CLLocationDistance)getCLLocationDistance:(CLLocationCoordinate2D)coordinateA TheTowCoordinate:(CLLocationCoordinate2D)coordinateB;

+ (BOOL)checkLogin:(UIViewController *)controller;
+ (void)showLocationServiceAlert;

+ (void)showAlert:(NSString *)alertStr;

+ (UITabBarController *)prepareTabbars;

@end
