//
//  ContactUserViewController.m
//  app.contact
//
//  Created by ConDey on 2017/7/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "ContactUserViewController.h"
#import "ContractUserTableViewCell.h"

@interface ContactUserViewController ()


@end

@implementation ContactUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleOfNav:self.user.fullName];
    //没图
    UIImageView *picView=[[UIImageView alloc]init];
    picView.backgroundColor=[UIColor redColor];
    [self.view addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    self.grouptableview.dataSource  = self;
    self.grouptableview.delegate=self;
    [self.grouptableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.grouptableview registerNib:[UINib nibWithNibName:@"ContractUserTableViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"ContractUserTableViewCell"];
    
    [self.view addSubview:self.grouptableview];
    [self.grouptableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(150, 0, 0, 0));
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if(self.userId==nil){
        [params setObject:self.user.id forKey:@"userId"];
        
    }else{
        [params setObject:self.userId forKey:@"userId"];
        
    }
    
    // 更新数据
    [self httpGetRequestWithUrl:HttpProtocolServiceContactUserDetail params:params progress:YES];
}

- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(NSString *)name {
    
    self.user = [User mj_objectWithKeyValues:result];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 1;
    }else if (section==1){
        return 3;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContractUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractUserTableViewCell" forIndexPath:indexPath];
    if(indexPath.section==0){
        cell.leftImageView.image =  [[UIImage alloc]init];
        cell.titleLabel.text = @"";
        cell.detailLabel.text = @"";
    }else if (indexPath.section==1){
        if (indexPath.row == 0) {
            cell.leftImageView.image =  [UIImage imageNamed:@"ic_contact_user" inBundle:self.bundle compatibleWithTraitCollection:nil];
            cell.titleLabel.text = @"人员姓名";
            cell.detailLabel.text = self.user.fullName;
        }
        
        else if(indexPath.row == 1) {
            cell.leftImageView.image =  [UIImage imageNamed:@"ic_contact_group" inBundle:self.bundle compatibleWithTraitCollection:nil];
            cell.titleLabel.text = @"所属部门";
            cell.detailLabel.text = self.user.departmentName;
        }
        
        else if(indexPath.row == 2) {
            cell.leftImageView.image =  [UIImage imageNamed:@"ic_contact_position" inBundle:self.bundle compatibleWithTraitCollection:nil];
            cell.titleLabel.text = @"工作职位";
            cell.detailLabel.text = self.user.position;
        }
    }else if (indexPath.section==2){
        if(indexPath.row == 0) {
            cell.leftImageView.image =  [UIImage imageNamed:@"ic_contact_tel" inBundle:self.bundle compatibleWithTraitCollection:nil];
            cell.titleLabel.text = @"联系方式";
            cell.detailLabel.text = self.user.mobile;
        }
        
        else if(indexPath.row ==1) {
            cell.leftImageView.image =  [UIImage imageNamed:@"ic_contact_email" inBundle:self.bundle compatibleWithTraitCollection:nil];
            cell.titleLabel.text = @"电子邮件";
            cell.detailLabel.text = self.user.email;
        }
    }
    return cell;
}

// 点击跳转事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==2){
        if (indexPath.row == 0 && ![NSString isStringBlank:self.user.mobile]) {
            // 拨打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.user.mobile]]];
        }
    }
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        return 0.01;
    }else{
        return 70;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 90;
    }else{
        return 60;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section==0){
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.grouptableview.bounds.size.width, 70)];
        headerView.backgroundColor=LIGHT_GRAY_COLOR;
        UILabel *la1=[[UILabel alloc]init];
        UILabel *la2=[[UILabel alloc]init];
        [headerView addSubview:la1];
        [headerView addSubview:la2];
        UIImageView *ig1=[[UIImageView alloc]init];
        UIImageView *ig2=[[UIImageView alloc]init];
        [headerView addSubview:ig1];
        [headerView addSubview:ig2];
        [ig1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(60);
            make.top.mas_equalTo(10);
        }];
        [ig2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.mas_equalTo(-60);
            make.top.mas_equalTo(10);
        }];
        [la1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ig1.mas_centerX);
            make.top.mas_equalTo(ig1.mas_bottom).mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(60);
        }];
        [la2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ig2.mas_centerX);
            make.top.mas_equalTo(ig2.mas_bottom).mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(60);
        }];
        la1.text=@"发信息";
        la2.text=@"打电话";
        la1.textAlignment=NSTextAlignmentCenter;
        la2.textAlignment=NSTextAlignmentCenter;
        ig1.image=[UIImage imageNamed:@"ic_contact_user.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        ig2.image=[UIImage imageNamed:@"ic_contact_tel.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        ig1.contentMode=UIViewContentModeScaleToFill;
        ig2.contentMode=UIViewContentModeScaleToFill;
        return headerView;
        
    }
    else if(section == 1) {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.grouptableview.bounds.size.width, 60)];
        UILabel *Msg1=[[UILabel alloc]init];
        [headerView addSubview:Msg1];
        [Msg1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 30));
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(0);
        }];
        Msg1.text=@"基本信息";
        Msg1.textColor=FONT_GRAY_COLOR;
        Msg1.font=[UIFont systemFontOfSize:15];
        return headerView;
    }
    else {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.grouptableview.bounds.size.width, 60)];
        UILabel *Msg2=[[UILabel alloc]init];
        [headerView addSubview:Msg2];
        [Msg2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 30));
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(0);
        }];
        Msg2.text=@"联系信息";
        Msg2.textColor=FONT_GRAY_COLOR;
        Msg2.font=[UIFont systemFontOfSize:15];
        return headerView;
    }
}


#pragma mark - Table view setting

// 自定义TableViewCell分割线, 清除前面15PX的空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end

