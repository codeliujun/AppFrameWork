//
//  ZHButton.m
//  BookingCar
//
//  Created by Michael Shan on 14-10-1.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "ZHButton.h"

#define kCornerRadius       5
#define kFontSize           18

@interface ZHButton() {
@private
    UIColor *_normalColor;
    UIColor *_highlightColor;
}

@end

@implementation ZHButton

#pragma mark- init

- (id)initWithFrame:(CGRect)frame                        title:(NSString *)title
             target:(id)target                          action:(SEL)action
               gray:(BOOL)gray
{
    
    if (gray){
        return [self initWithFrame:frame
                             title:title
                   backgroundColor:kGrayBtnNormalColor
                    highlightColor:kGrayBtnSelectedColor
                            target:target
                            action:action];
    }else{
        return [self initWithFrame:frame
                             title:title
                   backgroundColor:kBlueBtnNormalColor
                    highlightColor:kBlueBtnSelectedColor
                            target:target
                            action:action];
    }
}


- (id)initWithFrame:(CGRect)frame                        title:(NSString *)title
    backgroundColor:(UIColor *)backgroundColor  highlightColor:(UIColor *)highlightColor
             target:(id)target                          action:(SEL)action
{
    self = [super init];
    if (self) {
        [self setup];
        self.frame = frame;
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        [self.titleLabel setFont:[UIFont systemFontOfSize:kFontSize]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setColor:backgroundColor highlightColor:highlightColor];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithBackGroundColor:(UIColor *)backgroundColor
                    HiglightColor:(UIColor *)highlightColor
                    Title:(NSString *)title
                    Target:(id)target
                    Action:(SEL)action {
    
    if (self = [super init]) {
        [self setup];//
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        [self.titleLabel setFont:[UIFont systemFontOfSize:kFontSize]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (!backgroundColor) {
            backgroundColor = kBlueBtnNormalColor;
            highlightColor = kBlueBtnSelectedColor;
        }
        else if (!highlightColor) {
            highlightColor = backgroundColor;
        }
        
        [self setColor:backgroundColor highlightColor:highlightColor];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithColor:(UIColor *)color highlightColor:(UIColor *)highlightColor{
    self = [super init];
    if (self) {
        [self setup];
        [self setColor:color highlightColor:highlightColor];
    }
    return self;
}

//xib 使用

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        [self setColor:kBlueBtnNormalColor highlightColor:kBlueBtnSelectedColor];
    }
    return self;
}


#pragma mark- ui


- (void)setup{
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBtnTitle:(NSString *)btnTitle{
    [self setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)setBtnTitleColor:(UIColor *)btnTitleColor{
    [self setTitleColor:btnTitleColor forState:UIControlStateNormal];
}

- (void)setBtnFontSize:(CGFloat)btnFontSize{
    [self.titleLabel setFont:[UIFont systemFontOfSize:btnFontSize]];
}


#pragma mark- action

- (void)setColor:(UIColor *)color highlightColor:(UIColor *)highlightColor{
    _normalColor = color;
    _highlightColor = highlightColor;
    self.backgroundColor = _normalColor;
    [self addTarget:self action:@selector(changeColor)  forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(restoreColor) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(restoreColor) forControlEvents:UIControlEventTouchCancel];
    [self addTarget:self action:@selector(restoreColor) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)changeColor{
    self.backgroundColor = _highlightColor;
}

- (void)restoreColor{
    self.backgroundColor = _normalColor;
}


@end
