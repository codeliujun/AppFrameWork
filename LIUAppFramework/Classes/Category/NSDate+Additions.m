//
//  NSDate+Additions.m
//  BookingCar
//
//  Created by Michael Shan on 14-9-26.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString *)timeStringFromDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    return [formatter stringFromDate:self];
}

- (NSString *)dateStringFromDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    return [formatter stringFromDate:self];
}


+ (NSDate *)dateFromString:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter dateFromString:dateStr];
}

+ (NSString *)getImageTimestamp {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)getStringWithDate:(NSDate *)date withFormatter:(NSString *)formatterStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    return [formatter stringFromDate:date];
}

+ (NSDate *)getDateWithString:(NSString *)dateStr withFormatter:(NSString *)formatterStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    [formatter setDateFormat:formatterStr];
    
    return [formatter dateFromString:dateStr];
}

+ (NSString *)getTimeStr:(NSTimeInterval)interval {
    NSString *timeStr = @"";
    
    NSInteger minute = interval / 60;
    if (minute < 60) {
        timeStr = [NSString stringWithFormat:@"%d分", minute];
    } else if (minute >= 60 && minute < 60*24) {
        timeStr = [NSString stringWithFormat:@"%d小时", minute/60];
        if (minute%60 > 0) {
            timeStr = [timeStr stringByAppendingFormat:@"%d分", minute%60];
        }
    } else if (minute >= 60*24) {
        timeStr = [NSString stringWithFormat:@"%d天", minute/(60*24)];
        if (minute%(60*24)/60 > 0) {
            timeStr = [timeStr stringByAppendingFormat:@"%d小时", minute%(60*24)/60+1];
        }
    }
    
    return timeStr;
}

@end
