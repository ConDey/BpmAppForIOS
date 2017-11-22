//
//  CalendarViewController.m
//  app.calendar
//
//  Created by feng sun on 2017/11/14.
//  Copyright © 2017年 eazytec. All rights reserved.
//

#import "CalendarViewController.h"

#import "NewCalendarViewController.h"
@interface CalendarViewController ()
{
    //当前时间
    NSInteger second;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger weekDay;
    NSDateComponents *comps;
    //日程数据
    NSMutableArray *calendarArray;
    NSDictionary *calendarDictionary;
    //选中日期编号
    NSInteger selectedNum;
    CGPoint point1;
    CGPoint point2;
   
}
@property(nonatomic,retain)UIBarButtonItem *rightButtom;
@property(nonatomic,retain)UICollectionView *calendarDataView;
@property(nonatomic,retain)UILabel *calendarTitleLabel;
@property(nonatomic,retain)NSString *eventDate;
@property(nonatomic,retain)NSMutableArray *eventDetailDataArray;
@property(nonatomic,retain)UISwipeGestureRecognizer *leftSwipe;
@property(nonatomic,retain)UISwipeGestureRecognizer *rightSwipe;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //导航栏右按钮
    self.rightButtom=[[UIBarButtonItem alloc]initWithTitle:@"新增日程" style:UIBarButtonItemStylePlain target:self action:@selector(addNewCalendar:)];
    [self.rightButtom setTintColor:UI_BLUE_COLOR];
    self.navigationItem.rightBarButtonItem=self.rightButtom;
    
    //当前时间
    [self currentTime];
    //选中时间
    [self showTimeLabel];
    //数据
    [self createdCalendarData];
    selectedNum=day;
    //日历表
    [self showCalendarTableView];
    //显示日程安排
    [self scheduleListView];
    
    
    
    //[self.calendarTitleLabel addGestureRecognizer:panToChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"日程表"];
}

-(void)currentTime{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 年月日获得
    comps =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay)
                       fromDate:date];
    year = [comps year];
    month = [comps month];
    day = [comps day];
    //当前的时分秒获得
    comps =[calendar components:(NSCalendarUnitHour| NSCalendarUnitMinute |NSCalendarUnitSecond)
                       fromDate:date];
    hour = [comps hour];
    minute = [comps minute];
    second=[comps second];
    
    
    //第一天数据
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps1 = [cal
                                components:NSCalendarUnitYear | NSCalendarUnitMonth
                                fromDate:now];
    comps1.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps1];
    [self getWeekDayOFFirstData:firstDay];
    
}
//获取某年某月1日的相关数据，是周几
-(void)getWeekDayOFFirstData:(NSDate *)data{
    NSCalendar *calendarFirst=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierPersian];
    NSDateComponents *components=[calendarFirst components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:data];
    weekDay=[components weekday];
    //if(weekDay==7){
   // weekDay=0;
   // }
    //范围1-7
}
//日历数据
-(void)createdCalendarData{
    
    calendarArray=[[NSMutableArray alloc]init];
    NSInteger dayNumOfMonth=[self howManyDaysInThisYear:year withMonth:month];
    NSInteger count=[self howManyDaysInThisYear:year withMonth:month-1]-weekDay+2;
    if(month==1){
        count=[self howManyDaysInThisYear:year-1 withMonth:12]-weekDay+2;
    }
    if(weekDay==0){
        for(int i=0;i<dayNumOfMonth;i++){
            [calendarArray insertObject:[NSString stringWithFormat:@"%d",i+1] atIndex:i];
        }
        for(int j=dayNumOfMonth;j<49;j++){
            [calendarArray insertObject:[NSString stringWithFormat:@"%d",j-weekDay-dayNumOfMonth+1] atIndex:j];
        }
    }else{
        for(int v=0;v<weekDay-1;v++){
            [calendarArray insertObject:[NSString stringWithFormat:@"%d",count] atIndex:v];
            count++;
        }
        for(int i=weekDay-1;i<dayNumOfMonth+weekDay-1;i++){
            [calendarArray insertObject:[NSString stringWithFormat:@"%d",i-weekDay+2] atIndex:i];
        }
        for(int j=dayNumOfMonth+weekDay-1;j<49;j++){
            [calendarArray insertObject:[NSString stringWithFormat:@"%d",j-weekDay-dayNumOfMonth+2] atIndex:j];
        }
        
    }
    calendarDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",year],@"year",[NSString stringWithFormat:@"%ld",month],@"month",calendarArray,@"day", nil];
    
}




