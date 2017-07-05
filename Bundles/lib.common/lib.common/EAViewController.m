//
//  EAViewController.m
//  lib.common
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import "EAViewController.h"
#import "com_eazytec_bpm_lib_utils/lib.utils.h"

@interface EAViewController ()

@end

@implementation EAViewController

/**
 *  viewDidLoad 公共配置
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavDisplay:YES]; // 默认navigationitem是显示的
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.hasTabBarController) {
        self.tabBarController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //self.view.backgroundColor = [UIColor bkColor];
}

/**
 *  didReceiveMemoryWarning 公共配置
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  viewWillAppear 公共配置
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 如果存在NavController,则preferredStatusBarStyle方法是无效的，所以我们需要定义UIBarStyle
    // 如果preferredStatusBarStyle是UIStatusBarStyleLightContent是BarStyle是UIBarStyleBlack;
    if (self.hasNavController) {
        self.navigationController.navigationBar.barStyle = ([self preferredStatusBarStyle] == UIStatusBarStyleLightContent) ? UIBarStyleBlack : UIBarStyleDefault;
    }
}

/**
 *  viewWillDisappear 公共配置
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/**
 *  如果存在NavController,这个值是无效的
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 *  这个配置在任何时候都是有效的,子类可以重写
 */
- (BOOL)prefersStatusBarHidden {
    return NO;
}

/**
 *  设置NavItem是否显示
 *  @param isDisplay navitem是否显示
 */
-(void)setNavDisplay:(BOOL)isDisplay {
    _navDisplay = isDisplay;
    [self.navigationController setNavigationBarHidden:!isDisplay];
    
    if (self.hasTabBarController) {
        [self.tabBarController.navigationController setNavigationBarHidden:!isDisplay];
    }
}

/**
 *  初始化NavigationItemTitle
 *  1.如果存在TabBarController,则navigationItem是由tabBarController来管理的.
 *  2.如果有自定义的NavigationItemTitle,那此方法没有任何作用.
 */
- (void)setTitleOfNav:(NSString *)titleOfNav {
    if (self.hasTabBarController) {
        [self.tabBarController setTitle:titleOfNav];
    }else {
        // 这里要提醒一下self.navigationController.navigationItem 没有任何用处.
        [self setTitle:titleOfNav];
    }
}

/**
 *  初始化NavigationItem.titleView
 *  1.如果存在TabBarController,则navigationItem是由tabBarController来管理的.
 */
-(void)setTitleViewOfNav:(UIView *)viewOfNav {
    if (self.hasTabBarController) {
        [self.tabBarController.navigationItem setTitleView:viewOfNav];
    }else {
        [self.navigationItem setTitleView:viewOfNav];
    }
}

/**
 *  是否存在NavController,如果不存在，那有些属性就没有任何意义.
 *  @return 是否存在NavController
 */
- (BOOL)hasNavController {
    return self.navigationController != nil;
}

/**
 *  是否存在TabBarController或者是否是TabBarController的直接关系人.
 *  @return 是否存在TabBarController
 */
- (BOOL)hasTabBarController {
    return self.tabBarController != nil;
}

/**
 *   配置默认的返回ButtonItem
 */
-(void)setCommonBackLeftButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Common_Back"] style:UIBarButtonItemStylePlain target:self action:@selector(doNavigationLeftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

/**
 *  返回上一页
 */
- (void)doNavigationLeftBarButtonItemAction:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 相关公共属性的初始化方法 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- (UITableView *)tableview {
    if(_tableview == nil) {
        _tableview = [UITableView tableView];
    }
    return _tableview;
}

- (UITableView *)grouptableview {
    if(_tableview == nil) {
        _tableview = [UITableView groupTableView];
    }
    return _tableview;
}

@end
