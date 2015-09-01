//
//  UIImageView+imageCache.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/12.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "UIImageView+imageCache.h"
#import "ZHImageManager.h"
#import "objc/runtime.h"

static NSString *operationKey;
@implementation UIImageView (imageCache)

- (void)setImageWithURL:(NSString *)url classIdentifier:(NSString *)identifier
{
    [self cancelCurrentDownload];
    
    if (url)
    {
        __weak UIImageView *wself = self;
        id<ZHImageOperation> operation = [[ZHImageManager sharedManager] loadImage:url classIdentifier:identifier tag:self.tag completionBlock:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            __strong UIImageView *sself = wself;
            if (!sself) return;
            if (image)
            {
                sself.image = image;
                [sself setNeedsLayout];
            }
        }];
        
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentDownload {
    id<ZHImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
