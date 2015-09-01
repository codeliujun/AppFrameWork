//
//  ZHCouponObj.h
//  ZHTourist
//
//  Created by liujun on 15/8/17.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

/*
 {
 "coupon_start_time" : "2015-11-11 00:00:00",
 "send_time" : "2015-08-13 18:31:44",
 "coupon_name" : "士大夫士大夫",
 "voucher_status" : "1",
 "coupon_end_time" : "2016-11-11 00:00:00",
 "status" : "0",
 "coupon_money" : "444.00",
 "voucher_number" : "14394588402232"
 }
 */

#import <Mantle.h>

@interface ZHCouponObj : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *coupon_start_time;

@property (nonatomic, copy) NSString *send_time;

@property (nonatomic, copy) NSString *coupon_name;

@property (nonatomic, copy) NSString *voucher_status;

@property (nonatomic, copy) NSString *coupon_end_time;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *coupon_money;

@property (nonatomic, copy) NSString *voucher_number;

@end
