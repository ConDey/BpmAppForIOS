//
//  ChoosePeopleViewController.m
//  app.webkit
//
//  Created by feng sun on 2017/10/25.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "ChoosePeopleViewController.h"

@interface ChoosePeopleViewController ()
@property(nonatomic,retain)NSArray *selectData;
@property (nonatomic,retain) NSString *dep_id;
@property (nonatomic,retain) NSString *dep_name;
@property(nonatomic,retain)NSArray *departments;
@property(nonatomic,retain)NSArray *users;
@property(nonatomic,retain)UICollectionView *selectColl;
@property(nonatomic,retain)UILabel *selectLabel;
@end

@implementation ChoosePeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectData=@[
    @{@"id":@"zhangsan",
      @"username":@"zhangsan",
      @"fullName":@"张三"
                    },
    @{  @"id":@"lisi",
        @"username":@"lisi",
        @"fullName":@"李四"
                    }
                      ];
    //部门层次
    UIView *dep=[[UIView alloc]init];
    [self.view addSubview:dep];
    [dep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    UILabel *totalLabel=[[UILabel alloc]init];
    totalLabel.text=@"   全部";
    totalLabel.textColor=FONT_GRAY_COLOR;
    totalLabel.font=FONT_18;
    [dep addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //已选择人数
    self.selectLabel=[[UILabel alloc]init];
    [self.view addSubview:self.selectLabel];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dep.mas_bottom).mas_equalTo(1);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    self.selectLabel.textColor=FONT_GRAY_COLOR;
    self.selectLabel.font=FONT_14;
    self.selectLabel.text=[NSString stringWithFormat:@"   已选择人员(2/5)"];
    //选择搜索
    UIView *selectAndSearch=[[UIView alloc]init];
    selectAndSearch.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:selectAndSearch];
    [selectAndSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectLabel.mas_bottom).mas_equalTo(1);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(50);
    }];
    //左下右边框
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = [UIColor grayColor].CGColor;
    bottomLayer.frame = CGRectMake(0, selectAndSearch.frame.size.height+50, SCREEN_WIDTH-20, 1.0);
    [selectAndSearch.layer addSublayer:bottomLayer];
    CALayer *leftLayer = [CALayer layer];
    leftLayer.backgroundColor = [UIColor grayColor].CGColor;
    leftLayer.frame = CGRectMake(0, selectAndSearch.frame.size.height+30, 1.0, 20);
    [selectAndSearch.layer addSublayer:leftLayer];
    CALayer *rightLayer = [CALayer layer];
    rightLayer.backgroundColor = [UIColor grayColor].CGColor;
    rightLayer.frame = CGRectMake(selectAndSearch.frame.size.width+SCREEN_WIDTH-20, selectAndSearch.frame.size.height+31, 1.0, 20);
    [selectAndSearch.layer addSublayer:rightLayer];
        //选择项
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
     CGFloat width=((SCREEN_WIDTH-20)/2-10)/5;
    layout.itemSize=CGSizeMake(width, width);
    layout.minimumLineSpacing=1;
    layout.minimumInteritemSpacing=1;
    layout.sectionInset=UIEdgeInsetsMake((50-width)/2, 2, (50-width)/2, 0);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.selectColl=[[UICollectionView alloc]initWithFrame:selectAndSearch.frame collectionViewLayout:layout];
    self.selectColl.dataSource=self;
    self.selectColl.delegate=self;
    [selectAndSearch addSubview:self.selectColl];
    [self.selectColl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-20)/2);
    }];
    self.selectColl.backgroundColor=[UIColor whiteColor];
    [self.selectColl registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
        //搜索项
    UISearchBar *searchBar=[[UISearchBar alloc]init];
    [selectAndSearch addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-20)/2);
    }];
    searchBar.showsCancelButton=NO;
    searchBar.placeholder=@" 点击输入搜索";
    searchBar.backgroundImage=[UIImage new];
    //部门人员列表
    [self.view addSubview:self.grouptableview];
    [self.grouptableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selectAndSearch.mas_bottom).mas_equalTo(1);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.grouptableview.delegate=self;
    self.grouptableview.dataSource=self;
    self.grouptableview.backgroundColor=LIGHT_GRAY_COLOR;
    [self.grouptableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    self.grouptableview.backgroundColor=[UIColor clearColor];
    //获取数据
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    if ([NSString isStringBlank:self.dep]) {
        [params setObject:@"" forKey:@"parentId"];
    } else {
        [params setObject:self.dep  forKey:@"parentId"];
    }
    
    [self httpGetRequestWithUrl:HttpProtocolServiceContactDepart params:params progress:YES];
    
    
    
}

