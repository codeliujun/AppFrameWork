//
//  ZHIndicatorView.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHIndicatorView.h"
#import "AppDelegate.h"
#define kDefaultWidth  80
#define kDefaultHeight 80

@interface ZHIndicatorView(){
@private
    UIActivityIndicatorView *_indicatorView;
}

@end

@implementation ZHIndicatorView
- (id)init{
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kDefaultWidth, kDefaultHeight);
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGRect indicatorFrame = _indicatorView.frame;
        _indicatorView.frame = CGRectMake((self.width - indicatorFrame.size.width)/2, (self.width - indicatorFrame.size.height)/2, indicatorFrame.size.width, indicatorFrame.size.height);
        [self addSubview:_indicatorView];
        self.backgroundColor = [UIColor clearColor];
        // Initialization code.
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context  = UIGraphicsGetCurrentContext();
    float fw = rect.size.width;
    float fh = rect.size.height;
    
    float r = 6;
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, r);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, r); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, r); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, r); // Back to lower right
    CGContextClosePath(context);
    CGFloat gray[4] = {0, 0, 0, 0.7f};
    CGContextSetFillColor(context, gray);
    CGContextFillPath(context);
}

- (void)dealloc {
}

- (void)show {
    UIWindow *window = [[ZHUtility appDelegate] window];
    [window addSubview:self];
    self.center = window.center;
    [_indicatorView startAnimating];
}

- (void)dismiss{
    if (self.superview) {
        [_indicatorView stopAnimating];
        [self removeFromSuperview];
    }
}

@end