//
//  ZHBaseViewController.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNetworkTools.h"
#import "ZHRequestNetworkInterface.h"
#import "ZHImageManager.h"

#define leftBtnTag      0x1001
#define rightBtnTag     0x1002

//typedef enum {
//    BackStateOriginal = 0,
//    BackStateChange   = 1,
//}BackState;
//typedef void (^BackStateBlock) (BackState );

typedef void (^SuccessBlock) (NSDictionary *result);
typedef void (^ErrorBlock) (NSDictionary *error);

@interface ZHBaseViewController : UIViewController <ZHImageManagerDelegate>{
    NSString    *classIdentifier;  // 下载中用到的identifier
    
    SuccessBlock    _successBlock;
    ErrorBlock      _errorBlock;
    BOOL    _careKeyboard;//是否注册通知
    BOOL    _isShowKeyboarded;//键盘是否显示
    
    NSString *navTitle;     // 解决返回的时候，navigation title上会出现 ...
    
//    ZHRequestManager *_requestManater;
}

@property(nonatomic, assign) BOOL isShowIndicator;//网络请求是否显示图标，默认显示
@property(nonatomic, assign) BOOL isBackToRoot; //是否返回到根试图
@property(strong, nonatomic) UIButton *leftBtn;
@property(strong, nonatomic) UIButton *rightBtn;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UIView *viewTitle;
@property(strong, nonatomic) UIImageView *imgLogo;

- (void)initUI;
//返回
- (void)back;

// navigation 右上角按钮
- (void)hiddenRightNavBtn;
- (void)rightAction:(UIButton *)button;
- (void)setRightNavBtnTitle:(NSString *)title;
- (void)setRightNavBtnImage:(UIImage *)image;

//indicator
- (void)show;
- (void)dismiss;
- (void)showToast:(NSString *)toast;

//network
- (void)loadData;
- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters;
/**
 *  @author 刘俊, 15-08-05
 *  新增网络请求
 */
- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters Success:(SuccessBlock)success Error:(ErrorBlock)error;
- (void)requestSuccess:(NSDictionary *)result;
- (void)requestError:(NSDictionary *)error;

//keyboard
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;

//判断游客是否登录
- (BOOL)userIsLogin;
- (void)showLoginViewLoginSuccess:(void (^) ())success Failue:(void (^) ())failue;

////推出下一个界面，然后返回一个状态码
//- (void)pushViewController:(UIViewController *)controller Animated:(BOOL)animated Back

@end
