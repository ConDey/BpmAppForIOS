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
    // Do any additional setup after loading the view.
    [self setTitleOfNav:self.user.fullName];
    
    CGFloat height =  self.view.bounds.size.height - STATUS_BAR_HEIGHT - NAV_HEIGHT;
    self.tableview.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    self.tableview.delegate    = self;
    self.tableview.dataSource  = self;
    
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableview registerNib:[UINib nibWithNibName:@"ContractUserTableViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"ContractUserTableViewCell"];
    
    [self.view addSubview:self.tableview];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContractUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractUserTableViewCell" forIndexPath:indexPath];
    
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
    
    else if(indexPath.row == 3) {
        cell.leftImageView.image =  [UIImage imageNamed:@"ic_contact_tel" inBundle:self.bundle compatibleWithTraitCollection:nil];
        cell.titleLabel.text = @"联系方式";
        cell.detailLabel.text = self.user.mobile;
    }
    
    else if(indexPath.row == 4) {
        cell.leftImageView.image =  [UIImage imageNamed:@"ic_contact_email" inBundle:self.bundle compatibleWithTraitCollection:nil];
        cell.titleLabel.text = @"电子邮件";
        cell.detailLabel.text = self.user.email;
    }
    
    return cell;
}

// 点击跳转事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3 && ![NSString isStringBlank:self.user.mobile]) {
        // 拨打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.user.mobile]]];
    }
    
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
