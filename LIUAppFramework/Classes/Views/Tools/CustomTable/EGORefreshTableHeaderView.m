//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION         0.18f
#define REFRESH_BORDER_HEADER_HEIGHT    -65.0f
#define REFRESH_BORDER_TAIL_HEIGHT      65.0f
#define REFRESH_BORDER_HEIGHT           60


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView
@synthesize key = _key;

- (EGOPullRefreshState)state {
    return _flags.state;
}

- (void)setEnable:(BOOL)enable {
    _flags.enable = enable;
}

- (BOOL)enable {
    return _flags.enable;
}

- (BOOL)isEnable {
    return _flags.enable;
}

- (void)setHeaderOrTail:(BOOL)hot {
    _flags.hot = hot;
    
    _key = @"EGORefreshTableViewTail";
    [self setState:EGOPullRefreshNormal];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (BOOL)headerOrTail {
    return _flags.hot;
}

- (BOOL)isHeader {
    return _flags.hot;
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {
    if ((self = [super initWithFrame:frame])) {
		_flags.enable = YES;
        _flags.hot = YES;
        
        self.key = @"EGORefreshTableView";
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = kColorHexString(@"#F2F2F2");

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		//label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		//label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectZero;
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:view];
		_activityView = view;
		
        _lastUpdatedLabel.frame = CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f);
        _statusLabel.frame      = CGRectMake(0.0f, frame.size.height - 55.0f, self.frame.size.width, 20.0f);
        _arrowImage.frame       = CGRectMake(90.0f, frame.size.height - 55.0f, 12.0f, 30.0f);
        _activityView.frame     = CGRectMake(105.0f, _statusLabel.frame.origin.y, 20.0f, 20.0f);
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

- (void)layoutSubviews {
    if (!_flags.enable) {
        return;
    }
    
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    if (_flags.hot) {
        _lastUpdatedLabel.frame = CGRectMake(0.0f, frame.size.height - 30.0f, kScreenWidth, 20.0f);
        _statusLabel.frame      = CGRectMake(0.0f, frame.size.height - 55.0f, kScreenWidth, 20.0f);
        _arrowImage.frame       = CGRectMake(90.0f, frame.size.height - 55.0f, 12.0f, 30.0f);
        _activityView.frame     = CGRectMake(105.0f, _statusLabel.frame.origin.y, 20.0f, 20.0f);
    } else {
        _lastUpdatedLabel.frame = CGRectMake(0.0f, 30.0f, kScreenWidth, 20.0f);
        _statusLabel.frame      = CGRectMake(0.0f, 8.0f, kScreenWidth, 20.0f);
        _arrowImage.frame       = CGRectMake(90.0f, 5.0f, 12.0f, 30.0f);
        _activityView.frame     = CGRectMake(105.0f, 8.0f, 20.0f, 20.0f);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self setState:EGOPullRefreshNormal];
}
#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    @autoreleasepool {
        if (!_flags.enable) {
            return;
        }
        
        if ([(NSObject*)self.delegate respondsToSelector:@selector(refreshTableHeaderDataSourceLastUpdated:)]) {
            
            NSDate *date = [_delegate refreshTableHeaderDataSourceLastUpdated:self];
            if (date == nil) {
                _lastUpdatedLabel.text = nil;
            } else {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setAMSymbol:[ZHLanguage localizedStringFromTable:@"Am"]];
                [formatter setPMSymbol:[ZHLanguage localizedStringFromTable:@"Pm"]];
                [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                _lastUpdatedLabel.text = [NSString stringWithFormat:[ZHLanguage localizedStringFromTable:@"Next Update Time: %@"],
                                          [formatter stringFromDate:date]];
                
                NSString *refreshKey = [NSString stringWithFormat:@"%@_%@_LastRefresh", _key, _flags.hot ? @"Header" : @"Tail"];
                [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:refreshKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        } else {
            
            _lastUpdatedLabel.text = nil;
            
        }
    }
}

- (void)setState:(EGOPullRefreshState)aState {
    if (!_flags.enable) {
        return;
    }
    
    NSString *statusText = nil;
	if ([(NSObject*)self.delegate respondsToSelector:@selector(refreshTableHeader:statusTextWithState:)]) {
        statusText = [_delegate refreshTableHeader:self statusTextWithState:aState];
    }
    
	switch (aState) {
		case EGOPullRefreshPulling:
			
			_statusLabel.text = statusText ? statusText : [ZHLanguage localizedStringFromTable:@"Release to Refresh..."];
            
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            if (_flags.hot) {
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            } else {
                _arrowImage.transform = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f);
            }

			[CATransaction commit];
			
			break;
		case EGOPullRefreshNormal:
			
			if (_flags.state == EGOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                if (_flags.hot) {
                    _arrowImage.transform = CATransform3DIdentity;
                } else {
                    _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                }                
				[CATransaction commit];
			}
			
			_statusLabel.text = statusText ? statusText : (_flags.hot ? [ZHLanguage localizedStringFromTable:@"Pull down to Refresh..."] : [ZHLanguage localizedStringFromTable:@"Pull up to Refresh..."]);
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
            if (_flags.hot) {
                _arrowImage.transform = CATransform3DIdentity;
            } else {
                _arrowImage.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
            }      
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOPullRefreshLoading:
			
			_statusLabel.text = statusText ? statusText : [ZHLanguage localizedStringFromTable:@"Updating..."];
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_flags.state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	if (!_flags.enable) {
        return;
    }
    
	if (_flags.state == EGOPullRefreshLoading) {
		
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, REFRESH_BORDER_HEIGHT);
        
        if (_flags.hot) {
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        } else {
            scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, REFRESH_BORDER_TAIL_HEIGHT, 0.0f);
        }

	} else if (scrollView.isDragging) {
        
		BOOL _loading = NO;
		if ([(NSObject*)self.delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
		}

		if (_flags.state == EGOPullRefreshPulling &&
            (_flags.hot ? (scrollView.contentOffset.y > REFRESH_BORDER_HEADER_HEIGHT && scrollView.contentOffset.y < 0.0f) :
             (scrollView.contentOffset.y > 0.0f &&
              (scrollView.contentSize.height <= scrollView.bounds.size.height ?
              (scrollView.contentOffset.y < REFRESH_BORDER_TAIL_HEIGHT) :
              scrollView.contentOffset.y + scrollView.bounds.size.height
              < REFRESH_BORDER_TAIL_HEIGHT + scrollView.contentSize.height))) &&
             !_loading) {
			[self setState:EGOPullRefreshNormal];
		} else if (_flags.state == EGOPullRefreshNormal &&
                   (_flags.hot ? (scrollView.contentOffset.y < REFRESH_BORDER_HEADER_HEIGHT) :
                        (scrollView.contentSize.height <= scrollView.bounds.size.height ?
                         (scrollView.contentOffset.y > REFRESH_BORDER_TAIL_HEIGHT) :
                                 ((scrollView.contentOffset.y + scrollView.bounds.size.height
                                   - scrollView.contentSize.height) > REFRESH_BORDER_TAIL_HEIGHT))) &&
                    !_loading) {
			[self setState:EGOPullRefreshPulling];
		}
		
//        CGFloat f = _flags.hot ? scrollView.contentInset.top : scrollView.contentInset.bottom;
//		if (f != 0) {
//			scrollView.contentInset = UIEdgeInsetsZero;
//		}
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (!_flags.enable) {
        return;
    }
    
	BOOL _loading = NO;
	if ([(NSObject*)self.delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (_flags.hot ? (scrollView.contentOffset.y <= REFRESH_BORDER_HEADER_HEIGHT) :
                     (scrollView.contentOffset.y + scrollView.bounds.size.height >=
                      scrollView.contentSize.height + REFRESH_BORDER_TAIL_HEIGHT) && 
        !_loading) {
		
		if ([(NSObject*)self.delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate refreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(_flags.hot ? REFRESH_BORDER_HEIGHT : 0.0f, 0.0f,
                                                   _flags.hot ? 0.0f : REFRESH_BORDER_TAIL_HEIGHT, 0.0f);
        
        [UIView commitAnimations];
	}
	
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
    if (!_flags.enable) {
        return;
    }
	
	[self setState:EGOPullRefreshNormal];
    
    
	[UIView beginAnimations:@"FinishLoadingAnimation" context:NULL];
	[UIView setAnimationDuration:0.3];

//    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
//    scrollView.contentInset = UIEdgeInsetsZero;
    
	[UIView commitAnimations];
}

@end
