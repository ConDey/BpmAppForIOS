//
//  ChoosePeopleViewController.m
//  app.webkit
//
//  Created by feng sun on 2017/10/25.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserChooseDataViewController.h"
#import "EAWebController.h"
@interface UserChooseDataViewController()
@property(nonatomic,retain)NSArray *selectData;
@property(nonatomic,retain)NSArray *departments;
@property(nonatomic,retain)NSArray *users;
@property(nonatomic,retain)NSArray *search;
@property(nonatomic,retain)UICollectionView *selectColl;
@property(nonatomic,retain)UICollectionView *selectTitle;//部门选择显示
@property(nonatomic,retain)UILabel *selectLabel;
@property(nonatomic,retain)NSArray *depNum;//部门选择
@property(nonatomic,assign)BOOL isSearch;
@property(nonatomic,retain) UISearchBar *searchBar;
@property(nonatomic,retain)UIBarButtonItem *rightButtonItem;
@end

@implementation UserChooseDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏右按钮
    
    self.rightButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确认选择" style:UIBarButtonItemStylePlain target:self action:@selector(dataSend)];
    self.navigationItem.rightBarButtonItem=self.rightButtonItem;
    self.isSearch=NO;
    
    
    //默认选择项
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
    
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"id",@"全部",@"name",nil];
    self.depNum=[[NSArray alloc]initWithObjects:dic, nil];
    
    
    //部门层次
    UICollectionViewFlowLayout *flowlayout=[[UICollectionViewFlowLayout alloc]init];
    
    flowlayout.itemSize=CGSizeMake(120, 40);
    flowlayout.minimumLineSpacing=1;
    flowlayout.minimumInteritemSpacing=1;
    flowlayout.sectionInset=UIEdgeInsetsMake(0, 10, 0, 0);
    flowlayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.selectTitle=[[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowlayout];
    self.selectTitle.dataSource=self;
    self.selectTitle.delegate=self;
    [self.view addSubview:self.selectTitle];
    [self.selectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    self.selectTitle.backgroundColor=[UIColor whiteColor];
    [self.selectTitle registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    //已选择人数
    self.selectLabel=[[UILabel alloc]init];
    [self.view addSubview:self.selectLabel];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectTitle.mas_bottom).mas_equalTo(1);
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
    self.searchBar=[[UISearchBar alloc]init];
    [selectAndSearch addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo((SCREEN_WIDTH-20)/2);
    }];
    self.searchBar.showsCancelButton=NO;
    self.searchBar.placeholder=@" 点击输入搜索";
    self.searchBar.backgroundImage=[UIImage new];
    self.searchBar.delegate=self;
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
    [self UrlData:@""];
}
//获取通讯录数据
-(void)UrlData:(NSString *)dep{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:dep forKey:@"parentId"];
    [self httpGetRequestWithUrl:HttpProtocolServiceContactDepart params:params progress:YES];
}
//获取搜索数据
-(void)UrlSearch:(NSString *)searchName{
    self.isSearch=YES;
    if(searchName.length!=0){
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:searchName forKey:@"name"];
        [self httpGetRequestWithUrl:HttpProtocolServiceContactUserList params:params progress:nil];
    }
    
}
//解析数据
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    if(self.isSearch){
        // NSLog(@"解析搜索数据");
        NSMutableArray *ud=[[NSMutableArray alloc]init];
        ud=[result objectForKey:@"datas"];
        self.search=[[NSArray alloc]initWithArray:ud];
        
    }else{
        NSArray *childarray = [result objectForKey:@"childs"];
        if (childarray == nil || [childarray count] == 0) {
            self.departments = [[NSArray alloc]init];
        } else {
            self.departments = [[NSArray alloc]initWithArray:childarray];
        }
        
        NSArray *userarray = [result objectForKey:@"users"];
        if (userarray == nil || [userarray count] == 0) {
            self.users = [[NSArray alloc]init];
        }else {
            self.users = [[NSArray alloc]initWithArray:userarray];
        }
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
    tableCell.accessoryType=UITableViewCellAccessoryNone;
    UILabel *titleLabel=[[UILabel alloc]init];
    UIImageView *headImageView=[[UIImageView alloc]init];
    UILabel *numOfDep=[[UILabel alloc]init];
    [tableCell addSubview:titleLabel];
    [tableCell addSubview:headImageView];
    [tableCell addSubview:numOfDep];
    UIView *singleView=[[UIView alloc]init];//分割线
    [tableCell addSubview:singleView];
    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    singleView.backgroundColor=UI_DIVIDER_COLOR;
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
    if(self.isSearch){
        if(self.search.count>0){
            
            NSDictionary *users = [self.search objectAtIndex:indexPath.row];
            NSString *name = [users objectForKey:@"fullName"];
            if([name length]>2){
                headImageView.image = [UIImage circleImageWithText:[name substringFromIndex:[name length]-3] size:CGSizeMake(40,40)];
            }else{
                headImageView.image = [UIImage circleImageWithText:name  size:CGSizeMake(40,40)];
            }
            titleLabel.text = name;
            numOfDep.text=@"";
            for(NSDictionary *data in self.selectData){
                if([data objectForKey:@"id"]==[users objectForKey:@"id"]){
                    tableCell.accessoryType=UITableViewCellAccessoryCheckmark;
                }
            }
            if(indexPath.row==self.search.count-1){
                UIView *singleBottomView=[[UIView alloc]init];
                [tableCell addSubview:singleBottomView];
                [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                }];
                singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
            }
        }
    }else{
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
                if(indexPath.row==self.departments.count-1){
                    UIView *singleBottomView=[[UIView alloc]init];
                    [tableCell addSubview:singleBottomView];
                    [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(0);
                        make.height.mas_equalTo(0.5);
                    }];
                    singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
                }
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
                for(NSDictionary *data in self.selectData){
                    if([data objectForKey:@"id"]==[user objectForKey:@"id"]){
                        tableCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                }
                if(indexPath.row==self.users.count-1){
                    UIView *singleBottomView=[[UIView alloc]init];
                    [tableCell addSubview:singleBottomView];
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
            
            NSDictionary *user =  [self.users objectAtIndex:indexPath.row];
            NSString *name =  [user objectForKey:@"fullName"];
            if ([name length] > 2) {
                headImageView.image = [UIImage circleImageWithText:[name substringFromIndex:[name length]-2] size:CGSizeMake(40,40)];
            } else {
                headImageView.image = [UIImage circleImageWithText:name size:CGSizeMake(40,40)];
            }
            titleLabel.text = name;
            numOfDep.text=@"";
            for(NSDictionary *data in self.selectData){
                if([data objectForKey:@"id"]==[user objectForKey:@"id"]){
                    tableCell.accessoryType=UITableViewCellAccessoryCheckmark;
                }
            }
            if(indexPath.row==self.users.count-1){
                UIView *singleBottomView=[[UIView alloc]init];
                [tableCell addSubview:singleBottomView];
                [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                }];
                singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
            }
        }
    }
    return tableCell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num=0;
    if(self.isSearch){
        return 1;
    }else{
        if(self.departments.count>0&&self.departments!=nil){
            num++;
        }
        if(self.users.count>0&&self.users!=nil){
            num++;
        }
    }
    
    
    return num;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isSearch){
        return  self.search.count;
    }else{
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
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    if(self.isSearch){
        header.frame=CGRectMake(0, 0, 0, 0);
    }else{
        if(section == 0) {
            NSString *title=@"员工列表";
            if (self.departments != nil && [self.departments count] > 0) {
                title = @"部门列表";
            } else {
                title = @"员工列表";
            }
            UILabel *la=[[UILabel alloc]init];
            [header addSubview:la];
            [la mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.left.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
            la.text=title;
            la.font=FONT_14;
            la.textColor=FONT_GRAY_COLOR;
            header.frame = CGRectMake(0, 0, self.grouptableview.bounds.size.width, 50);
            
        }
        else {
            UILabel *la=[[UILabel alloc]init];
            [header addSubview:la];
            la.text=@"员工列表";
            [la mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.left.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
            la.font=FONT_14;
            la.textColor=FONT_GRAY_COLOR;
            header.frame = CGRectMake(0, 0, self.grouptableview.bounds.size.width, 50);
            
        }
    }
    
    return header;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.isSearch){
        return 0.01;
    }else{
        return 50;
    }
}
//点击通讯录
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSearch) {
        UITableViewCell *tableCell=[self.grouptableview cellForRowAtIndexPath:indexPath];
        
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.selectData];
        BOOL isHas=NO;
        NSDictionary *dic=[self.search objectAtIndex:indexPath.row];
        for(NSDictionary *data in self.selectData){
            if([data objectForKey:@"id" ]==[dic objectForKey:@"id" ]){
                [temp removeObject:data];
                isHas=YES;
            }
        }
        
        if(isHas==NO){
            if(self.selectData.count<5){
                tableCell.accessoryType=UITableViewCellAccessoryCheckmark;
                NSMutableArray *temp1=[[NSMutableArray alloc]initWithArray:self.selectData];
                NSMutableDictionary *addDic=[[NSMutableDictionary alloc]init];
                [addDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
                [addDic setObject:[dic objectForKey:@"username"] forKey:@"userName"];
                [addDic setObject:[dic objectForKey:@"fullName"] forKey:@"fullName"];
                [addDic setObject:@"search" forKey:@"type"];
                self.selectData=[[NSArray alloc]initWithArray:[temp1 arrayByAddingObject:addDic]];
            }
        }else{
            tableCell.accessoryType=UITableViewCellAccessoryNone;
            self.selectData=[[NSArray alloc]initWithArray:temp];
        }
        [self.selectColl reloadData];
    }
    else{
        
        if(indexPath.section==0){
            //部门选择标题
            if(self.departments.count>0&&self.departments!=nil){
                NSDictionary *deparment = [self.departments objectAtIndex:indexPath.row];//一个部门的信息
                //增加头部标题信息
                NSString *name = [deparment objectForKey:@"name"];
                NSMutableDictionary *dic=[self.departments objectAtIndex:indexPath.row];
                NSString *dep=[dic objectForKey:@"id"];
                NSDictionary *addDic=[[NSDictionary alloc]initWithObjectsAndKeys:dep,@"id",name,@"name",nil];
                NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.depNum];
                NSArray *temp2=[temp arrayByAddingObject:addDic];
                self.depNum=[[NSArray alloc]initWithArray:temp2];
                [self.selectTitle reloadData];
                //刷新tableview
                [self UrlData:dep];
                [self.grouptableview reloadData];
            }else{
                //选择的人员
                
                UITableViewCell *tableCell=[self.grouptableview cellForRowAtIndexPath:indexPath];
                
                NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.selectData];
                BOOL isHas=NO;
                NSDictionary *dic=[self.users objectAtIndex:indexPath.row];
                for(NSDictionary *data in self.selectData){
                    if([data objectForKey:@"id" ]==[dic objectForKey:@"id" ]){
                        [temp removeObject:data];
                        isHas=YES;
                    }
                }
                if(isHas==NO){
                    if(self.selectData.count<5){
                        NSMutableDictionary *addDic=[[NSMutableDictionary alloc]init];
                        [addDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
                        [addDic setObject:[dic objectForKey:@"username"] forKey:@"userName"];
                        [addDic setObject:[dic objectForKey:@"fullName"] forKey:@"fullName"];
                        [addDic setObject:@"contact" forKey:@"type"];
                        tableCell.accessoryType=UITableViewCellAccessoryCheckmark;
                        NSMutableArray *temp1=[[NSMutableArray alloc]initWithArray:self.selectData];
                        
                        self.selectData=[[NSArray alloc]initWithArray:[temp1 arrayByAddingObject:addDic]];
                    }
                }else{
                    tableCell.accessoryType=UITableViewCellAccessoryNone;
                    self.selectData=[[NSArray alloc]initWithArray:temp];
                }
                [self.selectColl reloadData];
            }
            
        }else{
            
            UITableViewCell *tableCell=[self.grouptableview cellForRowAtIndexPath:indexPath];
            NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.selectData];
            BOOL isHas=NO;
            NSDictionary *dic=[self.users objectAtIndex:indexPath.row];
            for(NSDictionary *data in self.selectData){
                if([data objectForKey:@"id" ]==[dic objectForKey:@"id" ]){
                    [temp removeObject:data];
                    isHas=YES;
                }
            }
            if(isHas==NO){
                if(self.selectData.count<5){
                    NSMutableDictionary *addDic=[[NSMutableDictionary alloc]init];
                    [addDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
                    [addDic setObject:[dic objectForKey:@"username"] forKey:@"userName"];
                    [addDic setObject:[dic objectForKey:@"fullName"] forKey:@"fullName"];
                    [addDic setObject:@"contact" forKey:@"type"];
                    tableCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    NSMutableArray *temp1=[[NSMutableArray alloc]initWithArray:self.selectData];
                    
                    self.selectData=[[NSArray alloc]initWithArray:[temp1 arrayByAddingObject:addDic]];
                }
            }else{
                tableCell.accessoryType=UITableViewCellAccessoryNone;
                self.selectData=[[NSArray alloc]initWithArray:temp];
            }
            [self.selectColl reloadData];
        }
        //部门还是具体人员
    }
    //搜索还是通讯录
    self.selectLabel.text=[NSString stringWithFormat:@"   已选择人员(%lu/5)",self.selectData.count];
    
    
    
}

