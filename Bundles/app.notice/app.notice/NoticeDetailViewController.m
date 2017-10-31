//
//  NoticeDetailViewController.m
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeDetailModel.h"
#import "NoticeViewController.h"
#import "AttachmentViewController.h"
@interface NoticeDetailViewController ()
@property(retain,nonatomic)NoticeDetailModel *noticeDetail;
@property(retain,nonatomic)NSArray *attachment;
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
    [self.tableview registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"NoticeDetail"];
    UIButton *attach=[[UIButton alloc]init];
    [self.view addSubview:attach];
    [self.view bringSubviewToFront:attach];
    [attach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-10);
    }];
    UIImage *btImg=[UIImage imageNamed:@"ic_floatingbutton_bg.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    attach.backgroundColor=UI_BLUE_COLOR;
    [attach setBackgroundImage:btImg forState:UIControlStateNormal];
    [attach addTarget:self action:@selector(tapAttachment:) forControlEvents:UIControlEventTouchUpInside];
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
    self.attachment=[result objectForKey:@"attachments"];
    NSLog(@"%@",self.attachment);
    [self.tableview reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num=3;
    return num;
} 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoticeDetail"];
    if(cell!=nil){
        for(UIView *view in [cell subviews]){
            [view removeFromSuperview];
        }
    }
    
    if(indexPath.row==0){
        //标题
        UILabel *content=[[UILabel alloc]init];
        [cell addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell.mas_centerX);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.top.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
        content.numberOfLines=0;
        content.textAlignment=NSTextAlignmentCenter;
        content.text=self.noticeDetail.title;
        content.font=[UIFont boldSystemFontOfSize:17];
    }else if (indexPath.row==1){
        //时间
        UILabel *content=[[UILabel alloc]init];
        [cell addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.mas_equalTo(10);
           make.right.mas_equalTo(-10);
          make.top.mas_equalTo(0);
        }];
        content.text=self.noticeDetail.createdTime;
        content.textAlignment=NSTextAlignmentLeft;
        content.textColor=FONT_GRAY_COLOR;
    }else{
        //内容
        UITextView *textContent=[[UITextView alloc]init];
        [cell addSubview:textContent];
        [textContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
        //html转字符串
        NSAttributedString * as = [[NSAttributedString alloc] initWithData:[self.noticeDetail.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        textContent.delegate=self;
        //textContent.text=self.noticeDetail.content;
        textContent.attributedText=as;
        textContent.font=[UIFont systemFontOfSize:17];
        textContent.selectable=NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0;
    if(indexPath.row==0){
        height=80;
    }else if (indexPath.row==1){
        height=21;
    }else{
        height=SCREEN_HEIGHT-NAV_HEIGHT-90;
    }
    return height;
}

-(void)tapAttachment:(NSString *)sender{
    //获取附件
    AttachmentViewController *ach=[[AttachmentViewController alloc]init];
    ach.attachmentList=self.attachment;
    [self.navigationController pushViewController:ach animated:YES];
    
}

@end

