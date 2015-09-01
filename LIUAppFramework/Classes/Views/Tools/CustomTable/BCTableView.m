//
//  BCTableView.m
//  BookingCar
//
//  Created by Michael Shan on 14-10-29.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "BCTableView.h"

@implementation BCTableView

@synthesize refreshTailView = _refreshTailView;
@synthesize refreshHeaderView = _refreshHeaderView;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
        [self addSubview:_refreshHeaderView];
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
        
        _refreshTailView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
        [self addSubview:_refreshTailView];
        
        _refreshHeaderView.delegate     = self;
        _refreshTailView.delegate       = self;
        _refreshTailView.headerOrTail   = NO;
        
//        UIImage *image = [UIImage imageNamed:@"float_list_icon.png"];
//        UIImage *strechImage = [image stretchableImageWithLeftCapWidth:10 topCapHeight:0];
//        _fluctuationView = [[UIImageView alloc] initWithImage:strechImage];
//        _fluctuationView.backgroundColor    = [UIColor clearColor];
//        _fluctuationView.frame              = CGRectMake(0, 10, 50, _fluctuationView.frame.size.height);
//        _fluctuationView.hidden             = YES;
//        _fluctuationView.alpha              = 0;
//        
//        _fluctuationLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, _fluctuationView.frame.size.width - 6 - 2, _fluctuationView.frame.size.height)];
//        _fluctuationLabel.backgroundColor   = [UIColor clearColor];
//        _fluctuationLabel.textAlignment     = NSTextAlignmentCenter;
//        _fluctuationLabel.font              = [UIFont fontWithName:@"Helvetica-Bold" size:16];
//        _fluctuationLabel.textColor         = kColorHexString(@"#CC0000");
//        _fluctuationLabel.shadowColor       = [UIColor whiteColor];
//        _fluctuationLabel.shadowOffset      = CGSizeMake(0, 1);
//        [_fluctuationView addSubview:_fluctuationLabel];
//        [self addSubview:_fluctuationView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"%@", self);
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
    [self addSubview:_refreshHeaderView];
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
    _refreshTailView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
//    [self addSubview:_refreshTailView];
    
    _refreshHeaderView.delegate     = self;
//    _refreshTailView.delegate       = self;
//    _refreshTailView.headerOrTail   = NO;
    
//    UIImage *image = [UIImage imageNamed:@"float_list_icon.png"];
//    UIImage *strechImage = [image stretchableImageWithLeftCapWidth:10 topCapHeight:0];
//    _fluctuationView = [[UIImageView alloc] initWithImage:strechImage];
//    _fluctuationView.backgroundColor    = [UIColor clearColor];
//    _fluctuationView.frame              = CGRectMake(0, 10, 50, _fluctuationView.frame.size.height);
//    _fluctuationView.hidden             = YES;
//    _fluctuationView.alpha              = 0;
//    
//    _fluctuationLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, _fluctuationView.frame.size.width - 6 - 2, _fluctuationView.frame.size.height)];
//    _fluctuationLabel.backgroundColor   = [UIColor clearColor];
//    _fluctuationLabel.textAlignment     = NSTextAlignmentCenter;
//    _fluctuationLabel.font              = [UIFont fontWithName:@"Helvetica-Bold" size:16];
//    _fluctuationLabel.textColor         = kColorHexString(@"#CC0000");
//    _fluctuationLabel.shadowColor       = [UIColor whiteColor];
//    _fluctuationLabel.shadowOffset      = CGSizeMake(0, 1);
//    [_fluctuationView addSubview:_fluctuationLabel];
//    [self addSubview:_fluctuationView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame            = self.bounds;
    frame.origin.y          = MAX(frame.size.height, self.contentSize.height);
    _refreshTailView.frame  = frame;
    frame.origin.y          = - frame.size.height;
    _refreshHeaderView.frame= frame;
}

- (void)showFluctuationView {
    _fluctuationView.hidden = NO;
}

- (void)refreshHeaderEnable:(BOOL)enable {
    _bcTableFlags.headerEnabled = enable;
    _refreshHeaderView.enable = enable;
    _refreshHeaderView.hidden = !enable;
}

- (void)refreshTailEnable:(BOOL)enable {
    _bcTableFlags.tailEnabled = enable;
    _refreshTailView.enable = enable;
    _refreshTailView.hidden = !enable;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource:(id)obj {
    if ([self.delegate respondsToSelector:@selector(tableView:reloadDataWillBegin:)]) {
        [(id<BCTableViewDelegate>)self.delegate tableView:self reloadDataWillBegin:obj];
    }
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
}

- (void)doneLoadingTableViewData:(id)obj {
    
    if ([self.delegate respondsToSelector:@selector(tableView:reloadDataDidFinish:)]) {
        [(id<BCTableViewDelegate>)self.delegate tableView:self reloadDataDidFinish:obj];
    }
    
    if (obj == _refreshHeaderView) {
        //  model should call this when its done loading
        [_refreshHeaderView refreshScrollViewDataSourceDidFinishedLoading:self];
        _bcTableFlags.headerReloading = NO;
    } else if (obj == _refreshTailView) {
        [_refreshTailView refreshScrollViewDataSourceDidFinishedLoading:self];
        _bcTableFlags.tailReloading = NO;
    }
    
    _bcTableFlags.headerReloading = NO;
    _bcTableFlags.tailReloading = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)hideFluctView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1];
    _fluctuationView.alpha = 0;
    [UIView commitAnimations];
}

