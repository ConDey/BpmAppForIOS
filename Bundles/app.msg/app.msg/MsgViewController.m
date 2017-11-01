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

@property (nonatomic, assign) Boolean isInUnRead; // 在未读界面

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _isforward = YES;
    if (_isfirst) {
        _isfirst = NO;
    }else {
        long long lastRequestTime = [[[FMDBHelper sharedInstance] getLastRequestTimeByUsername:[[CurrentUser currentUser] userdetails].username withDateFormat:NO] longLongValue];
        if ([[[FMDBHelper sharedInstance] getIsRefresh] isEqualToString:IS_REFRESH_TRUE]) {
            [[FMDBHelper sharedInstance] updateIsRefresh:IS_REFRESH_FALSE];
            [self loadFromNetwork];
        }else {
            if (([TimeUtils getNowMillsByLong] - lastRequestTime) > THREE_MINUTES_MILLS) {
                [self loadFromNetwork];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isforward = NO;
}

- (void) initData {
    
    _isfirst = YES;
    _isforward = NO;
    _isrefresh = NO;
    _needRefresh = true;
    _isInUnRead = YES;
    
    [self loadFromNetwork];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - netwrok
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    
    if (name == HttpProtocolServiceMessageList) {
    
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
    
    if (name == HttpProtocolServiceMessageReaded) {
        BaseModel* resultModel = [BaseModel mj_objectWithKeyValues:result];
        if (!resultModel.success) {
            [SVProgressHUD showErrorWithStatus:resultModel.errorMsg];
        }
    }
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
    
    UIImage* defaultMsgIcon = [UIImage imageNamed:@"ic_message_default" inBundle:self.bundle compatibleWithTraitCollection:nil];
    if (model.topicIcon == nil) {
         cell.msgIcon.image = defaultMsgIcon;
    }else {
        [cell.msgIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [REQUEST_SERVICE_URL substringWithRange:NSMakeRange(0, [REQUEST_SERVICE_URL length]-1)],model.topicIcon]] placeholderImage:defaultMsgIcon];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消点击之后的选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageModel* model = [_datas objectAtIndex:indexPath.row];
    
    if (model.canClick) {
        if (model.msgId != nil) {
            // 更新已读状态
            [[FMDBHelper sharedInstance] updateMessageReadState:model.msgId];
            // 更新服务器上已读状态
            NSDictionary* dict = @{
                                   @"internalMessageId" : model.internalMsgId,
                                   };
            [self httpGetRequestWithUrl:HttpProtocolServiceMessageReaded params:dict progress:NO];
            
            if (_isInUnRead) {
                _datas = [[FMDBHelper sharedInstance] selectMessagesFromDB];
            }else {
                _datas = [[FMDBHelper sharedInstance] selectReadedMessagesFromDB];
            }
            [self.tableView reloadData];
            
            // 根据url跳转
            NSString* url = @"";
            NSString* clickUrl = model.clickUrl;
            if (clickUrl != nil && ![clickUrl isEqualToString:@""]) {
                if ([clickUrl hasPrefix:@"native"]) {
                    clickUrl = [clickUrl stringByReplacingOccurrencesOfString:@"native:" withString:@""];
                    [Small openUri:clickUrl fromController:self];
                }else {
                    clickUrl = [clickUrl stringByReplacingOccurrencesOfString:@"h5:" withString:@""];
                    if ([clickUrl hasPrefix:@"http:"] || [clickUrl hasPrefix:@"https:"] ||
                        [clickUrl hasPrefix:@"file:"]) {
                        url = clickUrl;
                    }else {
                        url = [NSString stringWithFormat:@"%@%@", REQUEST_SERVICE_URL, clickUrl];
                    }
                    // 这里要把url中的&替换掉，不然中间的参数也会被直接截取导致url不全，提示404错误。这里用一个url中不会出现的符号替换
                    url = [url stringByReplacingOccurrencesOfString:@"&" withString:@"EAZYTEC"];
                    [Small openUri:[NSString stringWithFormat:@"app.webkit?url=%@&urltitle=%@", url, [NSString encodeString:model.title]] fromController:self];
                }
            }
        }
        
    }
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
    if (index == 0) {
        _isInUnRead = YES;
        _datas = [[FMDBHelper sharedInstance] selectMessagesFromDB];
    }else {
        _isInUnRead = NO;
        _datas = [[FMDBHelper sharedInstance] selectReadedMessagesFromDB];
    }
    [self.tableView reloadData];
}

#pragma mark - Push Refresh
- (void)loadFromNetwork {
    // 获取上次请求时间
    NSString* date = [[FMDBHelper sharedInstance] getLastRequestTimeByUsername:[[CurrentUser currentUser] userdetails].username withDateFormat:YES];
    //NSString* date = @"2017-08-20 00:00:00";
    NSDictionary* dict = @{
                           @"date" : date,
                           };
    [self httpGetRequestWithUrl:HttpProtocolServiceMessageList params:dict progress:NO];
}

- (void)getTheNotification {
    if (_isforward) {
        [self loadFromNetwork];
    }else {
        [[FMDBHelper sharedInstance] updateIsRefresh:IS_REFRESH_TRUE];
    }
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
