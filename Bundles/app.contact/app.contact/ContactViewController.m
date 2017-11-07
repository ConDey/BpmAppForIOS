


//  ContactViewController.m
//  app.contact
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.

#import "ContactViewController.h"
#import "ContactUserViewController.h"
#import "ContactSearchController.h"


#import "ContractTableViewCell.h"
#import "ContractTableViewHeader.h"

#import "Deparment.h"
#import "User.h"

@interface ContactViewController ()

@property (nonatomic,retain)  NSString *dep_id;
@property (nonatomic,retain)  NSString *dep_name;

@property (nonatomic,retain) NSArray *departments;
@property (nonatomic,retain) NSArray *users;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //通讯录信息
    CGFloat height =  self.view.bounds.size.height -STATUS_BAR_HEIGHT - NAV_HEIGHT;
    
    if(self.tabBarController != nil) {
        height = height - TAB_HEIGHT;
    }
    
    self.grouptableview.delegate    = self;
    self.grouptableview.dataSource  = self;
    
    [self.grouptableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.grouptableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ContractTableViewCell"];
    [self.view addSubview:self.grouptableview];
    [self.grouptableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    if ([NSString isStringBlank:self.dep]) {
        [params setObject:@"" forKey:@"parentId"];
    } else {
        [params setObject:self.dep  forKey:@"parentId"];
    }
    
    [self httpGetRequestWithUrl:HttpProtocolServiceContactDepart params:params progress:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if([NSString isStringBlank:self.dep]) {
        [self setTitleOfNav:@"通讯录"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    
    self.dep_id = [result objectForKey:@"id"];
    self.dep_name = [result objectForKey:@"name"];
    
    if(![NSString isStringBlank:self.dep]) {
        [self setTitleOfNav:self.dep_name];
    } else {
        [self setTitleOfNav:@"通讯录"];
    }
    
    NSArray *childarray = [result objectForKey:@"childs"];
    if (childarray == nil || [childarray count] == 0) {
        self.departments = [[NSArray alloc]init];
    } else {
        self.departments = [Deparment mj_objectArrayWithKeyValuesArray:childarray];
    }
    
    NSArray *userarray = [result objectForKey:@"users"];
    if (userarray == nil || [userarray count] == 0) {
        self.users = [[NSArray alloc]init];
    } else {
        self.users = [User mj_objectArrayWithKeyValuesArray:userarray];
    }
    [self.grouptableview reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int num = 1;
    if (self.departments != nil && [self.departments count] > 0) {
        num++;
    }
    if (self.users != nil && [self.users count] > 0) {
        num++;
    }
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 2;
    }else if(section==1){
        if (self.departments != nil && [self.departments count] > 0) {
            return [self.departments count];
        } else {
            return [self.users count];
        }
    }
    else {
        return [self.users count];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section==0){
        ContractTableViewHeader *header = [ContractTableViewHeader initWithTitle:@" "];
        header.frame = CGRectMake(0, 0, self.grouptableview.bounds.size.width,20);
        return header;
    }
    else if(section == 1) {
        NSString *title=@"员工列表";
        if (self.departments != nil && [self.departments count] > 0) {
            title = @"部门列表";
        } else {
            title = @"员工列表";
        }
        ContractTableViewHeader *header = [ContractTableViewHeader initWithTitle:title];
        header.frame = CGRectMake(0, 0, self.grouptableview.bounds.size.width, 50);
        return header;
    }
    else {
        ContractTableViewHeader *header = [ContractTableViewHeader initWithTitle:@"员工列表"];
        header.frame = CGRectMake(0, 0, self.grouptableview.bounds.size.width, 50);
        return header;
    }
    
    
    
}
//数据显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContractTableViewCell" forIndexPath:indexPath];
    if(cell!=nil){
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
            
        }
        UIView *singleView=[[UIView alloc]init];//分割线
        [cell addSubview:singleView];
        [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        singleView.backgroundColor=UI_DIVIDER_COLOR;
        UILabel *titleLabel=[[UILabel alloc]init];
        UIImageView *headImageView=[[UIImageView alloc]init];
        [cell addSubview:titleLabel];
        [cell addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 21));
            make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        if(indexPath.section==0){
            if(self.numOfHideSection==1){
                if(indexPath.row==0){
                    headImageView.image = [[UIImage alloc]init];
                    titleLabel.text = @"";
                    
                    
                }
                if(indexPath.row==1){
                    headImageView.image = [[UIImage alloc]init];
                    titleLabel.text = @"";
                    
                }
            }else{
                if(indexPath.row==0){
                    headImageView.image = [UIImage imageNamed:@"ic_contact_search.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
                    titleLabel.text = @"人员搜索";
                    
                    
                }
                if(indexPath.row==1){
                    headImageView.image = [UIImage imageNamed:@"ic_contact_local.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
                    titleLabel.text = @"手机通讯录";
                    UIView *singleBottomView=[[UIView alloc]init];
                    [cell addSubview:singleBottomView];
                    [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(0);
                        make.height.mas_equalTo(0.5);
                    }];
                    singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
                    
                }
                
            }
        }else if(indexPath.section == 1) {
            if (self.departments != nil && [self.departments count] > 0) {
                UILabel  *numOfDep=[[UILabel alloc]init];
                [cell addSubview:numOfDep];
                [numOfDep mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30);
                    make.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(40);
                    make.top.mas_equalTo(10);
                }];
                numOfDep.textColor=FONT_GRAY_COLOR;
                numOfDep.font=FONT_14;
                
                cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
                // 显示部门
                Deparment *deparment = [self.departments objectAtIndex:indexPath.row];//一个部门的信息
                NSString *name = deparment.name;
                headImageView.image = [UIImage circleImageWithText:[name substringToIndex:1] size:CGSizeMake(40,40)];
                titleLabel.text = name;
                NSString *num=[NSString stringWithFormat:@"%ld人",deparment.userCount];//一个部门下的人员信息
                numOfDep.text=num;
                if(indexPath.row==self.departments.count-1){
                    UIView *singleBottomView=[[UIView alloc]init];
                    [cell addSubview:singleBottomView];
                    [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(0);
                        make.height.mas_equalTo(0.5);
                    }];
                    singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
                }
            } else {
                // 显示员工
                
                User *user =  [self.users objectAtIndex:indexPath.row];
                NSString *name = user.fullName;
                
                if ([name length] > 2) {
                    headImageView.image = [UIImage circleImageWithText:[name substringFromIndex:[name length]-2] size:CGSizeMake(40,40)];
                } else {
                    headImageView.image = [UIImage circleImageWithText:name size:CGSizeMake(40,40)];
                }
                titleLabel.text = name;
                NSInteger tag=indexPath.row+3;
                [self addTel:cell callTag:tag];
                [self addMsg:cell msgTag:tag];
                if(indexPath.row==self.users.count-1){
                    UIView *singleBottomView=[[UIView alloc]init];
                    [cell addSubview:singleBottomView];
                    [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(0);
                        make.height.mas_equalTo(0.5);
                    }];
                    singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
                }
            }
        }
        else {
            // 显示员工
            User *user =  [self.users objectAtIndex:indexPath.row];
            NSString *name = user.fullName;
            if ([name length] > 2) {
                headImageView.image = [UIImage circleImageWithText:[name substringFromIndex:[name length]-2] size:CGSizeMake(40,40)];
            } else {
                headImageView.image = [UIImage circleImageWithText:name size:CGSizeMake(40,40)];
            }
            titleLabel.text = name;
            NSInteger tag=indexPath.row+3;
            [self addTel:cell callTag:tag];
            [self addMsg:cell msgTag:tag];
            if(indexPath.row==self.users.count-1){
                UIView *singleBottomView=[[UIView alloc]init];
                [cell addSubview:singleBottomView];
                [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                }];
                singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
            }
        }
    }
    return  cell;
    
}

