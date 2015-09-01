//
//  ZHOrderObj.h
//  ZHTourist
//
//  Created by liujun on 15/8/13.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Mantle.h>
#import "ZHGuideInfo.h"

@interface ZHOrderObj : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *sight_desc;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *lang;

@property (nonatomic, copy) NSString *apply_number;

@property (nonatomic, copy) NSString *end_date;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *apply_time;

@property (nonatomic, copy) NSString *people_num;

@property (nonatomic, copy) NSString *w_order_id;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *depart_city;

@property (nonatomic, copy) NSString *dest_city;

@property (nonatomic, copy) NSString *play_city;

@property (nonatomic, copy) NSString *sight_name;

@property (nonatomic, strong) ZHGuideInfo *guideInfo;

@property (nonatomic, copy) NSString *level_name;

@property (nonatomic, copy) NSString *budget;

@property (nonatomic, copy) NSString *is_close;

@property (nonatomic, copy) NSString *start_date;

@property (nonatomic, copy) NSString *update_time;

@property (nonatomic, copy) NSString *guide_level;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *tipmoney;



//下面这些是自己添加的
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *timeStr;

@end
