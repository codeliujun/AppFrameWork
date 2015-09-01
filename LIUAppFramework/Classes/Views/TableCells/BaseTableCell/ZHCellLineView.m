//
//  BCCellLineView.m
//  BookingCar
//
//  Created by Michael Shan on 14-11-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "ZHCellLineView.h"

@interface ZHCellLineView ()

@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation ZHCellLineView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setCellLineColor:(UIColor *)color {
    if (color) {
        self.lineColor = color;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGFloat lineWidth = .5f;
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetShouldAntialias(context, NO);
    if (!self.lineColor) {
        self.lineColor = kLightCellDescColor;
    }
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextMoveToPoint(context, 0, self.height-lineWidth);
    CGContextAddLineToPoint(context, self.width, self.height-lineWidth);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end
