//
//  BaseTableViewCell.h
//  lib.common
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

// 下划线
@property (nonatomic, strong) UIView* dividerLine;
// 上划线 用于第一个cell
@property (nonatomic, strong) UIView* upDividerLine;

@end
