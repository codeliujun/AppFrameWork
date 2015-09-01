//
//  UITableView+Additions.m
//  BookingCar
//
//  Created by Michael Shan on 14-10-1.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "UITableView+Additions.h"

@implementation UITableView (Additions)

- (void)deselect:(BOOL)animated {
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:animated];
}

@end
