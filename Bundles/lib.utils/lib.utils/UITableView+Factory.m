//
//  UITableView+Factory.m
//  UITableView
//
//  Created by eazytec on 16/1/19.
//  Copyright © 2016年 QingCha. All rights reserved.
//

#import "UITableView+Factory.h"

@implementation UITableView (Factory)

+ (instancetype)tableView {
    
    UITableView *_tableView = [[self alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [_tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _tableView.scrollEnabled = YES;
    _tableView.userInteractionEnabled = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.sectionHeaderHeight = 0.f;
    _tableView.sectionFooterHeight = 0.f;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = view;
    return _tableView;
}

+ (instancetype)groupTableView {
    
    UITableView *_tableView = [[self alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [_tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _tableView.scrollEnabled = YES;
    _tableView.userInteractionEnabled = YES;
    //_tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.sectionHeaderHeight = 0.f;
    _tableView.sectionFooterHeight = 0.f;
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    return _tableView;
}

@end
