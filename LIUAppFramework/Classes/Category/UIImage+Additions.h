//
//  UIImage+Additions.h
//  BookingCar
//
//  Created by Michael Shan on 14-11-10.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);

typedef NS_ENUM(NSInteger, ResizeMode){
    ResizeModeScale,            // image scaled to fill
    ResizeModeAspectFit,        // image scaled to fit with fixed aspect. remainder is transparent
    ResizeModeAspectFill,       // image scaled to fill with fixed aspect. some portion of content may be cliped
};

@interface UIImage (Additions)

/*!
 @function       - (UIImage *)imageWithTintColor:(UIColor *)color
 @abstract       根据给定的颜色重新绘制图像
 @param          color 给定的颜色
 @return         放回重新绘制的图像.
 */
- (UIImage *)imageWithTintColor:(UIColor *)color;

/*!
 @function      + (UIImage *)imageWithSize:(CGSize)size tintColor:(UIColor *)color
 @abstract      根据给定的大小和颜色创建绘制图像
 @param         size 给定的尺寸大小
 @param         color 给定的颜色
 @return        返回绘制的图像.
 */

+ (UIImage *)imageWithSize:(CGSize)size tintColor:(UIColor *)color;

/*!
 @function      + (UIImage *)imageWithSize:(CGSize)size tintColor:(UIColor *)color
 @abstract      根据给定的大小和颜色创建绘制图像
 @param         size 给定的尺寸大小
 @param         cornerRadius 给定的圆角半径
 @param         color 给定的颜色
 @return        返回绘制的图像.
 */

+ (UIImage *)imageWithSize:(CGSize)size cornerRadius:(CGFloat) cornerRadius tintColor:(UIColor *)color;


/*!
 @function      - (UIImage *)imageWithRotatedByRadians:(CGFloat)radians
 @abstract      根据弧度重新绘制图像
 @param         radians  给定的弧度
 @return        返回绘制的图像.
 */

- (UIImage *)imageWithRotatedByRadians:(CGFloat)radians;

/*!
 @function       - (UIImage *)imageWithRotatedByDegrees:(CGFloat)degress
 @abstract       根据角度重新绘制图像
 @param          radians 给定的角度
 @return         返回绘制的图像.
 */
- (UIImage *)imageWithRotatedByDegrees:(CGFloat)degress;

- (UIImage*)resizeImageToSize:(CGSize)newSize resizeMode:(ResizeMode)resizeMode;

/*!
 @function       + (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width
 @abstract       调整图片尺寸
 @param          image 原图，width 调整后的图片宽度
 @return         返回调整后的图像.
 */
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width;

@end
