//
//  ZHImageManager.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/10.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHImageManager.h"
#import "ZHImageCache.h"
#import "ZHImageOperation.h"
#import "ZHImageDownloader.h"

@interface ZHImageManager () {
    
}

@end

static ZHImageManager *sharedManager = nil;
@implementation ZHImageManager

+ (instancetype) sharedManager {
    if (!sharedManager) {
        sharedManager = [[self alloc] init];
    }
    
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        _runningOperations = @[].mutableCopy;
    }
    
    return self;
}

- (UIImage *)getImageWithUrl:(NSString *)url {
    UIImage *image = [[ZHImageCache sharedCache] imageFromKey:url];

    return image;
}

- (id<ZHImageOperation>)loadImage:(NSString *)url classIdentifier:(NSString *)identifier tag:(NSInteger)tag completionBlock:(ZHImageDownloaderCompletedBlock)completedBlock {
    if (url.length == 0) {
        return nil;
    }
    UIImage *image = [self getImageWithUrl:url];
    if (image) {
        if (completedBlock) {
            completedBlock(image, nil, nil, YES);
        }
        return nil;
    }
    
    WS(ws);
    __block id<ZHImageOperation> operation = [[ZHImageDownloader sharedLoader] loadImage:url classIdentifier:identifier completionBlock:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        [[ZHImageCache sharedCache] storeImage:image data:data key:url];
        
        if (completedBlock) {
            completedBlock(image, nil, nil, YES);
        } else if ([self.delegate respondsToSelector:@selector(imageLoadDone:tag:)]) {
            [self.delegate imageLoadDone:image tag:tag];
        }
        
        if (finished) {
            
            @synchronized(ws.runningOperations) {
                [ws.runningOperations removeObject:operation];
            }
        }
    }];
    
    @synchronized(self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    
    return operation;
}

- (void)cancelOperationWithIdentifier:(NSString *)identifier {
    if (identifier.length == 0) {
        [self cancelAll];
        return;
    }
    
    NSMutableArray *tmpArray = @[].mutableCopy;
    for (ZHImageLoaderOperation *operation in self.runningOperations) {
        if ([operation.identifier isEqualToString:identifier]) {
            [operation cancel];
            [tmpArray addObject:operation];
        }
    }
    
    [self.runningOperations removeObjectsInArray:tmpArray];
}

- (void)cancelAll {
    [self.runningOperations makeObjectsPerformSelector:@selector(cancel)];
    [self.runningOperations removeAllObjects];
    [[ZHImageDownloader sharedLoader] cancel];
}


@end
