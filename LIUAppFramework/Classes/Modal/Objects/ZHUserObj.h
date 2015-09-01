//
//  ZHUserObj.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//
#import <Mantle/Mantle.h>

@interface ZHUserObj : MTLModel <MTLJSONSerializing>

//{"ret":0,"token":"39734eaeecb42996e0a785cb188828aa","msg":"登陆成功","data":{"id":"15","phone":"15618388363","pwd":"6f38c8e2c9be93d4a01b39f89f45e9ae","reg_time":"2015-07-14 21:40:00","user_type":"1","device_type":"1","update_time":"0000-00-00 00:00:00"}}
@property (nonatomic, copy) NSString *id;                   //
@property (nonatomic, copy) NSString *pwd;                  // 登陆用到的验证码
@property (nonatomic, copy) NSString *phone;                // 手机号
@property (nonatomic, copy) NSString *token;                // token

@property (nonatomic, copy) NSString *password;                 // 密码
@property (nonatomic, copy) NSString *username;                 // 用户名


@property (nonatomic, copy) NSString *real_name;            //用户名
@property (nonatomic, copy) NSString *sex;

@end
