//
//  ZHImageLoaderOperation.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHImageOperation.h"
#import "ZHImageDownloader.h"

@interface ZHImageLoaderOperation : NSOperation <ZHImageOperation>

@property (strong, nonatomic, readonly) NSURLRequest *request;
@property (strong, nonatomic) NSString *identifier;

- (id)initWithRequest:(NSURLRequest *)request
                queue:(dispatch_queue_t)queue
      completionBlock:(ZHImageDownloaderCompletedBlock)completionBlock
            cancelled:(void (^)())cancelBlock;

@end
