//
//  NoticeViewController.m
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeListViewCell.h"


@interface NoticeViewController ()


@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
 [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableview registerNib:[UINib nibWithNibName:@"NoticeListViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"NoticeList"];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:@"notice" forKey:@"noticId"];
    [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"通知公告"];
}

-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    self.noticeList=[result objectForKey:@"datas"];
    NSLog(@"%@",self.noticeList);
    [self.tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoticeList"];
    NSDictionary *noticeData=[self.noticeList objectAtIndex:indexPath.row];
    cell.noticeTitle.text=[noticeData objectForKey:@"title"];
    cell.createdBy.text=[noticeData objectForKey:@"createdBy"];
    cell.createdTime.text=[noticeData objectForKey:@"createdTime"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
@end
