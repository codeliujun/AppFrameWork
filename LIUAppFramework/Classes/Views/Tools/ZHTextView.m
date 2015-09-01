//
//  BCTextView.m
//  BookingCar
//
//  Created by Michael Shan on 14-11-17.
//  Copyright (c) 2014年 Michael. All rights reserved.
//

#import "ZHTextView.h"
#import <Masonry/Masonry.h>

#define WS(weakSelf) __weak __typeof(&*self)weakSelf=self

@interface ZHTextView () {
    UILabel *lbPlaceholder;
}

@end

@implementation ZHTextView

- (void)initView {
    lbPlaceholder = [[UILabel alloc] initWithFrame:CGRectZero];
    lbPlaceholder.textColor = kLightCellDescColor;
    lbPlaceholder.text = nil;
    [self addSubview:lbPlaceholder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame {
//    if (self = [super init]) {
//        [self initView];
//    }
//    
//    return self;
//}

- (void)layoutSubviews {
//    lbPlaceholder.frame = CGRectMake(5, 8, self.frame.size.width-10, self.font.lineHeight);
    lbPlaceholder.font = self.font;
    lbPlaceholder.text = _placeholder;
    WS(ws);
    [lbPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).with.offset(5);
        make.top.equalTo(ws.mas_top).with.offset(7);
        make.width.equalTo(@200);
        make.height.equalTo(@(self.font.lineHeight));
    }];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    if (text.length > 0) {
        super.text = text;
        lbPlaceholder.hidden = YES;
    }
}

#pragma mark - UITextView delegate
- (void)textViewBeginEditing:(NSNotification *)notification {
    
}

- (void)textViewDidChange:(NSNotification *)notification {
    if (self.text.length > 0) {
        lbPlaceholder.hidden = YES;
    } else {
        lbPlaceholder.hidden = NO;
    }
}

- (void)textViewDidEndEditing:(NSNotification *)notification {
    if (self.text.length > 0) {
        lbPlaceholder.hidden = YES;
    } else {
        lbPlaceholder.hidden = NO;
    }
}


@end
