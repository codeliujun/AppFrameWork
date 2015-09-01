//
//  ZHBaseNavigationController.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBaseNavigationController : UINavigationController

@property(nonatomic,weak) UIViewController* currentShowVC;

@end

@interface UINavigationBar (BackgroundImage)

/*
 *  设置navigationBar 背景
 */
- (void)setBackgroundImageWithColor:(UIColor *)color;

@end