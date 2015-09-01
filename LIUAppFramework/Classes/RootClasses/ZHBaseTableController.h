//
//  ZHBaseTableController.h
//  ZHTourist
//
//  Created by Michael Shan on 15/8/2.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#define kGetKeyboardHeight(notification)    [notification.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height

#import <UIKit/UIKit.h>
#import "ZHBaseViewController.h"
#import "ZHOrderObj.h"
#import "MJExtension.h"
#import "BCTableView.h"

@interface ZHBaseTableController : ZHBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    id listObj;
    
    NSInteger currentPage;
    NSInteger nextPage;
    BOOL _canLoad;//用来判断这个界面需不需要load（拼接URL需要）
    BOOL isRefresh;
    BOOL canLoadMore;
    BOOL isLoading;
}

@property (weak, nonatomic) IBOutlet BCTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataListArray;

- (void)loadMore;
- (void)refresh;

@end
