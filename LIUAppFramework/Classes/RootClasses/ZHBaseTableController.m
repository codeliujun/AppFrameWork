//
//  ZHBaseTableController.m
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "ZHBaseTableController.h"
#import <ReactiveCocoa.h>

@interface ZHBaseTableController ()

@end

@implementation ZHBaseTableController
@synthesize tableView = _tableView;

- (id)init {
    if (self = [super init]) {
        isRefresh = YES;
        nextPage = 0;
        currentPage = 1;
        canLoadMore = NO;
        isLoading = NO;
        _canLoad = NO;
    }
    
    return self;
}

- (NSMutableArray *)dataListArray {
    if (!_dataListArray) {
        _dataListArray = @[].mutableCopy;
    }
    
    return _dataListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView refreshHeaderEnable:NO];
    [_tableView refreshTailEnable:NO];
    
    [[RACObserve(self, self.dataListArray)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newArray) {
//         NSLog(@"newArray: %@", newArray);
         [self.tableView reloadData];
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.dataListArray.count == 0) {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)refresh {
    isRefresh = YES;
    currentPage = 1;
    [self loadData];
}

- (void)loadMore {
    currentPage = nextPage;
    [self loadData];
}

- (void)requestSuccess:(NSDictionary *)result {
    [super requestSuccess:result];
   
    if (_canLoad) {
        
        NSArray *array = nil;
        if (listObj) {
            array = [[listObj class] objectArrayWithKeyValuesArray:[result objectForKey:@"list"]];
        } else {
            array = [result objectForKey:@"list"];
        }
       
        nextPage = [result[@"next_page"] integerValue];
        if (nextPage == 0) {
            canLoadMore = NO;
        } else {
            canLoadMore = YES;
        }
        
        if (isRefresh) {
            isRefresh = NO;
            // 支持kvo
            [[self mutableArrayValueForKey:@"dataListArray"] removeAllObjects];
        }
        
        if (array.count > 0){ //既然是刷新，那么当没有订单返回也必须要removeAllObject
            // 支持kvo
            [[self mutableArrayValueForKey:@"dataListArray"] addObjectsFromArray:array];
        }
        
        [_tableView finishLoadData:YES];
        _tableView.refreshHeaderView.state = EGOPullRefreshNormal;
    }
}

- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (_canLoad) {
        [dic setValue:@(currentPage) forKey:@"page"];
        [dic setValue:@(20) forKey:@"page_size"];
    }
    
    [super requestMethod:method parameter:dic];
}

//- (void)requestMethod:(NSString *)method parameter:(NSDictionary *)parameters Success:(SuccessBlock)success Error:(ErrorBlock)error {
//    [super requestMethod:method parameter:parameters Success:success Error:error];
//    //    if (success) {
//    //        _successBlock = success;
//    //    }
//    //    if (error) {
//    //        _errorBlock = error;
//    //    }
//    //    [self requestMethod:method parameter:parameters];
//}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scroll frame: %@", NSStringFromCGRect(scrollView.frame));
    if ([scrollView isKindOfClass:[BCTableView class]]) {
        BCTableView *table = (BCTableView *)scrollView;
        [table scrollViewDidScroll:table];
        
        // 键盘弹出时，table的frame需要向上移动一部分
        if (_isShowKeyboarded) {
            CGRect frame = _tableView.frame;
            frame.origin.y = -80;
            _tableView.frame = frame;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[BCTableView class]]) {
        BCTableView *table = (BCTableView *)scrollView;
        [table scrollViewWillBeginDragging:table];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isKindOfClass:[BCTableView class]]) {
        BCTableView *table = (BCTableView *)scrollView;
        [table scrollViewDidEndDragging:table willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[BCTableView class]]) {
        BCTableView *table = (BCTableView *)scrollView;
        [table scrollViewDidEndDecelerating:table];
    }
}

#pragma mark - BCTableViewDelegate functions
- (void)tableView:(BCTableView *)tableView reloadDataWillBegin:(EGORefreshTableHeaderView *)refreshHeaderView
{
    [self refresh];
}

- (BOOL)tableViewLoadMore:(BCTableView *)tableView {
    if (canLoadMore) {
        [self loadMore];
        return YES;
    }
    
    return NO;
}

#pragma mark - table view default Delegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44*AutoSizeScaleY;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

#pragma mark -- keyboardNotification
- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    
    __block CGRect frame = self.tableView.frame;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0.0f options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        
        frame.origin.y = 0;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    
//    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    __block CGRect frame = self.view.frame;
//    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0.0f options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
//        frame.origin.y = -rect.size.height;
//        self.tableView.frame = frame;
//    } completion:^(BOOL finished) {
//        
//    }];
}

@end
