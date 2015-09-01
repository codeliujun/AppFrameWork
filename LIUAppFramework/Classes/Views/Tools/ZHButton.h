//
//  ZHButton.h
//  BookingCar
//
//  Created by Michael Shan on 14-10-1.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZHButton : UIButton

//初始化
- (id)initWithFrame:(CGRect)frame
                title:(NSString *)title
                target:(id)target
                action:(SEL)action
                gray:(BOOL)gray;

- (id)initWithFrame:(CGRect)frame
                title:(NSString *)title
                backgroundColor:(UIColor *)backgroundColor
                highlightColor:(UIColor *)highlightColor
                target:(id)target
                action:(SEL)action;

- (id)initWithBackGroundColor:(UIColor *)backgroundColor
                        HiglightColor:(UIColor *)highlightColor
                        Title:(NSString *)title
                        Target:(id)target
                        Action:(SEL)action;

- (void)setColor:(UIColor *)color highlightColor:(UIColor *)highlightColor;

@property(nonatomic,copy)   NSString *btnTitle;
@property(nonatomic,strong) UIColor  *btnTitleColor;
@property(nonatomic,assign) CGFloat  btnFontSize;

@end
