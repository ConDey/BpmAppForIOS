//
//  HomeNavController.m
//  BpmApp
//
//  Created by ConDey on 2016/10/19.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import "UserHomeNavController.h"

@interface UserHomeNavController ()

@end

@implementation UserHomeNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色，本身默认就是白色
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置title的字体和颜色，这里不需要
    //[self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]}];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
