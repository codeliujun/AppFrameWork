//
//  ZHImageManager.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/10.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHImageLoaderOperation.h"

@protocol ZHImageManagerDelegate <NSObject>

- (void)imageLoadDone:(UIImage *)image tag:(NSInteger)tag;

@end

@interface ZHImageManager : NSObject

@property (nonatomic, weak) id<ZHImageManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *runningOperations;

+ (instancetype) sharedManager;

- (id<ZHImageOperation>)loadImage:(NSString *)url classIdentifier:(NSString *)identifier tag:(NSInteger)tag completionBlock:(ZHImageDownloaderCompletedBlock)completedBlock;
- (void)cancelOperationWithIdentifier:(NSString *)identifier;

@end
