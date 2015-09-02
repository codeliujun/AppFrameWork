//
//  ZHBaseViewController.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHBaseViewController.h"
#import "ZHIndicatorView.h"
#import "ZHToastView.h"

#import "ZHBaseNavigationController.h"

#define kBackButtonWidth        60
#define kNavBarHeight           44
#define kNavTitleFontSize       18

//@class ZHLoginController;
//@class ZHBaseNavigationController;

@interface ZHBaseViewController () {
    ZHIndicatorView * _indicatorView;    //加载试图
    ZHToastView     * _toastView;      //吐司视图
    
    ZHRequestNetworkInterface *interface; // 网络请求
}

@end

@implementation ZHBaseViewController

- (void)dealloc {
//    [[ZHImageManager sharedManager] cancelOperationWithIdentifier:classIdentifier];
//    [_requestManater cancel];
}

//- (void)initClassIdentifier {
//    classIdentifier = NSStringFromClass([self class]);
//    
//    for (ZHImageLoaderOperation *operation in [ZHImageManager sharedManager].runningOperations) {
//        if ([operation.identifier isEqualToString:classIdentifier]) {
//            classIdentifier = [@"prefix_" stringByAppendingString:operation.identifier];
//        }
//    }
//}

- (id)init {
    if (self = [super init]) {        
        _indicatorView = [[ZHIndicatorView alloc] init];
        _toastView = [[ZHToastView alloc] init];
        _careKeyboard = NO; //是否注册通知
        _isShowIndicator = YES; //是否显示Indicator
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackGroundColor;
    
    [ZHUtility viewAutoLay:self.view];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initBackBtn];
    //_rightBtn.hidden = YES;
    [self initTitleView];
    [self initRightBtn];
    
    //self.title = @"";
    if (_careKeyboard) {
        [self registerKeyboardNotification];
    }
    
    // view要显示的时候，设置图片下载的delegate
    [ZHImageManager sharedManager].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _rightBtn.hidden = YES;
    
    if (_careKeyboard) {
        [self unregisterKeyboardNotification];
    }
    
    // view要显示的时候，设置图片下载的delegate
    [ZHImageManager sharedManager].delegate = nil;
}

- (void)show{
    [_indicatorView show];
}

- (void)dismiss {
    [_indicatorView dismiss];
}

- (void)showToast:(NSString *)toast{
    _toastView.toast = toast;
    [_toastView showInView:self.view];
}


#pragma mark - UI
- (void)initUI {
    
}

- (void)initBackBtn {
    self.navigationItem.hidesBackButton = YES;
    
    _leftBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:leftBtnTag];
    if (nil == _leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.tag = leftBtnTag;
        _leftBtn.frame = CGRectMake(0, 0, kBackButtonWidth, kNavBarHeight);
        [_leftBtn setImage:[UIImage imageNamed:@"back_n"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateHighlighted];
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        _leftBtn.backgroundColor = [UIColor redColor];
//        [_leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationController.navigationBar addSubview:_leftBtn];
//        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
//        self.navigationItem.leftBarButtonItem = left;
    }
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    self.navigationItem.leftBarButtonItem = left;
//    self.navigationItem.backBarButtonItem = left;
    
    __weak UIViewController *weakSelf = self;
    [_leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf performSelector:@selector(backAction:) withObject:_leftBtn];
    }];
    
    if (self.navigationController.viewControllers.count > 1) {
        _leftBtn.hidden = NO;
    } else {
        _leftBtn.hidden = YES;
    }
}

- (void)initRightBtn {
    
    _rightBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:rightBtnTag];
    if (nil == _rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_rightBtn.backgroundColor = [UIColor redColor];
        _rightBtn.tag = rightBtnTag;
        _rightBtn.frame = CGRectMake(kScreenWidth-kBackButtonWidth, 0, kBackButtonWidth, kNavBarHeight);
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kNavTitleFontSize];
    }
    
    __weak UIViewController *weakSelf = self;
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf performSelector:@selector(rightAction:) withObject:_rightBtn];
    }];
    _rightBtn.hidden = YES;
}

- (void)initTitleView {
    //self.navigationItem.prompt = @"hahahahahah";
    if (!_titleLabel) {
        UIView *view = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
        //view.backgroundColor = [UIColor blueColor];
        self.navigationItem.titleView = view;
        _viewTitle = view;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:kNavTitleFontSize];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //_titleLabel.backgroundColor = [UIColor redColor];
        [view addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_viewTitle.mas_top).with.offset(0);
            make.left.equalTo(_viewTitle.mas_left).with.offset(0);
            make.right.equalTo(_viewTitle.mas_right).with.offset(-70);
            make.height.equalTo(@(44));
        }];
    } else {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_viewTitle.mas_top).with.offset(0);
            make.left.equalTo(_viewTitle.mas_left).with.offset(0);
            make.right.equalTo(_viewTitle.mas_right).with.offset(-70);
            make.height.equalTo(@(44));
        }];
    }
    
    _titleLabel.text = navTitle;
    //self.title = @"";
    self.navigationItem.title = @"";
}

- (void)hiddenRightNavBtn {
    _rightBtn.hidden = YES;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (![title isEqualToString:@""]) {
        navTitle = title;
    }
}

- (void)setRightNavBtnTitle:(NSString *)title {
    [self setRightNavBtnTitle:title AndImage:nil];
}

