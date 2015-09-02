//
//  LIUHomeViewRecommendTableViewCell.m
//  YouYouShoppingCenter
//
//  Created by 刘俊 on 15/7/2.
//  Copyright (c) 2015年 刘俊. All rights reserved.
//

#import "LIUHomeViewRecommendTableViewCell.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "LIURecommendView.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf=self

@interface LIUHomeViewRecommendTableViewCell()

@property(nonatomic,strong)LIURecommendView *recommendView;

@end

@implementation LIUHomeViewRecommendTableViewCell

+ (LIUHomeViewRecommendTableViewCell *)cell {
    LIUHomeViewRecommendTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
    return cell;
}

//初始化推荐界面，以后可以在需要的的时候传值,安装创建之后直接添加到了推荐的界面

- (LIURecommendView *)recommendView {
    if (!_recommendView) {
        WS(ws);
        _recommendView = [LIURecommendView creatViewAndDidTapButton:^(NSDictionary *info) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"当前点击的信息:%@ 还没开放",info[@"buttonTitle"]]];
        }];
        [self addSubview:_recommendView];
        //masonry约束 先要add进去
        [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws).insets(UIEdgeInsetsMake(40, 0, 0, 0));
        }];
    }
    return _recommendView;
}


- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)moreInfo:(UIButton *)sender {
    
    self.buttonTap;
}

- (void)setRecommends:(NSArray *)recommends {
    _recommends = [recommends copy];
    self.recommendView.shoppingList = recommends;
    [self setNeedsDisplay];
}

@end
