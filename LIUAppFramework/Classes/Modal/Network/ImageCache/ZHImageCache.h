//
//  ZHImageCache.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHImageCache : NSObject

+ (instancetype)sharedCache;

- (void)storeImage:(UIImage *)image data:(NSData *)imageData key:(NSString *)key;
- (UIImage *)imageFromKey:(NSString *)key;

@end
