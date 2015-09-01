//
//  BCTableView.h
//  BookingCar
//
//  Created by Michael Shan on 14-10-29.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BCTableView;
@protocol BCTableViewDelegate <UITableViewDelegate>

@optional

- (void)tableView:(BCTableView *)tableView reloadDataWillBegin:(EGORefreshTableHeaderView *)refreshHeaderView;

- (void)tableView:(BCTableView *)tableView reloadDataDidFinish:(EGORefreshTableHeaderView *)refreshHeaderView;

- (BOOL)tableViewLoadMore:(BCTableView *)tableView;

@end

@protocol BCTableViewDataSource <UITableViewDataSource>

- (NSDate *)tableView:(BCTableView *)tableView lastUpdated:(EGORefreshTableHeaderView *)refreshHeaderView;

- (NSString *)tableView:(BCTableView *)tableView
    statusTextWithState:(EGOPullRefreshState)state
   forRefreshHeaderView:(EGORefreshTableHeaderView *)refreshHeaderView;

@end


@interface BCTableView : UITableView <EGORefreshTableHeaderDelegate, UIScrollViewDelegate> {
    CGPoint     _originPoint;
    
    EGORefreshTableHeaderView * _refreshHeaderView;
    EGORefreshTableHeaderView * _refreshTailView;
    
    
    UILabel *                  _fluctuationLabel;
    UIImageView *              _fluctuationView;
    
    struct {
        unsigned int headerReloading : 1;
        unsigned int tailReloading : 1;
        unsigned int headerEnabled : 1;
        unsigned int tailEnabled : 1;
    } _bcTableFlags;
}

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshTailView;

- (void)showFluctuationView;

- (void)refreshHeaderEnable:(BOOL)enable;
- (void)refreshTailEnable:(BOOL)enable;

- (void)finishLoadData:(BOOL)headOrTail;

@end
