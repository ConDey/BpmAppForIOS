//
//  NoticeViewController.m
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeListViewCell.h"
#import "NoticeDetailViewController.h"


@interface NoticeViewController ()
@property(nonatomic,assign)NSInteger pgNo;
@property(nonatomic,assign)NSInteger cellHeight;
@property(nonatomic,assign)BOOL isUp;
@property(nonatomic,assign)BOOL isDown;
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,retain)NSString *totalPage;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=LIGHT_GRAY_COLOR;
    self.pgNo=1;
    self.isUp=NO;
    self.isDown=NO;
    self.isFirst=NO;
    self.cellHeight=70;
    
    self.grouptableview.delegate=self;
    self.grouptableview.dataSource=self;
    [self.view addSubview:self.grouptableview];
    [self.grouptableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    self.grouptableview.scrollEnabled=YES;
    [self.grouptableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.grouptableview.backgroundColor=[UIColor whiteColor];
    [self.grouptableview registerNib:[UINib nibWithNibName:@"NoticeListViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"NoticeList"];
    self.grouptableview.backgroundColor=LIGHT_GRAY_COLOR;
    
    //下拉刷新
    self.grouptableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isUp=YES;
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:@"" forKey:@"title"];
        [params setObject:@"1" forKey:@"pageNo"];
        [params setObject:[NSString stringWithFormat:@"%ld",(int)(SCREEN_HEIGHT-105)/self.cellHeight+1] forKey:@"pageSize"];
        [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
        [self.grouptableview.mj_header endRefreshing];

    }];

    //上拉刷新
    //每次下拉保留上次的最后2个
 self.grouptableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
     if(self.totalPage==[NSString stringWithFormat:@"%ld",self.pgNo]){
         [self.grouptableview.mj_footer endRefreshingWithNoMoreData];
     }
        self.isDown=YES;
        self.pgNo=self.pgNo+1;
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:@"" forKey:@"title"];
          [params setObject:[NSString stringWithFormat:@"%ld",self.pgNo] forKey:@"pageNo"];
          [params setObject:[NSString stringWithFormat:@"%ld",(int)(SCREEN_HEIGHT-105)/self.cellHeight-2] forKey:@"pageSize"];
         [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
         [self.grouptableview.mj_footer endRefreshing];

    }];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"通知公告"];
    [SVProgressHUD showWithStatus:@""];
    self.isFirst=YES;
   
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:@"" forKey:@"title"];
    [params setObject:@"1" forKey:@"pageNo"];
    [params setObject:[NSString stringWithFormat:@"%ld",(int)(SCREEN_HEIGHT-105)/self.cellHeight+1] forKey:@"pageSize"];
    [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
    [SVProgressHUD dismiss];
    
}

-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    self.totalPage=[result objectForKey:@"totalPages"];
    NSArray *data=[result objectForKey:@"datas"];
    if(self.isFirst){
        self.noticeList=[[NSMutableArray alloc]initWithArray:data];
          self.isFirst=NO;
         [self.grouptableview reloadData];
    }
    if(self.isUp){
    self.noticeList=[[NSMutableArray alloc]initWithArray:data];
        self.isUp=NO;
         [self.grouptableview reloadData];
    }
    if(self.isDown){
        [self.noticeList addObjectsFromArray:data];
        NSLog(@"%ld",self.noticeList.count);
         self.isDown=NO;
         [self.grouptableview reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.noticeList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoticeList"];
    if(indexPath.row<[self.noticeList count]){
    NSDictionary *noticeData=[self.noticeList objectAtIndex:indexPath.row];
  
    cell.noticeTitle.text=[noticeData objectForKey:@"title"];
    cell.createdBy.text=[noticeData objectForKey:@"createdBy"];
    cell.createdTime.text=[noticeData objectForKey:@"createdTime"];
    //标题
    cell.noticeTitle.font=[UIFont boldSystemFontOfSize:17];
    //创建人边框
    cell.backgroundColor=[UIColor whiteColor];
    cell.createdBy.textColor=UI_BLUE_COLOR;
    cell.createdBy.layer.borderWidth=1;
    cell.createdBy.layer.borderColor=UI_BLUE_COLOR.CGColor;
    cell.createdBy.layer.cornerRadius=4.f;
    cell.createdBy.layer.masksToBounds=YES;
    //创建时间
    cell.createdTime.textColor=FONT_GRAY_COLOR;
    }
    //cell阴影
    cell.layer.cornerRadius=2.0f;
    cell.layer.shadowColor=[UIColor blackColor].CGColor;
    cell.layer.shadowOffset=CGSizeMake(3, 3);
    cell.layer.shadowRadius=2.0f;
    cell.layer.shadowOpacity=0.3;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *notciceData=[self.noticeList objectAtIndex:indexPath.row];
    NSString *nd=[notciceData objectForKey:@"id"];
    NoticeDetailViewController *ndc=[[NoticeDetailViewController alloc]init];
    ndc.noticeID=nd;
    [self.navigationController pushViewController:ndc animated:YES];
    
}
// 自定义TableViewCell分割线, 清除前面15PX的空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end