#pragma mark-<UICollectionViewDatasource,UICollectionViewDelegate>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *collectionCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell"forIndexPath:indexPath];
    if(collectionCell!=nil){
        for(UIView *view in [collectionCell subviews]){
            [view removeFromSuperview];
        }
    }
    if(collectionView==self.selectColl){
        
        UIImageView *selectImg=[[UIImageView alloc]init];
        //UILabel *laX=[[UILabel alloc]init];
        
        UIImageView *cancelImg=[[UIImageView alloc]init];
        cancelImg.image=[UIImage imageNamed:@"ic_delete_hasselect.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        [selectImg addSubview:cancelImg];
        [cancelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        //laX.text=@"X";
        [collectionCell addSubview:selectImg];
        CGFloat width=(self.selectColl.frame.size.width-10)/5;
        [selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, width));
            make.centerY.mas_equalTo(collectionCell.mas_centerY);
            make.left.mas_equalTo(2);
        }];
        NSDictionary *user =  [self.selectData objectAtIndex:indexPath.row];
        NSString *name = [user objectForKey:@"fullName"];
        NSString *type=[user objectForKey:@"type"];
        if ([name length] > 2) {
            if([type isEqualToString:@"search"]){
                name=[name substringFromIndex:[name length]-3];
            }else{
                name=[name substringFromIndex:[name length]-2];
            }
            
        }
        selectImg.image = [UIImage circleImageWithText:name size:CGSizeMake(40,40)];
    }
    if(collectionView==self.selectTitle){
        if(indexPath.row<self.depNum.count){
            UILabel *totalLabel=[[UILabel alloc]init];
            totalLabel.textColor=FONT_GRAY_COLOR;
            totalLabel.font=FONT_12;
            [collectionCell addSubview:totalLabel];
            [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(100);
            }];
            NSDictionary *dic=[self.depNum objectAtIndex:indexPath.row];
            totalLabel.text=[dic objectForKey:@"name"];
            totalLabel.textAlignment=NSTextAlignmentCenter;
            if(indexPath.row<self.depNum.count-1){
                totalLabel.textColor=UI_BLUE_COLOR;
            }else{
                totalLabel.textColor=UI_GRAY_COLOR;
            }
            UIImage *rightArrow=[UIImage imageNamed:@"ic_right_arrow.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
            UIImageView *arrow=[[UIImageView alloc]initWithImage:rightArrow];
            [collectionCell addSubview:arrow];
            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(collectionCell.mas_centerY);
                make.left.mas_equalTo(totalLabel.mas_right);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
        }
    }
    
    return collectionCell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger num=0;
    if(collectionView==self.selectColl){
        num=[self.selectData count];
    }
    if(collectionView==self.selectTitle){
        num=[self.depNum count];
    }
    return num;
}
//点击搜索
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==self.selectColl){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.selectData];
        [temp removeObjectAtIndex:indexPath.row];
        self.selectData=[[NSArray alloc]initWithArray:temp];
        [self.selectColl reloadData];
    }
    if(collectionView==self.selectTitle){
        self.isSearch=NO;
        NSDictionary *dic=[self.depNum objectAtIndex:indexPath.row];
        NSString *depID=[dic objectForKey:@"id"];
        [self UrlData:depID];
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.depNum];
        for(NSInteger i=self.depNum.count-1;i>indexPath.row;i--){
            [temp removeObjectAtIndex:i];
        }
        self.depNum=[[NSArray alloc]initWithArray:temp];
        [self.selectTitle reloadData];
    }
    self.selectLabel.text=[NSString stringWithFormat:@"   已选择人员(%lu/5)",self.selectData.count];
}
//搜索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length!=0){
        [self UrlSearch:searchText];
    }else{
        self.isSearch=NO;
        [self UrlData:@""];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"id",@"全部",@"name",nil];
        self.depNum=[[NSArray alloc]initWithObjects:dic, nil];
        [self.selectTitle reloadData];
    }
    
}



-(void)dataSend{
    NSMutableArray *data=[[NSMutableArray alloc]init
                          ];
    NSDictionary *dic1=[[NSDictionary alloc]init];
    for(NSDictionary *dic in self.selectData){
        NSString *name=[dic objectForKey:@"fullName"];
        NSString *userId=[dic objectForKey:@"id"];
        NSDictionary *userDic=[[NSDictionary alloc]initWithObjectsAndKeys:name,@"name",userId,@"id",nil];
        [data addObject:userDic];
    }
    dic1=[[NSDictionary alloc]initWithObjectsAndKeys:data,@"users",nil];
    if(self.userDelegate!=nil){
        [self.userDelegate sendSelectData:dic1];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end


