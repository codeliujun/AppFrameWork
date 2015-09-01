//
//  ZHImageLoaderOperation.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/11.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHImageLoaderOperation.h"

@interface ZHImageLoaderOperation () {
    
}

@property (copy, nonatomic) void (^cancelBlock)();
@property (copy, nonatomic) ZHImageDownloaderCompletedBlock completedBlock;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) dispatch_queue_t queue;

@end

@implementation ZHImageLoaderOperation
@synthesize executing = _executing, finished = _finished;

- (id)initWithRequest:(NSURLRequest *)request
                queue:(dispatch_queue_t)queue
      completionBlock:(ZHImageDownloaderCompletedBlock)completionBlock
            cancelled:(void (^)())cancelBlock {
    if (self = [super init]) {
        _queue = queue;
        _request = request;
        _cancelBlock = [cancelBlock copy];
        _completedBlock = [completionBlock copy];
    }
    
    return self;
}

- (void)start {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isCancelled)
        {
            self.finished = YES;
            [self reset];
            return;
        }
        
        self.executing = YES;
        self.connection = [NSURLConnection.alloc initWithRequest:self.request delegate:self startImmediately:NO];
        
        [self.connection start];
    });
}

- (void)cancel
{
    if (self.isFinished) return;
    [super cancel];
    if (self.cancelBlock) self.cancelBlock();
    
    if (self.connection)
    {
        [self.connection cancel];
        
        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    
    [self reset];
}

- (void)done
{
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        self.cancelBlock = nil;
        self.connection = nil;
    });
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent
{
    return YES;
}

#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400)
    {
        NSUInteger expected = response.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;
        
        dispatch_async(self.queue, ^{
            self.imageData = [NSMutableData.alloc initWithCapacity:expected];
        });
    } else {
        [self.connection cancel];
        
        [self done];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    dispatch_async(self.queue, ^ {
        [self.imageData appendData:data];
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    self.connection = nil;
    if (self.completedBlock) {
        UIImage *image = [UIImage imageWithData:self.imageData];
        self.completedBlock(image, self.imageData, nil, YES);
    }
    
    [self done];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self done];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    // Prevents caching of responses
    return nil;
}

@end
