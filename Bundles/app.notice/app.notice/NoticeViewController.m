//
//  NoticeViewController.m
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeListViewCell.h"
#import "NoticeDetailViewController.h"


@interface NoticeViewController ()
@property(nonatomic,assign)NSInteger pgNo;
@property(nonatomic,assign)NSInteger cellHeight;
@property(nonatomic,assign)BOOL isUp;
@property(nonatomic,assign)BOOL isDown;
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,assign)NSInteger select;
@property(nonatomic,assign)CGFloat contentY;


@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=LIGHT_GRAY_COLOR;
    self.select=-1;
    self.isUp=NO;
    self.isDown=NO;
    self.isFirst=NO;
    self.cellHeight=90;
  
   
    self.grouptableview.delegate=self;
    self.grouptableview.dataSource=self;
    [self.view addSubview:self.grouptableview];
    [self.grouptableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    self.grouptableview.scrollEnabled=YES;
    [self.grouptableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.grouptableview.backgroundColor=[UIColor whiteColor];
    [self.grouptableview registerNib:[UINib nibWithNibName:@"NoticeListViewCell" bundle:self.bundle]  forCellReuseIdentifier:@"NoticeList"];
    self.grouptableview.backgroundColor=LIGHT_GRAY_COLOR;
    //下拉刷新
    self.grouptableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.grouptableview.mj_footer.hidden=NO;
        self.isUp=YES;
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:@"" forKey:@"title"];
        [params setObject:@"1" forKey:@"pageNo"];
        [params setObject:[NSString stringWithFormat:@"%ld",(int)(SCREEN_HEIGHT-NAV_HEIGHT-15)/self.cellHeight+1] forKey:@"pageSize"];
        [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
        
    }];

    //上拉刷新
 self.grouptableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
      ;
        self.isDown=YES;
        self.pgNo=self.pgNo+1;
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:@"" forKey:@"title"];
          [params setObject:[NSString stringWithFormat:@"%ld",self.pgNo] forKey:@"pageNo"];
     //一次刷新可以布满一个屏幕的cell数目
          [params setObject:[NSString stringWithFormat:@"%ld",(int)(SCREEN_HEIGHT-NAV_HEIGHT-15)/self.cellHeight+1] forKey:@"pageSize"];
         [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
    }];
  
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"通知公告"];
    self.isFirst=YES;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:@"" forKey:@"title"];
    [params setObject:@"1" forKey:@"pageNo"];
    [params setObject:[NSString stringWithFormat:@"%ld",(int)(SCREEN_HEIGHT-NAV_HEIGHT-15)/self.cellHeight+1] forKey:@"pageSize"];
    [self httpGetRequestWithUrl:HttpProtocolServiceNoticeList  params:params progress:YES];
    
    
}

-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    NSArray *data=[result objectForKey:@"datas"];
    if(self.isFirst){
        if(self.noticeList.count==0){
        self.noticeList=[[NSArray alloc]initWithArray:data];
        self.pgNo=1;
        }
        self.isFirst=NO;
        [self.grouptableview reloadData];
        if(data.count<(int)(SCREEN_HEIGHT-NAV_HEIGHT-15)/self.cellHeight){
            [self.grouptableview.mj_footer endRefreshingWithNoMoreData];
        }
    }
    if(self.isUp){
    self.noticeList=[[NSMutableArray alloc]initWithArray:data];
        self.pgNo=1;
        self.isUp=NO;
        [self.grouptableview reloadData];
        [self.grouptableview.mj_header endRefreshing];
        self.grouptableview.contentOffset=CGPointMake(0, 0);
    }
    if(self.isDown){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.noticeList];
        [temp addObjectsFromArray:data];
        self.noticeList=[[NSArray alloc]initWithArray:temp];
         self.isDown=NO;
        [self.grouptableview reloadData];
        if([data count]<(int)(SCREEN_HEIGHT-NAV_HEIGHT-15)/self.cellHeight+1){
            self.grouptableview.mj_footer.hidden=YES;
        }else{
            
         [self.grouptableview.mj_footer endRefreshing];
        }
       
        
    }
    self.grouptableview.contentOffset=CGPointMake(0, self.contentY);


    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.noticeList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NoticeList"];
    if(cell==nil){
        cell=[[NoticeListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeList"];
    }
    if(indexPath.row<[self.noticeList count]){
    NSDictionary *noticeData=[self.noticeList objectAtIndex:indexPath.row];
  
    cell.noticeTitle.text=[noticeData objectForKey:@"title"];
    cell.createdBy.text=[noticeData objectForKey:@"createdBy"];
    cell.createdTime.text=[noticeData objectForKey:@"createdTime"];
    //标题
    cell.noticeTitle.font=[UIFont boldSystemFontOfSize:15];
    //创建人边框
    cell.backgroundColor=[UIColor whiteColor];
    cell.createdBy.textColor=UI_BLUE_COLOR;
    cell.createdBy.layer.borderWidth=1;
    cell.createdBy.layer.borderColor=UI_BLUE_COLOR.CGColor;
    cell.createdBy.layer.cornerRadius=4.f;
    cell.createdBy.layer.masksToBounds=YES;
    //创建时间
    cell.createdTime.textColor=FONT_GRAY_COLOR;
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.contentY=self.grouptableview.contentOffset.y;
    NSDictionary *notciceData=[self.noticeList objectAtIndex:indexPath.row];
    self.select=indexPath.row;
    NSString *nd=[notciceData objectForKey:@"id"];
    NoticeDetailViewController *ndc=[[NoticeDetailViewController alloc]init];
    ndc.noticeID=nd;
    [self.navigationController pushViewController:ndc animated:YES];
    
}
// 自定义TableViewCell分割线, 清除前面15PX的空白
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end

