//
//  BCBaseTableCell.h
//  BookingCar
//
//  Created by Michael Shan on 14-10-2.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCellLineView.h"

@interface ZHBaseTableCell : UITableViewCell

+ (NSString *)identifier;
+ (id)cell;

- (void)showCellLineWithColor:(UIColor *)color AndLineSpace:(CGFloat)space;//这个space是这条线距离一边的宽度（另外一边也是这个宽度）
- (void)updateCellContent:(id)obj;

@end
