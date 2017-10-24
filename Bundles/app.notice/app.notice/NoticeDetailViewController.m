//
//  NoticeDetailViewController.m
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeDetailModel.h"
#import "NoticeDetailViewCell.h"
#import "NoticeViewController.h"
@interface NoticeDetailViewController ()
@property(retain,nonatomic)NoticeDetailModel *noticeDetail;

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableview registerNib:[UINib nibWithNibName:@"NoticeDetailViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"NoticeDetail"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"公告内容"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:self.noticeID  forKey:@"noticId"];
    [self httpGetRequestWithUrl:HttpProtocolServiceNoticeDetail  params:params progress:YES];
}

-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    self.noticeDetail=[NoticeDetailModel mj_objectWithKeyValues:result];
    
    [self.tableview reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDetailViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoticeDetail"];
    //html转字符串
    NSAttributedString * as = [[NSAttributedString alloc] initWithData:[self.noticeDetail.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    //内容
    cell.noticeDetailTitle.text=self.noticeDetail.title;
    cell.noticeDetailTime.text=self.noticeDetail.createTime;
    cell.noticeDetailContent.attributedText=as;
    //cell属性
    cell.noticeDetailTime.textAlignment=NSTextAlignmentLeft;
    cell.noticeDetailTime.textColor=FONT_GRAY_COLOR;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size.height;
}


@end

