//
//  LIUMainViewController.m
//  LIUAppFramework
//
//  Created by liujun on 15/9/1.
//  Copyright (c) 2015年 liujun. All rights reserved.
//

#import "LIUMainViewController.h"
#import "LIUHomeViewRecommendTableViewCell.h"
#import "LIUHomeCategoryCell.h"

#import "ZHOrderObj.h"

@interface LIUMainViewController (){
    LIUHomeViewRecommendTableViewCell   *_recommendCell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong)NSArray *catergays;

@property (nonatomic ,strong)NSArray *recommends;

@end

@implementation LIUMainViewController

- (NSArray *)catergays {
    if (!_catergays) {
        _catergays = @[].mutableCopy;
    }
    return _catergays;
}

- (NSArray *)recommends {
    if (!_recommends) {
        _recommends = @[@"测试图片",@"测试图片",@"测试图片",@"测试图片",@"测试图片"];
    }
    return _recommends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initCell];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

- (void)initCell {
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LIUHomeCategoryCell" bundle:nil] forCellReuseIdentifier:@"mycell2"];
    
    
    _recommendCell = [LIUHomeViewRecommendTableViewCell cell];
    _recommendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _recommendCell.recommends = self.recommends;
    _recommendCell.buttonTap = ^{
        /**
         *  @author 刘俊, 15-07-27
         *
         *  点击了更多的按钮
         */
    };
    
}

- (void)getData {
    WS(ws);
    [self requestMethod:kGetFirstCater parameter:@{@"pageindex":@1,
                                                   @"pagesize":@20,
                                                   @"thumbwidth":@20,
                                                   @"thumbheight":@20,
    }Success:^(NSDictionary *result) {
        ws.catergays = result[@"Data"];
        [ws.tableView reloadData];
        
        [ws requestMethod:kGetRecomment parameter:@{@"pagesize":@4} Success:^(NSDictionary *result) {
            ws.recommends = [ZHOrderObj objectArrayWithKeyValuesArray:result[@"Data"]];
            [ws updateRecommend];
        } Error:^(NSDictionary *error) {
            
        }];
   
    } Error:^(NSDictionary *error) {
                                                       
                                    }];
    
}

- (void)updateRecommend {
    
    _recommendCell.recommends = self.recommends;
    
}


#pragma --mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger row = 1;
    if (1 == section) {
        row = self.catergays.count;
    }
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return _recommendCell;
    }else {
        LIUHomeCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell2" forIndexPath:indexPath];
        cell.caterInfo = self.catergays[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 70.f;
    
    if (0 == indexPath.section) {
        height = 200.f;
    }
    
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
