//
//  UIImage+GetUrlImage.m
//  LIUAppFramework
//
//  Created by liujun on 15/9/2.
//  Copyright (c) 2015年 liujun. All rights reserved.
//

#import "UIImage+GetUrlImage.h"
#import "ZHCache.h"

@implementation UIImage (GetUrlImage)

+ (void)getImageWithThumble:(NSString *)thumble Success:(void (^) (UIImage *image))success {
    
    //1.首先看看室不是本地图片
   __block UIImage *image = [UIImage imageNamed:thumble];
    
    if (!image) {
        NSString *imageStr = [thumble stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        //2.那么就是网络上的图片
        image = [[ZHCache sharedCache]imageForKey:[UIImage getImageNameWithThumble:imageStr]];
        if (!image) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        image = [UIImage imageWithData:data];
                        [[ZHCache sharedCache] setImage:image forKey:[UIImage getImageNameWithThumble:imageStr]];
                    }else {
                        image = [UIImage imageNamed:@"测试图片"];
                    }                    
                    if (image) {
                        if (success) {
                            success(image);
                            return;
                        }
                    }

                });
            });
        }
    }
    
    if (image) {
        if (success) {
            success(image);
            return;
        }
    }
    
}

+ (NSString *)getImageNameWithThumble:(NSString *)thumble {
    
    //1.去掉座斜杠
    NSString *str1 = [thumble stringByReplacingOccurrencesOfString:@"/" withString:@""];
    //2.去掉冒号
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"&" withString:@""];
    NSString *str5 = [str4 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *str6 = [str5 stringByReplacingOccurrencesOfString:@"=" withString:@""];

    return str6;
}

@end
