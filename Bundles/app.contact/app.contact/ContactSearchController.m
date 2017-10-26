//
//  ContactSearchController.m
//  app.contact
//
//  Created by feng sun on 2017/10/18.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "ContactSearchController.h"
#import "ContactSearchCell.h"
#import "ContactUserViewController.h"

@interface ContactSearchController ()
@property(nonatomic,retain)NSString *user_id;
@property(nonatomic,retain)NSString *user_fullName;
@property(nonatomic,retain)NSString *user_username;
@property(nonatomic,copy)NSArray *userDetail;
@end

@implementation ContactSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar=[[UISearchBar alloc]init];
    [self.view addSubview:searchBar];
    searchBar.delegate=self;
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    searchBar.barStyle=UISearchBarStyleDefault;
    searchBar.backgroundColor=[UIColor clearColor];
    searchBar.tintColor=[UIColor whiteColor];
    searchBar.showsCancelButton=NO;
    searchBar.placeholder=@"点击输入搜索的内容";
    searchBar.backgroundImage=[UIImage new];
    
   
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBar.mas_bottom).mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.tableview registerNib:[UINib nibWithNibName:@"ContactSearchCell" bundle:self.bundle] forCellReuseIdentifier:@"SearchCell"];
    NSLog(@"%@",searchBar.text);
    //获取数据
   NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:searchBar.text forKey:@"name"];
    [self httpGetRequestWithUrl:HttpProtocolServiceContactUserList params:params progress:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"人员搜索"];
}
-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    NSMutableArray *ud=[[NSMutableArray alloc]init];
    ud=[result objectForKey:@"datas"];
    self.userDetail=[[NSArray alloc]initWithArray:ud];
    [self.tableview reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  [self.userDetail count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    NSMutableDictionary *user=[self.userDetail objectAtIndex:indexPath.row];
    NSString *fullName=[[NSString alloc]init];
    fullName=[user objectForKey:@"fullName"];
    //取名字后2位
    if([fullName length]>2){
       cell.searchImg.image=[UIImage circleImageWithText:[fullName substringFromIndex:[fullName length]-3] size:CGSizeMake(40, 40)];
    }else{
        
        cell.searchImg.image=[UIImage circleImageWithText:fullName size:CGSizeMake(40, 40)];
    }
    
    cell.searchLabel.text=fullName;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"搜索中");
    NSMutableDictionary *user=[self.userDetail objectAtIndex:indexPath.row];
    NSString *userId=[[NSString alloc]init];
    userId=[user objectForKey:@"id"];
    ContactUserViewController *vc = [[ContactUserViewController alloc]initWithNibName:@"ContactUserViewController" bundle:self.bundle];
    vc.userId=userId;
    vc.userName=[user objectForKey:@"fullName"];
    [self.navigationController pushViewController: vc animated:YES];

    
}
//搜索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    if(searchBar.text.length==0)
    {
        [params setObject:@"" forKey:@"name"];
    }else{
        [params setObject:searchText forKey:@"name"];
    }
    [self httpGetRequestWithUrl:HttpProtocolServiceContactUserList params:params progress:nil];
    [self.tableview reloadData];
    [searchBar resignFirstResponder];
    
}




@end
