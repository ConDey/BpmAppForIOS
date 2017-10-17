//
//  MsgViewController.m
//  app.msg
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "MsgViewController.h"

const static long THREE_MINUTES_MILLS = 180000; // 三分钟
static NSString* IS_REFRESH_TRUE = @"1";
static NSString* IS_REFRESH_FALSE = @"0";

@interface MsgViewController ()

@property (nonatomic, strong) FDSlideBar* slideBar;
@property (nonatomic, strong) UITableView* tableView;
//@property (nonatomic, strong) MessageMainViewModel* messageMainVM;

@property (nonatomic, assign) Boolean isforward;
@property (nonatomic, assign) Boolean isfirst;
@property (nonatomic, assign) Boolean isrefresh;

@property (nonatomic, assign) Boolean needRefresh;

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"消息"];
    
    self.navigationController.delegate = self;
    
    [self.view addSubview:self.slideBar];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self initData];
}

- (void) initData {
    
    _isfirst = YES;
    _isforward = NO;
    _isrefresh = NO;
    _needRefresh = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

- (FDSlideBar*)slideBar {
    if (_slideBar == nil) {
        _slideBar = [[FDSlideBar alloc] init];
        _slideBar.itemsTitle = @[@"未读", @"已读"];
        _slideBar.backgroundColor = [UIColor whiteColor];
        _slideBar.itemColor = UI_GRAY_COLOR;
        _slideBar.sliderColor = UI_BLUE_COLOR;
        _slideBar.itemSelectedColor = UI_BLUE_COLOR;
        [_slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
            [self sliderBarAction:idx];
        }];
    }
    return _slideBar;
}

// sliderBar 选择
- (void)sliderBarAction:(NSInteger)index {
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
