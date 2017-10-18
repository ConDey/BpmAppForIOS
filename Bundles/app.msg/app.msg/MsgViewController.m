//
//  MsgViewController.m
//  app.msg
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "MsgViewController.h"
#import "MessageMainCell.h"
#import "MessageListModel.h"

const static long THREE_MINUTES_MILLS = 180000; // 三分钟
static NSString* IS_REFRESH_TRUE = @"1";
static NSString* IS_REFRESH_FALSE = @"0";

@interface MsgViewController ()

@property (nonatomic, strong) FDSlideBar* slideBar;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* datas;

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
        make.top.mas_equalTo(self.slideBar.mas_bottom);
        make.right.left.bottom.mas_equalTo(self.view);
    }];
    
    [self initData];
}

- (void) initData {
    
    _isfirst = YES;
    _isforward = NO;
    _isrefresh = NO;
    _needRefresh = true;
    
    // 获取上次请求时间
    //NSString* date = [[FMDBHelper sharedInstance] getLastRequestTimeByUsername:username withDateFormat:YES];
    NSString* date = @"2017-08-20 00:00:00";
    
    NSDictionary* dict = @{
                           @"date" : date,
                           };
    
    [self httpGetRequestWithUrl:HttpProtocolServiceMessageList params:dict progress:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - netwrok
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(NSString *)name {
    
    NSString* username = [[[CurrentUser currentUser] userdetails] username];
    _datas = [[NSMutableArray alloc] init];
    
    MessageListModel* messagesModel = [MessageListModel mj_objectWithKeyValues:result];
    if (messagesModel.success) {
        // 更新请求时间
        [[FMDBHelper sharedInstance] setLastRequestTime:[TimeUtils getNowMills] ByUserName:username];
        if ([[messagesModel datas] count] > 0) {
            
            // 存入数据到数据库中
            // 这里要new一个线程, 插数据是耗时操作
            //[[FMDBHelper sharedInstance] insetTopicIntoDB:[self getLatestTopics:[messagesModel messages]]];
            [[FMDBHelper sharedInstance] insertMessageIntoDB:[messagesModel datas]];
            
            _datas = [[FMDBHelper sharedInstance] selectMessagesFromDB];
            
        }else {
            _datas = [[FMDBHelper sharedInstance] selectMessagesFromDB];
        }
    }else {
        [SVProgressHUD showErrorWithStatus:messagesModel.errorMsg];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageMainCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageMainCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.msgIcon.image = nil;
    
    MessageModel* model = [_datas objectAtIndex:indexPath.row];
    if (model.title != nil) {
        cell.msgTitle.text = model.title;
    }
    
    if (model.content != nil) {
        cell.msgContent.text = model.content;
    }
    
    if (model.createdTime != nil) {
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [format dateFromString:model.createdTime];
        cell.msgTime.text = [TimeUtils showDate:date isShowHAndM:NO];
    }
    
    UIImage* defaultMsgIcon = [UIImage imageNamed:@"ic_msg"];
    if (model.topicIcon == nil) {
         cell.msgIcon.image = defaultMsgIcon;
    }else {
        NSString* s = [NSString stringWithFormat:@"%@%@", [REQUEST_SERVICE_URL substringWithRange:NSMakeRange(0, [REQUEST_SERVICE_URL length]-1)],model.topicIcon];
        [cell.msgIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [REQUEST_SERVICE_URL substringWithRange:NSMakeRange(0, [REQUEST_SERVICE_URL length]-1)],model.topicIcon]] placeholderImage:defaultMsgIcon];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消点击之后的选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[MessageMainCell class] forCellReuseIdentifier:@"MessageMainCell"];
        [_tableView setShowsVerticalScrollIndicator:NO];
        
    }
    return _tableView;
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
