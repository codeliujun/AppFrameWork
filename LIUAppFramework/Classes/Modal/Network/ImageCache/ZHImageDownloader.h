//
//  ZHImageDownloader.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHImageOperation.h"

typedef void(^ZHImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

@interface ZHImageDownloader : NSObject

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

+ (instancetype)sharedLoader;

- (id<ZHImageOperation>)loadImage:(NSString *)url classIdentifier:(NSString *)identifier completionBlock:(ZHImageDownloaderCompletedBlock)completionBlock;

- (void)cancel;

@end
