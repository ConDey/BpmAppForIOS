//
//  BaseTableViewCell.m
//  lib.common
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "BaseTableViewCell.h"

static const CGFloat DIVIDER_HEIGHT = 0.5;

@interface BaseTableViewCell() {
    UIColor* bgColor;
}

@end

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView*)dividerLine{
    if (_dividerLine == nil) {
        _dividerLine = [[UIView alloc] initWithFrame:CGRectZero];
        _dividerLine.backgroundColor = UI_DIVIDER_COLOR;
        [self.contentView addSubview:_dividerLine];
        [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(DIVIDER_HEIGHT);
        }];
        
    }
    return _dividerLine;
}

- (UIView*)upDividerLine{
    if (_upDividerLine == nil) {
        _upDividerLine = [[UIView alloc] initWithFrame:CGRectZero];
        _upDividerLine.backgroundColor = UI_DIVIDER_COLOR;
        [self.contentView addSubview:_upDividerLine];
        [_upDividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.contentView);
            make.height.mas_equalTo(DIVIDER_HEIGHT);
        }];
        
    }
    return _dividerLine;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeColor:)];
    tapRecognizer.minimumPressDuration = 0;//Up to you;
    tapRecognizer.cancelsTouchesInView = NO;
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}

-(void)changeColor:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        bgColor = self.backgroundColor;
        self.backgroundColor = LIGHT_GRAY_COLOR;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        self.backgroundColor = bgColor;
    }
}

//下面三个函数用于多个GestureRecognizer 协同作业，避免按下的手势影响了而别的手势不响应
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end
