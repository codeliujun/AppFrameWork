//
//  ZHToastView.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHToastView.h"

#define kLeftMargin  10
#define kFontSize    14.0f
#define kMaxWidth    280
#define kDuration    1

@interface ZHToastView () {
    
@private
    UILabel *_label;
    
}

@end

@implementation ZHToastView

- (id)init{
    self = [super init];
    if (self) {
        self.alpha = 0;
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius  = 5.0f;
        self.layer.masksToBounds = YES;
        self.duration = kDuration;
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:kFontSize];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 0 ;
        [self addSubview:_label];
    }
    return self;
}

- (void)setToast:(NSString *)toast{
    CGSize size  = CGSizeZero;
    CGSize size1 = CGSizeZero;
    CGSize size2 = CGSizeZero;
    
    //添加属性
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_label.font forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = 5;
    [dic setValue:style forKey:NSParagraphStyleAttributeName];
    
    // NSStringDrawingUsesLineFragmentOrigin 用于计算行高的参数
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        //指定的高度求最大宽度
        CGRect  bound = [toast boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        size1 = bound.size;
        
        //指定的宽度求最大高度
        CGRect  bound2 = [toast boundingRectWithSize:CGSizeMake(kMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        size2 = bound2.size;
        
    }else{
        //指定的高度求最大宽度
        size1 = [toast sizeWithFont:_label.font constrainedToSize:CGSizeMake(MAXFLOAT, 21) lineBreakMode:NSLineBreakByWordWrapping];
        
        //指定的宽度求最大高度
        size2 = [toast sizeWithFont:_label.font constrainedToSize:CGSizeMake(kMaxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    if (size1.width > kMaxWidth) {
        size = size2;
    }else{
        size = size1;
    }
    _label.text = toast;
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(size.width + kLeftMargin * 2, size.height + kLeftMargin * 2);
    self.frame = frame;
    _label.frame = CGRectMake(kLeftMargin, kLeftMargin, size.width, size.height);
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    self.center = CGPointMake(view.center.x, view.center.y);
    self.alpha  = 1;
    [self performSelector:@selector(hidden) withObject:nil afterDelay:self.duration];
}

- (void)hidden{
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0 ;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}


@end
