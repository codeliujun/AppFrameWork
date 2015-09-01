//
//  ZHOrderObj.m
//  ZHTourist
//
//  Created by liujun on 15/8/13.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHOrderObj.h"

@implementation ZHOrderObj

- (ZHGuideInfo *)guideInfo {
    if (!_guideInfo) {
        _guideInfo = [ZHGuideInfo new];
    }
    return _guideInfo;
}

@end

