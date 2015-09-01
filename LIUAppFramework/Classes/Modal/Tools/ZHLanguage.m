//
//  ZHLanguage.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHLanguage.h"

@implementation ZHLanguage

+ (NSString *) localizedStringFromTable:(NSString *)key{
    NSString *tbl = @"";
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage rangeOfString:@"ZH" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        tbl = @"ZH";
    } else {
        tbl = @"EN";
    }
    
    return NSLocalizedStringFromTable(key,tbl,@"");
}

@end
