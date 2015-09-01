//
//  NSObject+KVC.h
//  BookingCar
//
//  Created by Michael Shan on 14-11-25.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVC)

- (id)valueForUndefinedKey:(NSString *)key;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (void)setNilValueForKey:(NSString *)key;

@end
