//
//  ZHImageDownloader.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHImageDownloader.h"
#import "ZHImageLoaderOperation.h"
#import "ZHImageManager.h"

#define kImageTimeout       600

@interface ZHImageDownloader ()

@property (nonatomic, strong) dispatch_queue_t workingQueue;

@end

static ZHImageDownloader *sharedInstance = nil;
@implementation ZHImageDownloader

+ (instancetype)sharedLoader {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _workingQueue = dispatch_queue_create("com.hackemist.SDWebImageDownloader", DISPATCH_QUEUE_SERIAL);
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount = 5;
    }
    
    return self;
}

- (id<ZHImageOperation>)loadImage:(NSString *)url classIdentifier:(NSString *)identifier  completionBlock:(ZHImageDownloaderCompletedBlock)completionBlock {
    __block ZHImageLoaderOperation *operation = [[ZHImageLoaderOperation alloc] init];
    __weak ZHImageDownloader *wself = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest.alloc initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:kImageTimeout];
    operation = [ZHImageLoaderOperation.new initWithRequest:request queue:wself.workingQueue completionBlock:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        completionBlock(image, data, error, finished);
    } cancelled:^{
        
    }];
    operation.identifier = identifier;
    
    [self.downloadQueue addOperation:operation];
    
    return operation;
}

- (void)cancel {
    [self.downloadQueue cancelAllOperations];
}

@end
