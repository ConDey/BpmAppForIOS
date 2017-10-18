//
//  EAViewController.h
//  lib.common
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAProtocol.h"

@interface EAViewController : UIViewController

@property (nonatomic,retain) UITableView *tableview;
@property (nonatomic,retain) UITableView *grouptableview;

@property (nonatomic,retain) NSBundle *bundle;



// NavigationItem是否显示，默认为YES,此属性只有在存在navigationController的时候才有意义.
@property (nonatomic,assign,readonly) BOOL navDisplay;

// NavigationItem 相关方法和配置
- (void)setNavDisplay:(BOOL)isDisplay; // 配置NavItem是否显示
- (void)setTitleOfNav:(NSString *)titleOfNav;  // 配置NavItem的title
- (void)setTitleViewOfNav:(UIView *)viewOfNav; // 配置NavItem的titleView
- (void)setCommonBackLeftButtonItem; // 配置默认的返回ButtonItem

- (void)httpGetRequestWithUrl:(HttpProtocolServiceName)name params:(NSDictionary *)params progress:(BOOL)progress;
- (void)httpPostRequestWithUrl:(HttpProtocolServiceName)name params:(NSDictionary *)params progress:(BOOL)progress;
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(NSString*)name;
- (void)didFinishHttpRequest:(NSString*)name;

@end
