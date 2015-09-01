//
//  LoadMoreCell.m
//  Breast
//
//  Created by Michael on 14-3-21.
//  Copyright (c) 2014年 Two. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell
@synthesize activity, lbLoadMore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)reuseIdentifier {
    return @"LoadMoreCellIdentifier";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [activity startAnimating];
    lbLoadMore.text = [ZHLanguage localizedStringFromTable:@"Loading..."];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
