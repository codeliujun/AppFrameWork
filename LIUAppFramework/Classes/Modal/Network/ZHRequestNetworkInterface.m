//
//  ZHRequestManager.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHRequestNetworkInterface.h"
#import "NSString+URLEncode.h"
#import "NSString+Additions.h"
#import "ZHCache.h"

@implementation ZHRequestNetworkInterface

- (NSString *)getUrl:(NSString *)method {
    NSString *url = @"";
    
    url = kGetRequestUrl(method);
    
    return url;
}

// remove null object from dictionary
- (NSDictionary *)removeNullObjectFromDictionary:(NSDictionary *)dict {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray *keys = [muDict allKeys];
    NSString *key = nil;
    for (int i = 0; i < keys.count; i++) {
        key = [keys objectAtIndex:i];
        id object = [muDict objectForKey:key];
        if ([object isKindOfClass:[NSNull class]]) {
            [muDict setObject:@"" forKey:key];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = [self removeNullObjectFromDictionary:object];
            [muDict setObject:dict forKey:key];
        } else if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = [self removeNullObjectFromArray:object];
            [muDict setObject:array forKey:key];
        }
    }
    return muDict;
}

// remove null object from array
- (NSArray *)removeNullObjectFromArray:(NSArray *)array {
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < muArray.count; i++) {
        id object = [muArray objectAtIndex:i];
        if ([object isKindOfClass:[NSNull class]]) {
            [muArray replaceObjectAtIndex:i withObject:@""];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = [self removeNullObjectFromDictionary:object];
            [muArray replaceObjectAtIndex:i withObject:dict];
        } else if ([object isKindOfClass:[NSArray class]]) {
            NSArray *arr = [self removeNullObjectFromArray:object];
            [muArray replaceObjectAtIndex:i withObject:arr];
        }
    }
    return muArray;
}

#pragma mark - methods
/**
 *  @brief 网络请求
 *  @param type 请求类型
 *  @param parameters 请求参数
 *  @param successHandler 成功获取的处理方法
 *  @param errorHandler 获取失败的处理方法
 */
- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters successHandler:(ResultBlock)successBlock errorHandler:(ResultBlock)errorBlock {
    NSMutableString *bodyStr = [NSMutableString string];
    NSString *formatUrl = nil;
    NSString *url = [self getUrl:method];
    
    ZHUserObj *userObj = [ZHConfigObj configObject].userObject;
    if (userObj.token) {
        [bodyStr appendFormat:@"%@=%@&", @"token", userObj.token];
    }
    
    if (parameters) {
        NSMutableDictionary *newParamaters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        NSArray *keys = [newParamaters allKeys];
        NSUInteger len = [keys count];
        for (int i = 0; i < len; i++){
            NSString *key = [keys objectAtIndex:i];
            
            if ([key isKindOfClass:[NSString class]]) {
                key = [key URLEncodeString];
            }
            id value = [newParamaters valueForKey:key];
            
            if ([value isKindOfClass:[NSString class]]) {
                value = [value URLEncodeString];
            }else if([value isKindOfClass:[NSDictionary class]]){
                value = [NSString stringWithJsonObject:value];
            }else if([value isKindOfClass:[NSArray class]]){
                value = [NSString  stringWithJsonObject:value];
            }
            [bodyStr appendFormat:@"%@=%@", key, value];
            if(i != len -1) {
                [bodyStr appendString:@"&"];
            }
        }
    }
    
    formatUrl = [NSString stringWithFormat:@"%@?%@", url, bodyStr];
    
    DBLog(@"formatUrl: %@", formatUrl);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:formatUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (! error) {
            NSError *jsonError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            result = [self removeNullObjectFromDictionary:result];
            
            if (!jsonError) {
                kMainQueue(^{
                    if (result && [[result objectForKey:@"ret"] intValue] == 0) {
                        if (successBlock) {
                            successBlock(result);
                        }
                    } else {
                        if (errorBlock) {
                            errorBlock(result);
                        }
                    }
                });
            }
            else {
                if (errorBlock) {
                    errorBlock(@{@"error":[jsonError description]});
                }
            }
        }
        else {
            errorBlock(@{@"error":[error description]});
        }
    }];
    
    [dataTask resume];

//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:formatUrl]];
//    [request setHTTPMethod:@"POST"];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        if (!data) {
//            return;
//        }
//        
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        result = [self removeNullObjectFromDictionary:result];
//        
//        kMainQueue(^{
//            if (result && [[result objectForKey:@"ret"] intValue] == 0) {
//                if (successBlock) {
//                    successBlock(result);
//                }
//            } else {
//                if (errorBlock) {
//                    errorBlock(result);
//                }
//            }
//        });
//    }];
}

- (void)getImageWithUrl:(NSString *)url resultHandler:(ImageLoadBlock)handler {
    UIImage *image = [[ZHCache sharedCache] imageForKey:[NSString md5:url]];
    if (image) {
        handler(image);
    } else {
        kGlobalQueue(^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
            if (tmpImage) {
                [[ZHCache sharedCache] setImage:tmpImage forKey:[NSString md5:url]];
                kMainQueue(^{
                    handler(tmpImage);
                });
            }
        });
    }
}

@end
