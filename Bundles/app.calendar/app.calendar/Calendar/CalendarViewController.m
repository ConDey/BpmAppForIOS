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
}
@property(nonatomic,retain)UIBarButtonItem *rightButtom;
@property(nonatomic,retain)UICollectionView *calendarDataView;
@property(nonatomic,retain)UILabel *calendarTitleLabel;



@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor yellowColor];
    //导航栏右按钮
    self.rightButtom=[[UIBarButtonItem alloc]initWithTitle:@"确认选择" style:UIBarButtonItemStylePlain target:self action:@selector(addNewCalendar:)];
    [self.rightButtom setTintColor:UI_BLUE_COLOR];
    self.navigationItem.rightBarButtonItem=self.rightButtom;
    
    //当前时间
    [self currentTime];
    //选中时间
    [self showTimeLabel];
    //数据
    [self createdCalendarData];
    //日历表
    [self showCalendarTableView];
    
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
    if(weekDay==7){
        weekDay=0;
    }
    //范围1-7
}
//日历数据
-(void)createdCalendarData{
   
    calendarArray=[[NSMutableArray alloc]init];
    NSInteger dayNumOfMonth=[self howManyDaysInThisYear:year withMonth:month];
      NSInteger count=[self howManyDaysInThisYear:year withMonth:month-1]-weekDay+2;
    if(weekDay==0){
        for(int i=0;i<dayNumOfMonth;i++){
            [calendarArray insertObject:[NSString stringWithFormat:@"%d",i+1] atIndex:i];
        }
        for(int j=dayNumOfMonth;j<42;j++){
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
        for(int j=dayNumOfMonth+weekDay-1;j<42;j++){
            [calendarArray insertObject:[NSString stringWithFormat:@"%d",j-weekDay-dayNumOfMonth+2] atIndex:j];
        }
        
    }
    calendarDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",year],@"year",[NSString stringWithFormat:@"%d",month],@"month",calendarArray,@"day", nil];
    
    
    
    
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
    self.calendarTitleLabel.backgroundColor=[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:0.7];
    self.calendarTitleLabel.textAlignment=NSTextAlignmentCenter;
    self.calendarTitleLabel.textColor=[UIColor whiteColor];
    self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
}
//日历
-(void)showCalendarTableView{
    UICollectionViewFlowLayout *flow=[[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing=0;
    flow.minimumInteritemSpacing=0;
    flow.itemSize=CGSizeMake(SCREEN_WIDTH/7, SCREEN_WIDTH/7);
    flow.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.calendarDataView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_WIDTH) collectionViewLayout:flow];
    [self.view addSubview:self.calendarDataView];
    [self.calendarDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.calendarTitleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.left.mas_equalTo(0);
    }];
    self.calendarDataView.backgroundColor=[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:0.7];
    self.calendarDataView.delegate=self;
    self.calendarDataView.dataSource=self;
    [self.calendarDataView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"calendarData"];
    //滑动操作
    //左滑
    UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.calendarDataView addGestureRecognizer:leftSwipe];
    //右滑
    UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
    [self.calendarDataView addGestureRecognizer:rightSwipe];
}
//新增按钮
-(void)addNewCalendar:(UIButton *)button{
    NSLog(@"新增日程");
    NewCalendarViewController *anc=[[NewCalendarViewController alloc]init];
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
        return 42;
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
    date.backgroundColor=[UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:0.7];
    date.textAlignment=NSTextAlignmentCenter;
    date.font=FONT_14;
    date.textColor=[UIColor whiteColor];
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
      //  NSArray *arr=[calendarDictionary objectForKey:@"day"];
        date.text=[calendarArray objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}
//获取某年某月的天数
- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%@",year,month,[calendarArray objectAtIndex:indexPath.row]];
    }
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
    
     NSLog(@"qianWeek%ld",weekDay);
    
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:now];
   // NSLog(@"前年月日--%ld_%ld_%ld",[comps year],[comps month],[comps day]);
    comps.year=year;
    comps.month=month;
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
   // NSLog(@"hou年月日--%ld_%ld_%ld",[comps year],[comps month],[comps day]);
    
    [self getWeekDayOFFirstData:firstDay];
    [self createdCalendarData];
    [self.calendarDataView reloadData];
    NSLog(@"houWeek%ld",weekDay);
    
}
-(void)rightSwipe:(UISwipeGestureRecognizer *)sender{
    month--;
    if(month<1){
        year--;
        month=12;
        
    }
    day=1;
     NSLog(@"qian%ld",weekDay);
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:now];
   //  NSLog(@"前年月日--%ld_%ld_%d",[comps year],[comps month],[comps day]);
    comps.year=year;
    comps.month=month;
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
  //  NSLog(@"hou年月日--%ld_%ld_%ld",[comps year],[comps month],[comps day]);
    [self getWeekDayOFFirstData:firstDay];
    [self createdCalendarData];
    [self.calendarDataView reloadData];
    self.calendarTitleLabel.text=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    NSLog(@"hiou%ld",weekDay);
}



@end
