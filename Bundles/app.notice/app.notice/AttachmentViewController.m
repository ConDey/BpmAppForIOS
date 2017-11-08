//
//  AttachmentViewController.m
//  app.notice
//
//  Created by feng sun on 2017/10/30.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "AttachmentViewController.h"

@interface AttachmentViewController ()

@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"attachmentCell"];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setTitleOfNav:@"附件"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.attachmentList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"attachmentCell"];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"attachmentCell"];
    }else{
        for(UIView *view in [cell subviews]){
            [view removeFromSuperview];
        }
    }
    UIView *singleView=[[UIView alloc]init];//分割线
    [cell addSubview:singleView];
    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    singleView.backgroundColor=UI_DIVIDER_COLOR;
    
    NSArray *fileType=@[@"apk",@"doc",@"img",@"pdf",@"ppt",@"txt",@"xls",@"zip",@"bg"];
    NSDictionary *attachDic =[self.attachmentList objectAtIndex:indexPath.row];
    NSString *str=[attachDic objectForKey:@"name"];
    
    UIImageView *attachImg=[[UIImageView alloc]init];
    UILabel *attachLabel=[[UILabel alloc]init];
    UILabel *loadLabel=[[UILabel alloc]init];
    [cell addSubview:attachLabel];
    [cell addSubview:loadLabel];
    [cell addSubview:attachImg];
    [attachImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [attachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(250, 35));
        make.left.mas_equalTo(attachImg.mas_right).mas_equalTo(10);
    }];
    [loadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(attachLabel.mas_right).mas_equalTo(5);
    }];
    BOOL isEqual=NO;
    NSString *strTail=[str substringFromIndex:[str rangeOfString:@"."].location+1];
    for(NSString *type in fileType){
        if([strTail isEqualToString:type]){
            isEqual=YES;
        }
    }
    
    
    if([strTail isEqualToString:@"png"]||[strTail isEqualToString:@"jpg"]){
        attachImg.image=[UIImage imageNamed:@"ic_download_type_img.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    }else{
        if(isEqual){
            attachImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_download_type_%@.png",strTail] inBundle:self.bundle compatibleWithTraitCollection:nil];
        }else{
            attachImg.image=[UIImage imageNamed:@"ic_download_type_unkonw.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        }
    }
    if(indexPath.row==self.attachmentList.count-1){
        UIView *singleBottomView=[[UIView alloc]init];
        [cell addSubview:singleBottomView];
        [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
    }
    attachLabel.text=str;
    attachLabel.font=FONT_12;
    
    loadLabel.text=@"点击查看";
    loadLabel.textColor=UI_BLUE_COLOR;
    loadLabel.textAlignment=NSTextAlignmentRight;
    loadLabel.font=FONT_12;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *attachDic=[self.attachmentList objectAtIndex:indexPath.row];
    NSString *attachName=[attachDic objectForKey:@"name"];
    NSString *attachId=[attachDic objectForKey:@"id"];
    //NSString *attachRelativePath=[attachDic objectForKey:@"relativePath"];
    NSString *attachPath=[NSString stringWithFormat:@"%@/external/attachment/down?attachmentId=%@",REQUEST_URL,attachId];
    //NSString *attachPath = [NSString stringWithFormat:@"%@/%@", REQUEST_URL, attachRelativePath];
    attachPath = [attachPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [Small openUri:[NSString stringWithFormat:@"app.webkit?url=%@&urltitle=%@", attachPath, [NSString encodeString:attachName]] fromController:self];
    
}
@end

