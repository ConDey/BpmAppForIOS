//
//  EAViewController.m
//  lib.common
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import "EAViewController.h"
#import "UITableView+Factory.h"

#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "EAProtocol.h"
#import "UIColor+EAFoundation.h"
#import "UIConstant.h"

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
    self.view.backgroundColor = UI_BK_COLOR;
    
    // 全局设置
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    });
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
    return UIStatusBarStyleDefault;
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
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Common_Back"] style:UIBarButtonItemStylePlain target:self action:@selector(doNavigationLeftBarButtonItemAction:)];
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


- (NSBundle *)bundle {
    if(_bundle == nil) {
        _bundle = [NSBundle bundleForClass:[self class]];
    }
    return _bundle;
}

- (void)httpPostRequestWithUrl:(HttpProtocolServiceName)name params:(NSDictionary *)params progress:(BOOL)progress {
    
    AFHTTPSessionManager *manager = [[EAProtocol sharedInstance] createAFHTTPSessionManager:name];
    
    if (progress) {
        [SVProgressHUD showWithStatus:@"正在努力加载..."];
    }
    [manager POST:[[EAProtocol sharedInstance] loadRequestServiceUrlWithName:[[EAProtocol sharedInstance] getServiceNameByEnum:name]] parameters:params progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *result  = [[EAProtocol sharedInstance] doRequestJSONSerializationdDecode:responseObject];
              if ([[EAProtocol sharedInstance] isRequestJSONSerializationSuccess:result]) {
                  [self didAnalysisRequestResultWithData:result andService:[[EAProtocol sharedInstance] getServiceNameByEnum:name]];
                  if (progress)  [SVProgressHUD dismiss];
              }
              else {
                  if (progress) {
                      [SVProgressHUD showErrorWithStatus:[result objectForKey:@"errorMsg"]];
                      
                  }
              }
              [self didFinishHttpRequest:[[EAProtocol sharedInstance] getServiceNameByEnum:name]];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              NSLog(@"%@",error);  //这里打印错误信息
              [SVProgressHUD showErrorWithStatus:@"系统繁忙,请稍后再试"];
              [self didFinishHttpRequest:[[EAProtocol sharedInstance] getServiceNameByEnum:name]];
          }];
}


- (void)httpGetRequestWithUrl:(HttpProtocolServiceName)name params:(NSDictionary *)params progress:(BOOL)progress {
    
    AFHTTPSessionManager *manager = [[EAProtocol sharedInstance] createAFHTTPSessionManager:name];
    
    if (progress) {
        [SVProgressHUD showWithStatus:@"正在努力加载..."];
    }
    [manager GET:[[EAProtocol sharedInstance] loadRequestServiceUrlWithName:[[EAProtocol sharedInstance] getServiceNameByEnum:name]] parameters:params progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *result  = [[EAProtocol sharedInstance] doRequestJSONSerializationdDecode:responseObject];
             if ([[EAProtocol sharedInstance] isRequestJSONSerializationSuccess:result]) {
                 [self didAnalysisRequestResultWithData:result andService:[[EAProtocol sharedInstance] getServiceNameByEnum:name]];
                 if (progress)  [SVProgressHUD dismiss];
             }
             else {
                 if (progress) {
                     [SVProgressHUD showErrorWithStatus:[result objectForKey:@"errorMsg"]];
                     
                 }
             }
             [self didFinishHttpRequest:[[EAProtocol sharedInstance] getServiceNameByEnum:name]];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
             [SVProgressHUD showErrorWithStatus:@"系统繁忙,请稍后再试"];
             [self didFinishHttpRequest:[[EAProtocol sharedInstance] getServiceNameByEnum:name]];
         }];
}

- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(NSString*)name {
    
}

- (void)didFinishHttpRequest:(NSString*)name {
    
}

@end
