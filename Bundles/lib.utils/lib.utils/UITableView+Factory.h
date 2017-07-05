//
//  UITableView+Factory.h
//  UITableView
//
//  Created by eazytec on 16/1/19.
//  Copyright © 2016年 QingCha. All rights reserved.
//

#import <UIKit/UIKit.h>

// 工厂方法,用于快速创建tableView,并赋予一些公共的属性

@interface UITableView (Factory)

+ (instancetype)tableView;
+ (instancetype)groupTableView;

@end
