//
//  NSDate+Additions.h
//  BookingCar
//
//  Created by Michael Shan on 14-9-26.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

- (NSString *)timeStringFromDate;
- (NSString *)dateStringFromDate;

+ (NSDate *)dateFromString:(NSString *)dateStr;
+ (NSString *)getImageTimestamp;
+ (NSString *)getStringWithDate:(NSDate *)date withFormatter:(NSString *)formatterStr;
+ (NSDate *)getDateWithString:(NSString *)dateStr withFormatter:(NSString *)formatterStr;
+ (NSString *)getTimeStr:(NSTimeInterval)interval;

@end