- (void)setRightNavBtnImage:(UIImage *)image {
    [self setRightNavBtnTitle:nil AndImage:image];
}

- (void)setRightNavBtnTitle:(NSString *)title AndImage:(UIImage *)image {
    
    _rightBtn.hidden = NO;
    [_rightBtn removeFromSuperview];
    [self.navigationController.navigationBar addSubview:_rightBtn];
    
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn setImage:image forState:UIControlStateNormal];
}

- (void)rightAction:(UIButton *)button {
    
}

- (void)initLogo {
    if (nil == _imgLogo) {
        _imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
        _imgLogo.image = [UIImage imageNamed:@"ico_logo"];
        [self.navigationController.navigationBar addSubview:_imgLogo];
    }
    
    _imgLogo.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark- Action

- (void)backAction:(id)sender{
    [self dismiss];
    
    [self back];
}

- (void)back {

    NSLog(@"self.isBackToRoot: %d\nself.navigationController.viewControllers.count:%lu", self.isBackToRoot,(unsigned long)self.navigationController.viewControllers.count);
    _rightBtn.hidden = YES;
    if (self.navigationController.viewControllers.count > 0 ) {
        if (!self.isBackToRoot) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }

}

#pragma mark - network
- (void)loadData {
    
}

- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters {
//    if (self.isShowIndicator) {
//        [self show];
//    }
//    [[ZHRequestManager requestManager] requestMethod:method parameter:parameters successHandler:^(NSDictionary *result) {
//        [self dismiss];
//        [self requestSuccess:result];
//    } errorHandler:^(NSDictionary *errorDic) {
//        [self dismiss];
//        [self requestError:errorDic];
//    }];
    WS(ws);
    interface = [ZHRequestNetworkInterface interfaceWithFinshBlock:^(id responseObje) {
        if ([[responseObje objectForKey:@"ret"] intValue] == 0) {
            [ws requestSuccess:responseObje];
        } else {
            [ws requestError:responseObje];
        }
    } faildBlock:^(NSError *err) {
        [ws showToast:@"网络不给力，请求失败!"];
    } interFaceHUD:ZHLoadHUDStyleDefault HUDBackgroundView:self.view];
   
    [interface setAnalyZingType:ZHNetworkAnalyZingTypeJSON];
    [interface setLoadProgressBlock:^(unsigned long long size, unsigned long long total){
        NSLog(@"zhge shi ganma de ");
    }];

    NSMutableArray *array = [NSMutableArray array];
    // 添加token参数
    ZHUserObj *userObj = [ZHConfigObj configObject].userObject;
    if (userObj.token) {
        [array addParameter:@"token" parameterValue:userObj.token parameterType:ZHNetworkParameterTypeDefault];
    }
    
    NSArray *allkeys = [parameters allKeys];
    NSString *key = nil, *value = nil;
    for(int i = 0; i < [allkeys count]; i++) {
        key = [allkeys objectAtIndex:i];
        value = [parameters objectForKey:key];
//        if ([key containsString:@"imgStr"]) {
//            [array addParameter:key parameterValue:value parameterType:ZHNetworkParameterTypeDefault];
//        } else {
            [array addParameter:key parameterValue:value parameterType:ZHNetworkParameterTypeDefault];
//        }
    }
    [interface starLoadInformationWithParameters:array URLString:kGetRequestUrl(method) connectType:ZHNetworkTypePost];
}

- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters Success:(SuccessBlock)success Error:(ErrorBlock)error {
    if (success) {
        _successBlock = success;
    }
    if (error) {
        _errorBlock = error;
    }
    [self requestMethod:method parameter:parameters];
}

- (void)requestSuccess:(NSDictionary *)result {
    DBLog(@"request result: %@", result);
    if (_successBlock) {
        _successBlock(result);
        //_successBlock = nil;
    }
}

- (void)requestError:(NSDictionary *)error {
    DBLog(@"request error: %@", error);
    [self showToast:[error objectForKey:@"error"]];
    if (_errorBlock) {
        _errorBlock(error);
        //_errorBlock = nil;
    }
}

#pragma --mark 注册键盘通知
/* 注册keyboard通知 */
- (void)registerKeyboardNotification {
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [dnc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [dnc addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [dnc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

/* 移除keyboard通知 */
- (void)unregisterKeyboardNotification {
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [dnc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [dnc removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [dnc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - dealwith keyboard functions
- (void)keyboardDidShow:(NSNotification *)notification
{
    /* 获取键盘高度 */
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
}

/* 键盘完全弹起，列表的动画结束 */
- (void)showKeyboardEnd
{
    _isShowKeyboarded = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /* 获取键盘高度 */
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    _isShowKeyboarded = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    /* 获取键盘高度 */
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZHImageManager delegate
- (void)imageLoadDone:(UIImage *)image tag:(NSInteger)tag {
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:tag];
    if (imageView && [imageView respondsToSelector:@selector(setImage:)]) {
        imageView.image = image;
    }
}

#pragma --mark 判断游客是否登录
- (BOOL)userIsLogin {
    ZHUserObj *userObj = [ZHConfigObj configObject].userObject;
    
    if (userObj.token.length == 0) {
        return NO;
    }else {
        return YES;
    }
}

@end
