//
//  ZHNetworkEntityClass.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/27.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHNetworkEntityClass.h"

@implementation ZHNetworkEntityClass

@end

@implementation ZHNetworkParameter

-(void)setParameterName:(NSString *)parameterName {
    
    if (!parameterName && parameterName == NULL){
        _parameterName = @"";
    } else {
        _parameterName = parameterName;
    }
}

- (void)setParameterValue:(id)parameterValue {
    
    if (!parameterValue && parameterValue == NULL){
        _parameterValue = @"";
    } else {
        _parameterValue = parameterValue;
    }
}

- (NSString *)description {
    NSString *des = [NSString stringWithFormat:@"name: %@, value: %@, type: %d", _parameterName, _parameterValue, _parameterType];
    return des;
}

@end

@implementation ZHNetworkSOPAEntityClass



@end