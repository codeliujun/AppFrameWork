//
//  ZHGuideInfo.h
//  ZHTourist
//
//  Created by liujun on 15/8/20.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Mantle.h>

@interface ZHGuideInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *guide_idcard;

@property (nonatomic, copy) NSString *guide_experience;

@property (nonatomic, copy) NSString *guide_id;

@property (nonatomic, copy) NSString *w_level_id;

@property (nonatomic, copy) NSString *guide_name;

@property (nonatomic, copy) NSString *w_user_id;

@property (nonatomic, copy) NSString *guide_price;

@property (nonatomic, copy) NSString *manifesto;

@property (nonatomic, copy) NSString *is_del;

@property (nonatomic, copy) NSString *serve_state;

@property (nonatomic, copy) NSString *guide_mobile;

@property (nonatomic, copy) NSString *w_tour_sup_id;

@property (nonatomic, copy) NSString *guide_code;

@property (nonatomic, copy) NSString *online_state;

@property (nonatomic, copy) NSString *adeptinfo;

@property (nonatomic, copy) NSString *guide_sex;

@property (nonatomic, copy) NSString *guide_age;

@property (nonatomic, copy) NSString *weight_type;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *order_count;

@end