//选中显示时间
-(void)showTimeLabel{
    
    self.calendarTitleLabel=[[UILabel alloc]init];
    [self.view addSubview:self.calendarTitleLabel];
    [self.calendarTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    self.calendarTitleLabel.backgroundColor=[UIColor colorWithRed:102.0/255.0 green:94.0/255.0 blue:98.0/255.0 alpha:0.7];
    self.calendarTitleLabel.textAlignment=NSTextAlignmentCenter;
    self.calendarTitleLabel.textColor=[UIColor whiteColor];
    self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    self.eventDate=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
}
//日历
-(void)showCalendarTableView{
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing=0;
    flow.minimumInteritemSpacing=0;
    flow.itemSize=CGSizeMake(SCREEN_WIDTH/7, SCREEN_WIDTH/7);
    flow.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.calendarDataView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_WIDTH*8/7) collectionViewLayout:flow];
    [self.view addSubview:self.calendarDataView];

    self.calendarDataView.backgroundColor=[UIColor colorWithRed:102.0/255.0 green:94.0/255.0 blue:98.0/255.0 alpha:0.7];
    self.calendarDataView.delegate=self;
    self.calendarDataView.dataSource=self;
    [self.calendarDataView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"calendarData"];
    self.calendarDataView.scrollEnabled=NO;
    
    //滑动操作
    //左滑
    self.leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    self.leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.calendarDataView addGestureRecognizer:self.leftSwipe];
    //右滑
    self.rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
    [self.calendarDataView addGestureRecognizer:self.rightSwipe];
    
    
}
//新增按钮
-(void)addNewCalendar:(UIButton *)button{
    NSLog(@"新增日程");
    NewCalendarViewController *anc=[[NewCalendarViewController alloc]init];
    anc.delegete=self;
    [self.navigationController pushViewController:anc animated:YES];
}
//日历界面设置
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section==0){
        return 7;
    }else{
        return 49;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"calendarData" forIndexPath:indexPath];
    if(cell!=nil){
        for(UIView *view in [cell subviews]){
            [view removeFromSuperview];
        }
    }
    UILabel *date=[[UILabel alloc]init];
    [cell addSubview:date];
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cell.mas_centerX);
        make.centerX.mas_equalTo(cell.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    date.textAlignment=NSTextAlignmentCenter;
    date.font=FONT_14;
    //date.textColor=[UIColor whiteColor];
    if(indexPath.section==0){
        NSInteger row=indexPath.row;
        if(row==0){
            date.text=@"日";
        }else if (row==1){
            date.text=@"一";
        }else if (row==2){
            date.text=@"二";
        }else if (row==3){
            date.text=@"三";
        }else if (row==4){
            date.text=@"四";
        }else if (row==5){
            date.text=@"五";
        }else if (row==6){
            date.text=@"六";
        }
    }
    
    if(indexPath.section==1){
        NSInteger dayNumOfMonth=[self howManyDaysInThisYear:year withMonth:month];
        if(weekDay==0){
            if(indexPath.row<dayNumOfMonth){
                date.textColor=[UIColor whiteColor];
            }else{
                date.textColor=[UIColor colorWithRed:76.0/255.0 green:81.0/255.0 blue:96.0/255.0 alpha:1];
            }
            
        }else{
            if(indexPath.row>=weekDay-1&&indexPath.row<dayNumOfMonth+weekDay-1){
                date.textColor=[UIColor whiteColor];
            }else{
                date.textColor=[UIColor colorWithRed:76.0/255.0 green:81.0/255.0 blue:96.0/255.0 alpha:1];
            }
            
        }
        
        
        if(indexPath.row==selectedNum){
            date.backgroundColor=[UIColor colorWithRed:115.0/255.0 green:122.0/255.0 blue:131.0/255.0 alpha:0.7];
            date.layer.cornerRadius=20;
            date.layer.masksToBounds=YES;
        }else{
            date.backgroundColor=[UIColor clearColor];
        }
        date.text=[calendarArray objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}
//获取某年某月的天数
- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1)||(month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12))
        return 31 ;
    
    if((month == 4)||(month == 6)||(month == 9)||(month == 11))
        return 30;
    
    if((year%4==1)||(year%4==2)||(year%4==3))
    {
        return 28;
    }
    
    if(year%400 == 0)
        return 29;
    
    if(year%100== 0)
        return 28;
    
    return 29;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        
        NSInteger dayNumOfMonth=[self howManyDaysInThisYear:year withMonth:month];
        if(weekDay==0){
            if(indexPath.row<dayNumOfMonth){
                selectedNum=indexPath.row;
                self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%@",year,month,[calendarArray objectAtIndex:indexPath.row]];
                self.eventDate=[NSString stringWithFormat:@"%ld-%ld-%@",year,month,[calendarArray objectAtIndex:indexPath.row]];
                [self.calendarDataView reloadData];
            }
            
        }else{
            if(indexPath.row>=weekDay-1&&indexPath.row<dayNumOfMonth+weekDay-1){
                selectedNum=indexPath.row;
                self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%@",year,month,[calendarArray objectAtIndex:indexPath.row]];
                self.eventDate=[NSString stringWithFormat:@"%ld-%ld-%@",year,month,[calendarArray objectAtIndex:indexPath.row]];
                [self.calendarDataView reloadData];
            }
            
        }
        
        
        
      
    }
    [self requestEventData:self.eventDate];
    
}


