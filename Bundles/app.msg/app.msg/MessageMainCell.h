//
//  MessageMainCell.h
//  app.msg
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageMainCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView* msgIcon;
@property (nonatomic, strong) UILabel* msgTitle;
@property (nonatomic, strong) UILabel* msgContent;
@property (nonatomic, strong) UILabel* msgTime;

@end
