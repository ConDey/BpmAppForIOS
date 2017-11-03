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
{
    CGFloat currentHeight;
}
@property(retain,nonatomic)NoticeDetailModel *noticeDetail;
@property(retain,nonatomic)NSArray *attachment;
@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"公告内容"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:self.notice_id  forKey:@"noticId"];
    [self httpGetRequestWithUrl:HttpProtocolServiceNoticeDetail  params:params progress:YES];
}

-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    self.noticeDetail=[NoticeDetailModel mj_objectWithKeyValues:result];
    self.attachment=[result objectForKey:@"attachments"];
    
    NSString *str = self.noticeDetail.title;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    UIFont *font = [UIFont systemFontOfSize:17];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) options:options context:nil];
    currentHeight=rect.size.height;
   // NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    
   
    [self createdTableview:currentHeight];
    NSAttributedString * as = [[NSAttributedString alloc] initWithData:[self.noticeDetail.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [self textContent:as];
    if(self.attachment.count!=0)
    {
     [self attachDownload];
    }
    [self.tableview reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        content.numberOfLines=0;
        content.textAlignment=NSTextAlignmentCenter;
        content.text=self.noticeDetail.title;
        content.font=[UIFont boldSystemFontOfSize:17];
    }else {
        //时间和创建者
        UILabel *contentCreatedBy=[[UILabel alloc]init];
        [cell addSubview:contentCreatedBy];
        [contentCreatedBy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(60);
            make.bottom.mas_equalTo(0);
        }];
        UILabel *contentTime=[[UILabel alloc]init];
        [cell addSubview:contentTime];
        [contentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(contentCreatedBy.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(0);
        }];
        
        contentCreatedBy.text=self.noticeDetail.createdBy;
        contentCreatedBy.textAlignment=NSTextAlignmentLeft;
        contentCreatedBy.textColor=FONT_GRAY_COLOR;
        contentCreatedBy.font=FONT_14;
        
        contentTime.text=self.noticeDetail.createdTime;
        contentTime.textAlignment=NSTextAlignmentLeft;
        contentTime.textColor=FONT_GRAY_COLOR;
        contentTime.font=FONT_14;
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat ch=0;
    if(indexPath.row==0){
        ch=currentHeight;
    }else{
        ch=25;
    }
    return ch;
}


-(void)tapAttachment:(NSString *)sender{
    //获取附件
    AttachmentViewController *ach=[[AttachmentViewController alloc]init];
    ach.attachmentList=self.attachment;
    [self.navigationController pushViewController:ach animated:YES];
    
}
-(void)createdTableview:(CGFloat)height{
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
   // self.tableview.backgroundColor=[UIColor blueColor];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(height+26);
    }];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableview registerClass:[UITableViewCell class]  forCellReuseIdentifier:@"NoticeDetail"];
    
}

-(void)textContent:(NSAttributedString *)jsString{
    UITextView *text=[[UITextView alloc]init];
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableview.mas_bottom).mas_equalTo(2);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
        text.delegate=self;
        text.attributedText=jsString;
        text.font=FONT_16;
        text.editable=NO;
    }];
    
}

-(void)attachDownload{
    UIButton *attach=[[UIButton alloc]init];
    [self.view addSubview:attach];
    [self.view bringSubviewToFront:attach];
    [attach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.mas_equalTo(-40);
        make.right.mas_equalTo(-20);
    }];
    UIImage *btImg=[UIImage imageNamed:@"ic_download.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    attach.backgroundColor=[UIColor whiteColor];
    [attach setBackgroundImage:btImg forState:UIControlStateNormal];
    [attach addTarget:self action:@selector(tapAttachment:) forControlEvents:UIControlEventTouchUpInside];
}


@end

