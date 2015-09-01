//
//  ZHToastView.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHToastView : UIView

@property(nonatomic,copy)NSString *toast;
@property(nonatomic,assign)NSInteger duration;
- (void)showInView:(UIView *)view;

@end