- (void)showFluctView {
    _fluctuationView.alpha = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelay:.2];
    [UIView setAnimationDuration:.3];
    CGFloat offset = MAX(14, self.contentOffset.y + 14);
    _fluctuationView.frame = CGRectMake(self.contentOffset.x, offset, _fluctuationView.frame.size.width, _fluctuationView.frame.size.height);
    [UIView commitAnimations];
}

- (void)finishLoadData:(BOOL)headOrTail {
    EGORefreshTableHeaderView *view = headOrTail ? _refreshHeaderView : _refreshTailView;
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData:) withObject:view waitUntilDone:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_bcTableFlags.headerReloading || _bcTableFlags.tailReloading) {
        return;
    }
    
    if (scrollView == self) {
        if (_bcTableFlags.headerReloading) {
            [_refreshTailView refreshScrollViewDidScroll:scrollView];
        } else if (_bcTableFlags.tailReloading) {
            [_refreshTailView refreshScrollViewDidScroll:scrollView];
        } else if (scrollView.contentOffset.y > 0) {
            [_refreshTailView refreshScrollViewDidScroll:scrollView];
        } else if (scrollView.contentOffset.y < -0) {
            [_refreshHeaderView refreshScrollViewDidScroll:scrollView];
        }
        
        if (![_fluctuationView isHidden]) {
            NSArray *indexPaths = [self indexPathsForVisibleRows];
            if ([indexPaths count]) {
                NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
                _fluctuationLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row + 1)];
            }
            CGFloat offset = MAX(14, self.contentOffset.y + 14);
            _fluctuationView.frame = CGRectMake(self.contentOffset.x, offset, _fluctuationView.frame.size.width, _fluctuationView.frame.size.height);
        }
        
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - currentOffset <= 50.f) {
            BOOL result = [(id<BCTableViewDelegate>)self.delegate tableViewLoadMore:self];
            _bcTableFlags.tailReloading = result;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self) {
        if (![_fluctuationView isHidden]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFluctView) object:nil];
            [self showFluctView];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self) {
        if (![_fluctuationView isHidden]) {
            [_fluctuationView.layer removeAllAnimations];
            _fluctuationView.alpha = 1;
        }
    }
}

- (void)localizationFluctuationView {
    if (![_fluctuationView isHidden]) {
        NSArray *cells = [self visibleCells];
        CGFloat originY = 0, height = 0;
        if ([cells count] > 0) {
            UIView *cell = [cells objectAtIndex:0];
            originY = cell.frame.origin.y;
            if (self.contentOffset.y - originY > 6) {
                height = cell.frame.size.height;
                _fluctuationLabel.text = [NSString stringWithFormat:@"%d", [_fluctuationLabel.text intValue] + 1];
            }
        }
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:.3];
        _fluctuationView.frame = CGRectMake(self.contentOffset.x, MAX(10, originY + height + 10), _fluctuationView.frame.size.width, _fluctuationView.frame.size.height);
        [UIView commitAnimations];
        
        if (![_fluctuationView isHidden]) {
            [self performSelector:@selector(hideFluctView) withObject:nil afterDelay:2];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self) {
        [self localizationFluctuationView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_bcTableFlags.headerReloading || _bcTableFlags.tailReloading) {
        return;
    }
    
    if (scrollView == self) {
        if (_bcTableFlags.headerReloading) {
            [_refreshHeaderView refreshScrollViewDidEndDragging:scrollView];
        } else if (_bcTableFlags.tailReloading) {
            [_refreshTailView refreshScrollViewDidEndDragging:scrollView];
        } else if (scrollView.contentOffset.y > 0) {
            [_refreshTailView refreshScrollViewDidEndDragging:scrollView];
        } else if (scrollView.contentOffset.y < -0) {
            [_refreshHeaderView refreshScrollViewDidEndDragging:scrollView];
        }
        
        [self localizationFluctuationView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)refreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    @synchronized (self) {
        if (view == _refreshHeaderView) {
            _bcTableFlags.headerReloading = YES;
        } else if (view == _refreshTailView) {
            _bcTableFlags.tailReloading = YES;
        }
    }
    [self reloadTableViewDataSource:view];
}

- (BOOL)refreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    if (view == _refreshHeaderView) {
        return _bcTableFlags.headerReloading;
    } else if (view == _refreshTailView) {
        return _bcTableFlags.tailReloading;
    }
    
    return NO; // should return if data source model is reloading
    
}

- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    if ([self.dataSource respondsToSelector:@selector(tableView:lastUpdated:)]) {
        return [(id<BCTableViewDataSource>)self.dataSource tableView:self lastUpdated:view];
    }
    
    return [NSDate date]; // should return date data source was last changed
}

- (NSString *)refreshTableHeader:(EGORefreshTableHeaderView *)view statusTextWithState:(EGOPullRefreshState)state {
    if (!view.headerOrTail) {
        if (state == EGOPullRefreshNormal) {
            return [NSString stringWithFormat:[ZHLanguage localizedStringFromTable:@"Pull to load next %d items"], 20];
        } else if (state == EGOPullRefreshPulling) {
            return [ZHLanguage localizedStringFromTable:@"Release to Load"];
        }
    }
    return nil;
}

@end
