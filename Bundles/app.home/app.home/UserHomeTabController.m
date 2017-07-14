//
//  UserHomeTabController.m
//  BpmApp
//
//  Created by ConDey on 2016/10/19.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import "UserHomeTabController.h"
#import "com_eazytec_bpm_lib_common/UIConstant.h"
#import <Small/Small.h>

#import "UserHomeAppController.h"
#import "UserHomeSettingController.h"

@interface UserHomeTabController ()

@property (nonatomic,retain) NSBundle *bundle;

@end

@implementation UserHomeTabController

- (instancetype)init {
    if (self = [super init]) {
        [self initTabs];
    }
    return self;
}

/**
 *  初始化Tabs
 *
 *  消息：  交给app.msg模块
 *  应用：  本模块支持
 *  通讯录： 交给app.contact模块
 *  设置：  本模块支持
 *
 */
- (void)initTabs {
    
    // 设置TabBarItem全局属性
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UI_BLUE_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:4];
    
    self.bundle = [NSBundle bundleForClass:[self class]];
    
    [controllers addObject:[self msgController]];
    [controllers addObject:[self appController]];
    [controllers addObject:[self contactController]];
    [controllers addObject:[self settingController]];
    self.viewControllers = controllers;
}


- (UIViewController *)msgController {
    UIViewController *controller = [Small controllerForUri:@"app.msg"];
    UIImage *image = [UIImage imageNamed:@"ic_home_msg" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UIImage *selected_image = [UIImage imageNamed:@"ic_home_msg_on" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:image selectedImage:selected_image];
    controller.tabBarItem = barItem;
    return controller;
    
}

- (UIViewController *)appController {
    UIViewController *controller = [[UserHomeAppController alloc]initWithNibName:@"UserHomeAppController" bundle:self.bundle];
    UIImage *image = [UIImage imageNamed:@"ic_home_app" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UIImage *selected_image = [UIImage imageNamed:@"ic_home_app_on" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:@"应用" image:image selectedImage:selected_image];
    controller.tabBarItem = barItem;
    return controller;
    
}

- (UIViewController *)contactController {
    UIViewController *controller = [Small controllerForUri:@"app.contact"];
    UIImage *image = [UIImage imageNamed:@"ic_home_contact" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UIImage *selected_image = [UIImage imageNamed:@"ic_home_contact_on" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:@"通讯录" image:image selectedImage:selected_image];
    controller.tabBarItem = barItem;
    return controller;
}

- (UIViewController *)settingController {
    UIViewController *controller = [[UserHomeSettingController alloc]init];
    UIImage *image = [UIImage imageNamed:@"ic_home_setting" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UIImage *selected_image = [UIImage imageNamed:@"ic_home_setting_on" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:image selectedImage:selected_image];
    controller.tabBarItem = barItem;
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
