//
//  UIImage+Additions.m
//  BookingCar
//
//  Created by Michael Shan on 14-11-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "UIImage+Additions.h"

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees*M_PI/180;
}

CGFloat RadiansToDegrees(CGFloat radians) {
    return radians*180/M_PI;
}

@implementation UIImage (TintColor)

- (UIImage *)imageWithTintColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [self drawInRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size tintColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    //填充区域
    CGContextFillRect(context, rect);
    //绘制区域
    //    CGContextStrokeRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size cornerRadius:(CGFloat) cornerRadius tintColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = color;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)imageWithRotatedByRadians:(CGFloat)radians{
    return [self  imageWithRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageWithRotatedByDegrees:(CGFloat)degrees{
    
    UIView *rotatedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedView.transform = transform;
    CGSize rotatedSize = rotatedView.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(context, DegreesToRadians(degrees));
    //绘制
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height), self.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

- (UIImage*)resizeImageToSize:(CGSize)newSize resizeMode:(ResizeMode)resizeMode {
    CGRect drawRect = [self caculateDrawRect:newSize resizeMode:resizeMode];
    DBLog(@"drawRect:%@",NSStringFromCGRect(drawRect));
    UIGraphicsBeginImageContext(newSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    
    CGContextSetInterpolationQuality(context, 0.8);
    
    [self drawInRect:drawRect blendMode:kCGBlendModeNormal alpha:1];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// caculate drawrect respect to specific resize mode
- (CGRect)caculateDrawRect:(CGSize)newSize resizeMode:(ResizeMode)resizeMode
{
    CGRect drawRect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    CGFloat imageRatio = self.size.width / self.size.height;
    CGFloat newSizeRatio = newSize.width / newSize.height;
    
    switch (resizeMode) {
        case ResizeModeScale:
        {
            // scale to fill
            break;
        }
        case ResizeModeAspectFit:                    // any remain area is white
        {
            CGFloat newHeight = 0;
            CGFloat newWidth = 0;
            if (newSizeRatio >= imageRatio) {        // max height is newSize.height
                newHeight = newSize.height;
                newWidth = newHeight * imageRatio;
            }
            else {
                newWidth = newSize.width;
                newHeight = newWidth / imageRatio;
            }
            
            drawRect.size.width = newWidth;
            drawRect.size.height = newHeight;
            
            drawRect.origin.x = newSize.width / 2 - newWidth / 2;
            drawRect.origin.y = newSize.height / 2 - newHeight / 2;
            
            break;
        }
        case ResizeModeAspectFill:
        {
            CGFloat newHeight = 0;
            CGFloat newWidth = 0;
            if (newSizeRatio >= imageRatio) {        // max height is newSize.height
                newWidth = newSize.width;
                newHeight = newWidth / imageRatio;
            }
            else {
                newHeight = newSize.height;
                newWidth = newHeight * imageRatio;
            }
            
            drawRect.size.width = newWidth;
            drawRect.size.height = newHeight;
            
            drawRect.origin.x = newSize.width / 2 - newWidth / 2;
            drawRect.origin.y = newSize.height / 2 - newHeight / 2;
            
            break;
        }
        default:
            break;
    }
    
    return drawRect;
}

+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width {
    CGSize size = image.size;
    size.height = size.height * width/size.width;
    size.width = width;
    UIGraphicsBeginImageContext(size);
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:r];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end