//解析数据
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    
    self.dep_id = [result objectForKey:@"id"];
    self.dep_name = [result objectForKey:@"name"];
    NSArray *childarray = [result objectForKey:@"childs"];
    if (childarray == nil || [childarray count] == 0) {
        self.departments = [[NSArray alloc]init];
    } else {
        self.departments = [[NSArray alloc]initWithArray:childarray];
    }
    
    NSArray *userarray = [result objectForKey:@"users"];
    if (userarray == nil || [userarray count] == 0) {
        self.users = [[NSArray alloc]init];
    } else {
        self.users = [[NSArray alloc]initWithArray:userarray];
    }
    [self.grouptableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setTitleOfNav:@"人员选择"];
}


#pragma mark-<UITableViewDatasource,UITableViewDelegate>
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell=[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if(tableCell!=nil){
        for (UIView *view in [tableCell subviews]) {
        [view removeFromSuperview];
      }
    }
    UILabel *titleLabel=[[UILabel alloc]init];
    UIImageView *headImageView=[[UIImageView alloc]init];
    UILabel *numOfDep=[[UILabel alloc]init];
    [tableCell addSubview:titleLabel];
    [tableCell addSubview:headImageView];
    [tableCell addSubview:numOfDep];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(tableCell.mas_centerY);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 21));
        make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(tableCell.mas_centerY);
    }];
    [numOfDep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(tableCell.mas_centerY);
    }];
    
    if(indexPath.section == 0) {
        if (self.departments != nil && [self.departments count] > 0) {
            tableCell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            // 显示部门
            NSDictionary *deparment = [self.departments objectAtIndex:indexPath.row];//一个部门的信息
            NSString *name = [deparment objectForKey:@"name"];
            headImageView.image = [UIImage circleImageWithText:[name substringToIndex:1] size:CGSizeMake(40,40)];
            titleLabel.text = name;
            NSString *num=[NSString stringWithFormat:@"%@人",[deparment objectForKey:@"userCount"]];//一个部门下的人员信息
            numOfDep.text=num;
        } else {
            // 显示员工
            
            NSDictionary *user =  [self.users objectAtIndex:indexPath.row];
            NSString *name = [user objectForKey:@"fullName"];
            
            if ([name length] > 2) {
               headImageView.image = [UIImage circleImageWithText:[name substringFromIndex:[name length]-2] size:CGSizeMake(40,40)];
            } else {
                headImageView.image = [UIImage circleImageWithText:name size:CGSizeMake(40,40)];
            }
            titleLabel.text = name;
            numOfDep.text=@"";
        }
    }
    else {
        // 显示员工
       NSDictionary *user =  [self.users objectAtIndex:indexPath.row];
        NSString *name =  [user objectForKey:@"fullName"];
        if ([name length] > 2) {
            headImageView.image = [UIImage circleImageWithText:[name substringFromIndex:[name length]-2] size:CGSizeMake(40,40)];
        } else {
            headImageView.image = [UIImage circleImageWithText:name size:CGSizeMake(40,40)];
        }
        titleLabel.text = name;
        numOfDep.text=@"";
    }
    return tableCell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num=0;
    if(self.departments.count>0&&self.departments!=nil){
        num++;
    }
    if(self.users.count>0&&self.users!=nil){
        num++;
    }
    return num;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
    if(self.departments.count>0&&self.departments!=nil){
        return self.departments.count;
    }else{
        
            return self.users.count;
        }
    }else{
        return self.users.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        NSString *title=@"员工列表";
        if (self.departments != nil && [self.departments count] > 0) {
            title = @"部门列表";
        } else {
            title = @"员工列表";
        }
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        UILabel *la=[[UILabel alloc]init];
        [header addSubview:la];
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        la.text=title;
        la.font=FONT_14;
        la.textColor=FONT_GRAY_COLOR;
        header.frame = CGRectMake(0, 0, self.grouptableview.bounds.size.width, 50);
        return header;
    }
    else {
      UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        UILabel *la=[[UILabel alloc]init];
        [header addSubview:la];
        la.text=@"员工列表";
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        la.font=FONT_14;
        la.textColor=FONT_GRAY_COLOR;
        header.frame = CGRectMake(0, 0, self.grouptableview.bounds.size.width, 50);
        return header;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
//点击通讯录
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectData.count<5){
    NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.selectData];
    BOOL isHas=NO;
    if(indexPath.section==0){
        if(self.departments.count>0&&self.departments!=nil){
            ChoosePeopleViewController *cs=[[ChoosePeopleViewController alloc]init];
            NSDictionary *dic=[self.departments objectAtIndex:indexPath.row];
            cs.dep=[dic objectForKey:@"id"];
            [self.navigationController pushViewController:cs animated:YES];
        }else{
            
            NSDictionary *dic=[self.users objectAtIndex:indexPath.row];
            for(NSDictionary *data in self.selectData){
                if(data==dic){
                    [temp removeObject:data];
                    isHas=YES;
            }
            }
            if(isHas==NO){
            NSMutableArray *temp1=[[NSMutableArray alloc]initWithArray:self.selectData];
                self.selectData=[[NSArray alloc]initWithArray:[temp1 arrayByAddingObject:dic]];
            }else{
                self.selectData=[[NSArray alloc]initWithArray:temp];
            }
        }
        
    }else{
        NSDictionary *dic=[self.users objectAtIndex:indexPath.row];
        for(NSDictionary *data in self.selectData){
            if(data==dic){
                [temp removeObject:data];
                isHas=YES;
            }
        }
        if(isHas==NO){
            NSMutableArray *temp1=[[NSMutableArray alloc]initWithArray:self.selectData];
            self.selectData=[[NSArray alloc]initWithArray:[temp1 arrayByAddingObject:dic]];
        }else{
            self.selectData=[[NSArray alloc]initWithArray:temp];
        }
    }
   self.selectLabel.text=[NSString stringWithFormat:@"   已选择人员(%ld/5)",[self.selectData count]];
    [self.selectColl reloadData];
    }
}

#pragma mark-<UICollectionViewDatasource,UICollectionViewDelegate>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *collectionCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell"
   forIndexPath:indexPath];
   // collectionCell.layer.borderWidth=1;
    UIImageView *selectImg=[[UIImageView alloc]init];
    UILabel *laX=[[UILabel alloc]init];
    [selectImg addSubview:laX];
    [laX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    laX.text=@"X";
    [collectionCell addSubview:selectImg];
    CGFloat width=(self.selectColl.frame.size.width-10)/5;
    [selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.centerY.mas_equalTo(collectionCell.mas_centerY);
        make.left.mas_equalTo(2);
    }];
    NSDictionary *user =  [self.selectData objectAtIndex:indexPath.row];
    NSString *name = [user objectForKey:@"fullName"];
    
    if ([name length] > 2) {
        selectImg.image = [UIImage circleImageWithText:[name substringFromIndex:[name length]-2] size:CGSizeMake(40,40)];
    } else {
        selectImg.image = [UIImage circleImageWithText:name size:CGSizeMake(40,40)];
    }
    
    return collectionCell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.selectData count];

}






@end
