//
//  NSObject+KVC.m
//  BookingCar
//
//  Created by Michael Shan on 14-11-25.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "NSObject+KVC.h"
#import <objc/runtime.h>

@implementation NSObject (KVC)

- (id)valueForUndefinedKey:(NSString *)key {
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([value isKindOfClass:[NSString class]]) {
        objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_COPY_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setNilValueForKey:(NSString *)key {
    
}

@end
