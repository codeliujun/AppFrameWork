
//
//  LIURecommendView.h
//  YouYouShoppingCenter
//
//  Created by 刘俊 on 15/6/17.
//  Copyright (c) 2015年 刘俊. All rights reserved.
//
/**
 *这个界面是用来搭建商品推荐这一个模块的
 */

#import <UIKit/UIKit.h>

@interface LIURecommendView : UIView

//初始化一个view
+ (LIURecommendView *)creatViewWithFrame:(CGRect)frame;
+ (LIURecommendView *)creatView;//autolayout可以用这个
//- (instancetype)initWithFrame:(CGRect)frame;
+ (LIURecommendView *)creatViewAndDidTapButton:(void (^) (NSDictionary *info))didTapButton;

//传进来一个数组，是包含商品的一个数组，然后就在button上面显示
@property(nonatomic,strong)NSArray *shoppingList;//只能显示4张
@property(nonatomic,strong)void (^ tapButtonInfo) (NSDictionary *info);

@end
