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
@property(nonatomic,assign)NSInteger pgSize;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=LIGHT_GRAY_COLOR;
    self.pgSize=10;
    
    self.grouptableview.delegate=self;
    self.grouptableview.dataSource=self;
    [self.view addSubview:self.grouptableview];
    [self.grouptableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    
    [self.grouptableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.grouptableview.backgroundColor=[UIColor whiteColor];
    [self.grouptableview registerNib:[UINib nibWithNibName:@"NoticeListViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"NoticeList"];
    self.grouptableview.backgroundColor=LIGHT_GRAY_COLOR;
    
//    //下拉刷新
//    self.grouptableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//        [params setObject:@"" forKey:@"title"];
//        [params setObject:@"1" forKey:@"pageNo"];
//        [params setObject:@"10" forKey:@"pageSize"];
//        [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
//        NSLog(@"1");
//        [self.grouptableview.mj_header endRefreshing];
//    }];
//
//    //上拉刷新
//    self.grouptableview.mj_footer=[MJRefreshBackFooter footerWithRefreshingBlock:^{
//        //NSLog(@"down");
//        self.pgSize=self.pgSize+10;
//        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//        [params setObject:@"" forKey:@"title"];
//        [params setObject:@"1" forKey:@"pageNo"];
//        [params setObject:@"10" forKey:@"pageSize"];
//
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"通知公告"];
    [SVProgressHUD showWithStatus:@""];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:@"" forKey:@"title"];
    [params setObject:@"1" forKey:@"pageNo"];
    [params setObject:@"10" forKey:@"pageSize"];
    [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
    [SVProgressHUD dismiss];
    
}

-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    
    NSArray *data=[result objectForKey:@"datas"];
    self.noticeList=[[NSArray alloc]initWithArray:data];
    [self.tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.noticeList count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoticeList"];
    NSDictionary *noticeData=[self.noticeList objectAtIndex:indexPath.section];
    [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 3, 0, 3));
    }];
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
    
    //cell阴影
    cell.layer.cornerRadius=2.0f;
    cell.layer.shadowColor=[UIColor blackColor].CGColor;
    cell.layer.shadowOffset=CGSizeMake(3, 3);
    cell.layer.shadowRadius=2.0f;
    cell.layer.shadowOpacity=0.3;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *notciceData=[self.noticeList objectAtIndex:indexPath.section];
    NSString *nd=[notciceData objectForKey:@"id"];
    NoticeDetailViewController *ndc=[[NoticeDetailViewController alloc]init];
    ndc.noticeID=nd;
    [self.navigationController pushViewController:ndc animated:YES];
    
}


@end

