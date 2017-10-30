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
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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
    UILabel *attachLabel=[[UILabel alloc]init];
    [cell addSubview:attachLabel];
    [attachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
    NSDictionary *attachDic =[self.attachmentList objectAtIndex:indexPath.row];
     attachLabel.text=[attachDic objectForKey:@"name"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *attachDic=[self.attachmentList objectAtIndex:indexPath.row];
    NSString *attachId=[attachDic objectForKey:@"id"];
    
  
}
@end