//日历滑动
-(void)leftSwipe:(UISwipeGestureRecognizer *)sender{
    month++;
    if(month>12){
        year++;
        month=1;
    }
    day=1;
    self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    self.eventDate=[NSString stringWithFormat:@"%ld-%ld-1",year,month];
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSCalendarUnitYear | NSCalendarUnitMonth
                               fromDate:now];
    comps.year=year;
    comps.month=month;
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    [self getWeekDayOFFirstData:firstDay];
    [self createdCalendarData];
    [self.calendarDataView reloadData];
    
    [self requestEventData:self.eventDate];
    
    
}
-(void)rightSwipe:(UISwipeGestureRecognizer *)sender{
    month--;
    if(month<1){
        year--;
        month=12;
        
    }
    day=1;
    self.eventDate=[NSString stringWithFormat:@"%ld-%ld-1",year,month];
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSCalendarUnitYear | NSCalendarUnitMonth
                               fromDate:now];
    comps.year=year;
    comps.month=month;
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    [self getWeekDayOFFirstData:firstDay];
    [self createdCalendarData];
    [self.calendarDataView reloadData];
    self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    
    [self requestEventData:self.eventDate];
    
}





-(void)scheduleListView{
    self.tableview=[[UITableView alloc]init];
    [self.view addSubview:self.tableview];
    CGFloat y=self.calendarDataView.frame.size.height+self.calendarDataView.origin.y+20;
   // NSLog(@"高度-%f-%f",self.calendarDataView.frame.size.height,self.calendarTitleLabel.frame.size.height);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCREEN_HEIGHT-y);
        make.bottom.left.right.mas_equalTo(0);
    }];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    // self.tableview.backgroundColor=[UIColor yellowColor];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"event"];
    self.tableview.scrollEnabled=NO;
    point1=CGPointMake(0, 0);
    point2=CGPointMake(0, 0);
    [self requestEventData:self.eventDate];
    
    UIPanGestureRecognizer *panToChange=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    panToChange.delegate=self;
    [panToChange requireGestureRecognizerToFail:self.leftSwipe];
    [panToChange requireGestureRecognizerToFail:self.rightSwipe];
    [self.view addGestureRecognizer:panToChange];
    
}


-(void)requestEventData:(NSString *)date{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:date forKey:@"date"];
    [self httpGetRequestWithUrl:HttpProtocolServiceScheduleList params:params progress:YES];
}

