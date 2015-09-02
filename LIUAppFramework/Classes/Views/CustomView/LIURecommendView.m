//
//  LIURecommendView.m
//  YouYouShoppingCenter
//
//  Created by 刘俊 on 15/6/17.
//  Copyright (c) 2015年 刘俊. All rights reserved.
//

//全局变量，这个是为了存储传进来的frame的值
#import "LIURecommendView.h"
#import "UIImage+GetUrlImage.h"
#import "ZHOrderObj.h"

@interface LIURecommendView ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *shoppingButton;


@end

@implementation LIURecommendView

+ (LIURecommendView *)creatViewWithFrame:(CGRect)frame {
    
    LIURecommendView *view = [[[NSBundle mainBundle] loadNibNamed:@"LIURecommendView" owner:nil options:nil] lastObject];
    view.frame = frame;
    return view;
}

+ (LIURecommendView *)creatView {
    return [[[NSBundle mainBundle] loadNibNamed:@"LIURecommendView" owner:nil options:nil] lastObject];
}

+ (LIURecommendView *)creatViewAndDidTapButton:(void (^) (NSDictionary *info))didTapButton {
    LIURecommendView *recommendView = [LIURecommendView creatView];
    recommendView.tapButtonInfo = didTapButton;
    return recommendView;
}

- (void)setShoppingList:(NSArray *)shoppingList {
    WS(ws);
    __block NSMutableArray *marr = @[].mutableCopy;
    for (id imageAdd in shoppingList) {
        if ([imageAdd isKindOfClass:[NSString class]]) {
            [UIImage getImageWithThumble:imageAdd Success:^(UIImage *image) {
                [marr addObject:image];
                [ws isUpdatebutton:marr origin:shoppingList];
            }];
        }else {
            ZHOrderObj *obj = (ZHOrderObj *)imageAdd;
            [UIImage getImageWithThumble:obj.ThumbUrl Success:^(UIImage *image) {
                [marr addObject:image];
                [ws isUpdatebutton:marr origin:shoppingList];
            }];
        }
    }
}

- (void)isUpdatebutton:(NSArray *)marr origin:(NSArray *)shoppingList {
    
    if (marr.count == shoppingList.count) {
        _shoppingList = marr.copy;
        [self updateButton];
    }else {
        
    }
}

#pragma --mark 更新button
- (void)updateButton {
    for (int i = 0; i < MIN(_shoppingList.count, 4); i++) {//这里是小雨shoppinglist，防止传入进来的数据小于4
        UIButton *button = self.shoppingButton[i];
        [button setBackgroundImage:_shoppingList[i] forState:UIControlStateNormal];
    }
}

#pragma -mark button的点击事件
- (IBAction)tapButton:(UIButton *)sender {
    //找到点击按钮的index
    NSInteger index = [self.shoppingButton indexOfObject:sender];
    self.tapButtonInfo(@{@"buttonTitle":self.shoppingList[index]});
    NSLog(@"%@",self.shoppingList[index]);
    
}


@end
