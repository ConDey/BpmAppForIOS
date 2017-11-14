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
@property(nonatomic,retain)UIBarButtonItem *rightButtom;
@property(nonatomic,retain)UICollectionView *calendarDataView;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    //导航栏右按钮
    self.rightButtom=[[UIBarButtonItem alloc]initWithTitle:@"确认选择" style:UIBarButtonItemStylePlain target:self action:@selector(addNewCalendar:)];
    [self.rightButtom setTintColor:UI_BLUE_COLOR];
    self.navigationItem.rightBarButtonItem=self.rightButtom;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"日程表"];
}

-(void)addNewCalendar:(UIButton *)button{
    NSLog(@"新增日程");
    NewCalendarViewController *anc=[[NewCalendarViewController alloc]init];
    [self.navigationController pushViewController:anc animated:YES];
}


@end