#pragma <UITableViewDelegate,UITableViewDataSource>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.eventDetailDataArray.count==0){
        return 1;
    }else{
        return self.eventDetailDataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"event"];
    if(cell!=nil){
        for(UIView *view in [cell subviews]){
            [view removeFromSuperview];
        }
    }
    if(self.eventDetailDataArray.count==0){
        UILabel *titleLabel=[[UILabel alloc]init];
        [cell addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        titleLabel.text=@"没有日程";
        titleLabel.textAlignment=NSTextAlignmentCenter;
    }else{
        UIView *singleView=[[UIView alloc]init];//分割线
        [cell addSubview:singleView];
        [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        singleView.backgroundColor=UI_DIVIDER_COLOR;
        UILabel *titleLabel=[[UILabel alloc]init];
        UILabel *beginTimeLabel=[[UILabel alloc]init];
        UILabel *endTimeLabel=[[UILabel alloc]init];
        UILabel *typeLabel=[[UILabel alloc]init];
        UIImageView *headImageView=[[UIImageView alloc]init];
        [cell addSubview:titleLabel];
        [cell addSubview:headImageView];
        [cell addSubview:beginTimeLabel];
        [cell addSubview:endTimeLabel];
        [cell addSubview:typeLabel];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 21));
            make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        
        [beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 21));
            make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(10);
        }];
        [endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 21));
            make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(beginTimeLabel.mas_bottom).mas_equalTo(10);
        }];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 21));
            make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(10);
            make.top.mas_equalTo(endTimeLabel.mas_bottom).mas_equalTo(10);;
        }];
        //文字类型
        headImageView.image=[UIImage imageNamed:@"ic_event_list.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        beginTimeLabel.textColor=FONT_GRAY_COLOR;
        endTimeLabel.textColor=FONT_GRAY_COLOR;
        typeLabel.textColor=FONT_GRAY_COLOR;
        titleLabel.font=FONT_14;
        beginTimeLabel.font=FONT_14;
        endTimeLabel.font=FONT_14;
        typeLabel.font=FONT_14;
        if(indexPath.row<self.eventDetailDataArray.count){
            NSDictionary *dic=[self.eventDetailDataArray objectAtIndex:indexPath.row];
            titleLabel.text=[dic objectForKey:@"eventName"];
            beginTimeLabel.text=[NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"startDate"],[dic objectForKey:@"startTime"]];
            endTimeLabel.text=[NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"endDate"],[dic objectForKey:@"endTime"]];;
            typeLabel.text=[dic objectForKey:@"eventTypeName"];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
//点击修改
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[self.eventDetailDataArray objectAtIndex:indexPath.row];
    NSString *currentEventId=[dic objectForKey:@"id"];
    NewCalendarViewController *cnc=[[NewCalendarViewController alloc]init];
    cnc.eventId=currentEventId;
    cnc.delegete=self;
    [self.navigationController pushViewController:cnc animated:YES];
}



//解析获得的日程数据
-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
    // NSLog(@"result;%@",result);
    self.eventDetailDataArray=[[NSMutableArray alloc]init];
    self.eventDetailDataArray=[result objectForKey:@"datas"];
    [self.tableview reloadData];
}


-(void)pan:(UIPanGestureRecognizer *)pan{
    if(pan.state==UIGestureRecognizerStateBegan){
        point1=[pan locationInView:self.view];
    }
    if(pan.state==UIGestureRecognizerStateChanged){
        point2=[pan locationInView:self.view];
    }
    if(pan.state==UIGestureRecognizerStateEnded){
        if((point1.y-point2.y)>100){
            CGFloat h=self.calendarTitleLabel.origin.y+self.calendarTitleLabel.frame.size.height+SCREEN_WIDTH/7*3+5;
            [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SCREEN_HEIGHT-h);
            }];
            self.tableview.scrollEnabled=YES;
            
        }else{
            CGFloat z=self.calendarDataView.frame.size.height+self.calendarTitleLabel.frame.size.height+20;
           // NSLog(@"高度-%f-%f",self.calendarDataView.frame.size.height,self.calendarTitleLabel.frame.size.height);
            [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SCREEN_HEIGHT-z);
            }];
            
        }
    }
   
}

-(void)calendarListReload{
    [self requestEventData:self.eventDate];
    [self.tableview reloadData];
}


@end

