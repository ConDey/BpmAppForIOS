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
    //背景图
    UIImageView *picView=[[UIImageView alloc]init];
    picView.image=[UIImage imageNamed:@"app_banner.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    [self.view addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    //信息电话按钮
    UIView *callAndMsg=[[UIView alloc]init];
    [self.view addSubview:callAndMsg];
    [callAndMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(picView.mas_bottom).mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    UIView *msg=[[UIView alloc]init];
     UIView *call=[[UIView alloc]init];
    [callAndMsg addSubview:msg];
    [msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(60);
        make.top.mas_equalTo(10);
    }];
    [callAndMsg addSubview:call];
    [call mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(10);
    }];
    UILabel *la1=[[UILabel alloc]init];
    UILabel *la2=[[UILabel alloc]init];
    [msg addSubview:la1];
    [call addSubview:la2];
    UIImageView *ig1=[[UIImageView alloc]init];
    UIImageView *ig2=[[UIImageView alloc]init];
    [msg addSubview:ig1];
    [call addSubview:ig2];
    [ig1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [ig2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
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
    ig1.image=[UIImage imageNamed:@"ic_contact_way_msg.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    ig2.image=[UIImage imageNamed:@"ic_contact_way_tel.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    ig1.contentMode=UIViewContentModeScaleToFill;
    ig2.contentMode=UIViewContentModeScaleToFill;
    //点击发信息
    UITapGestureRecognizer *tapMeg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMeg:)];
    [msg addGestureRecognizer:tapMeg];
  
    //点击打电话
    UITapGestureRecognizer *tapTel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTel:)];
    [call addGestureRecognizer:tapTel];

    
    
    
    
    
    
    self.grouptableview.dataSource  = self;
    self.grouptableview.delegate=self;
    [self.grouptableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.grouptableview registerNib:[UINib nibWithNibName:@"ContractUserTableViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"ContractUserTableViewCell"];
    
    [self.view addSubview:self.grouptableview];
    [self.grouptableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(callAndMsg.mas_bottom).mas_equalTo(2);
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

- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    
    self.user = [User mj_objectWithKeyValues:result];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 3;
    
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContractUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractUserTableViewCell" forIndexPath:indexPath];
    if (indexPath.section==0){
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
    }else {
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
   
        return 70;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
        return 60;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section==0) {
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

//打电话 发信息
-(void)tapMeg:(UITapGestureRecognizer *)sender{
    NSLog(@"msg");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.user.mobile]]];
}

-(void)tapTel:(UITapGestureRecognizer *)sender{
    UIAlertController *call=[UIAlertController alertControllerWithTitle:@"是否要拨打电话？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"boda");
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.user.mobile]]];
    }];
    [call addAction:cancel];
    [call addAction:sure];
    [self presentViewController:call animated:YES completion:nil];
  
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

