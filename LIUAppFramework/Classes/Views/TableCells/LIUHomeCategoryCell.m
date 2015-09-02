//
//  LIUHomeCategoryCell.m
//  YouYouShoppingCenter
//
//  Created by liujun on 15/7/27.
//  Copyright (c) 2015年 刘俊. All rights reserved.
//

#import "LIUHomeCategoryCell.h"
#import "UIImage+GetUrlImage.h"

@interface LIUHomeCategoryCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *catrgoryLabel;


@end

@implementation LIUHomeCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCaterInfo:(NSDictionary *)caterInfo {
    _caterInfo = caterInfo;
    
//    //1.读取缓存中又没有图
//    __block UIImage *image = [[ZHCache sharedCache] imageForKey:caterInfo[@"name"]];
//    
//    if (image) {
//        self.categoryIcon.image = image;
//    }else {
//        NSString *imageStr = [caterInfo[@"thumb"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (data) {
//                    image = [UIImage imageWithData:data];
//                    self.categoryIcon.image = image;
//                    [[ZHCache sharedCache] setImage:image forKey:caterInfo[@"name"]];
//                }else {
//                    self.categoryIcon.image = [UIImage imageNamed:@"测试图片"];
//                }
//
//            });
//        });
//        
//           }
    WS(ws);
   [UIImage getImageWithThumble:caterInfo[@"thumb"]Success:^(UIImage *image) {
       ws.categoryIcon.image = image;
   }];
    self.catrgoryLabel.text = caterInfo[@"name"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
