//
//  UIImageView+imageCache.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (imageCache)

- (void)setImageWithURL:(NSString *)url classIdentifier:(NSString *)identifier;

- (void)cancelCurrentDownload;

@end
