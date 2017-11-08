//
//  MessageMainCell.m
//  app.msg
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "MessageMainCell.h"

@implementation MessageMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView*)msgIcon {
    if (_msgIcon == nil) {
        _msgIcon = [[UIImageView alloc] init];
        UIImage* mimage = [UIImage imageNamed:@"ic_msg"];
        _msgIcon.image = mimage;
        [self.contentView addSubview:_msgIcon];
        [_msgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return _msgIcon;
}

- (UILabel*)msgTitle {
    if (_msgTitle == nil) {
        _msgTitle = [[UILabel alloc] init];
        _msgTitle.font = FONT_16;
        _msgTitle.textColor = UI_BLACK_COLOR;
        _msgTitle.numberOfLines = 1;
        [self.contentView addSubview:_msgTitle];
        [_msgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.msgIcon.mas_right).offset(10);
            make.right.mas_equalTo(self.msgTime.mas_left).offset(-10);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        }];
        
        // 添加下划线
        self.dividerLine = [self dividerLine];
        self.upDividerLine = [self upDividerLine];
    }
    return _msgTitle;
}

- (UILabel*)msgContent {
    if (_msgContent == nil) {
        _msgContent = [[UILabel alloc] init];
        _msgContent.font = FONT_14;
        _msgContent.textColor = UI_BLACK_COLOR;
        _msgContent.numberOfLines = 0;
        [self.contentView addSubview:_msgContent];
        [_msgContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.msgIcon.mas_right).offset(10);
            make.right.mas_equalTo(self.msgTime.mas_left).offset(-10);
            make.top.mas_equalTo(self.msgTitle.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.contentView).offset(-10);
        }];
    }
    return _msgContent;
}

- (UILabel*)msgTime {
    if (_msgTime == nil) {
        _msgTime = [[UILabel alloc] init];
        _msgTime.font = FONT_12;
        _msgTime.textColor = UI_BLACK_COLOR;
        _msgTime.numberOfLines = 1;
        _msgTime.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:_msgTime];
        [_msgTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(58);
        }];
    }
    return _msgTime;
}

@end
