//
//  UserHomeSettingController.m
//  app.home
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserHomeSettingController.h"
#import "UserAuthViewController.h"
#import <Small/Small.h>
#import "PasswordChangeController.h"
@interface UserHomeSettingController ()

@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet UILabel *nameTextView;

@property (weak, nonatomic) IBOutlet UILabel *departmentTextView;

@property (weak, nonatomic) IBOutlet UILabel *poTextView;
@end

@implementation UserHomeSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(160);
    }];
    self.panelView.layer.cornerRadius=2.0f;
    self.panelView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.panelView.layer.shadowOffset=CGSizeMake(3, 3);
    self.panelView.layer.shadowRadius=2.0f;
    self.panelView.layer.shadowOpacity=0.3;
    
    self.nameTextView.text = [CurrentUser currentUser].userdetails.fullName;
    self.departmentTextView.text = [CurrentUser currentUser].userdetails.departmentName;
    self.poTextView.text=[CurrentUser currentUser].userdetails.position;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.panelView.mas_bottom).mas_equalTo(20);
        make.height.mas_equalTo(250);
    }];
    [self.tableview setFrame:CGRectMake(0, self.panelView.bounds.size.height+20, self.view.bounds.size.width, self.view.bounds.size.height-self.panelView.bounds.size.height-20)];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeSet"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"设置"];
}

#pragma mark-<UITableViewDelegete,UITableViewDatasource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HomeSet"];
    UILabel *label=[[UILabel alloc]init];
    UIImageView *picView=[[UIImageView alloc]init];
    if(indexPath.section==0){
        picView.image=[UIImage imageNamed:@"ic_setting_update.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        label.text=@"在线更新";
    }else if(indexPath.section==1){
        picView.image=[UIImage imageNamed:@"ic_setting_updatepwd.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        label.text=@"修改密码";
    }else if (indexPath.section==2){
        picView.image=[UIImage imageNamed:@"ic_setting_loginout.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        label.text=@"退出";
    }
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:picView];
    //layout
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.left.mas_equalTo(picView.mas_right).mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:15];
    picView.contentMode=UIViewContentModeScaleToFill;
    cell.contentView.backgroundColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==2){
        return 2;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=indexPath.section;
    if(section==0){
        //在线更新
        NSLog(@"1");
    }else if (section==1){
        //改密码
        PasswordChangeController *pc=[[PasswordChangeController alloc]init];
        [self.navigationController pushViewController: pc animated:true];
    }else if (section==2){
        //退出
        [Small setUpWithComplection:^{
            UIViewController *mainController = [Small controllerForUri:@"app.home"];
            [self presentViewController:mainController animated:NO completion:nil];
        }];
    }
    
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}
@end

