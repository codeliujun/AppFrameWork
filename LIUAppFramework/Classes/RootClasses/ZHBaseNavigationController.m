//
//  ZHBaseNavigationController.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHBaseNavigationController.h"

#define kTitleFont      18.0f
#define kTitleColor     kColorHexString(@"#FFFFFF")

@interface ZHBaseNavigationController ()

@end

@implementation ZHBaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self.navigationBar setBackgroundImageWithColor:kNavigationBarColor];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:[UIFont systemFontOfSize:kTitleFont]   forKey:NSFontAttributeName];
//        [dic setValue:kTitleColor               forKey:NSForegroundColorAttributeName];
//        self.navigationBar.titleTextAttributes = dic;
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    ZHBaseNavigationController* nvc = [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.delegate = self;
    //self.navigationItem.title = @"";
    nvc.delegate = self;
    
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = Nil;
    else
        self.currentShowVC = viewController;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UINavigationBar (BackgroundImage)

-(void)setBackgroundImageWithColor:(UIColor *)color {
    self.translucent = NO;
    float systemVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
    CGSize size ;
    if (systemVersion < 7.0) {
        size = CGSizeMake(320, 44);
    } else {
        size = CGSizeMake(320, 64);
    }
    UIImage *image  = [UINavigationBar imageWithSize:size  tintColor:color];
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

+ (UIImage *)imageWithSize:(CGSize)size tintColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    //填充区域
    CGContextFillRect(context, rect);
    //绘制区域
    //    CGContextStrokeRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end