// 点击跳转事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            //搜索
            ContactSearchController *sa=[[ContactSearchController alloc]init];
            [self.navigationController pushViewController:sa animated:YES];
        }
        if(indexPath.row==1){
            //本地通讯录
            CNContactPickerViewController *cpicker=[[CNContactPickerViewController alloc]init];
            cpicker.delegate=self;
            [self presentViewController:cpicker animated:YES completion:nil];
            
        }
        
    }else if(indexPath.section == 1) {
        if (self.departments != nil && [self.departments count] > 0) {
            
            Deparment *dp = [self.departments objectAtIndex:indexPath.row];
            
            if(dp.childCount == 0 && dp.userCount == 0) {
                [SVProgressHUD showErrorWithStatus:@"此部门下没有数据"];
            } else {
                ContactViewController *vc = [[ContactViewController alloc] init];
                vc.dep = dp.id;
                vc.numOfHideSection=1;
                [self.navigationController pushViewController: vc animated:true];
            }
            
        } else {
            User *user = [self.users objectAtIndex:indexPath.row];
            ContactUserViewController *vc = [[ContactUserViewController alloc]initWithNibName:@"ContactUserViewController" bundle:self.bundle];
            vc.user = user;
            [self.navigationController pushViewController: vc animated:true];
        }
    }
    else {
        
        User *user = [self.users objectAtIndex:indexPath.row];
        
        ContactUserViewController *vc = [[ContactUserViewController alloc]initWithNibName:@"ContactUserViewController" bundle:self.bundle];
        vc.user = user;
        
        [self.navigationController pushViewController: vc animated:true];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//单元格大小和头尾大小
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.numOfHideSection==1){
        if(indexPath.section==0){
            return 0.01;
        }else{
            return 60;
        }
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0.01;
    }else{
        return 50;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



//电话信息按钮
//电话
-(void)addTel:(UIView *)cell callTag:(NSInteger)tag{
    UIButton *call=[[UIButton alloc]init];
    [cell addSubview:call];
    [call mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    call.tag=tag;
    UIImage *ig2=[[UIImage alloc]init];
    ig2=[UIImage imageNamed:@"ic_contact_way_tel.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    [call setBackgroundImage:ig2 forState:UIControlStateNormal];
    [call addTarget:self action:@selector(tapTel:) forControlEvents:UIControlEventTouchUpInside];
}

//信息
-(void)addMsg:(UIView *)cell msgTag:(NSInteger)tag{
    
    UIButton *msg=[[UIButton alloc]init];
    [cell addSubview:msg];
    UIImage *ig1=[[UIImage alloc]init];
    [msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(-60);
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    msg.tag=tag;
    ig1=[UIImage imageNamed:@"ic_contact_way_msg.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    [msg setBackgroundImage:ig1 forState:UIControlStateNormal];
    [msg addTarget:self action:@selector(tapMsg:) forControlEvents:UIControlEventTouchUpInside];
}




//按钮点击事件
-(void)tapTel:(UIButton *)sender{
    NSLog(@"tel");
    NSInteger tag=sender.tag-3;
    User *user=[self.users objectAtIndex:tag];
    NSString *mobile=user.mobile;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:mobile]]];
}

-(void)tapMsg:(UIButton *)sender{
    NSLog(@"msg");
    NSInteger tag=sender.tag-3;
    User *user=[self.users objectAtIndex:tag];
    NSString *mobile=user.mobile;
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",mobile]]];
}



@end



