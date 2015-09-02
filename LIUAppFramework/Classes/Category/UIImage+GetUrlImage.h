//
//  UIImage+GetUrlImage.h
//  LIUAppFramework
//
//  Created by liujun on 15/9/2.
//  Copyright (c) 2015年 liujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GetUrlImage)

+ (void)getImageWithThumble:(NSString *)thumble Success:(void (^) (UIImage *image))success;

@end
