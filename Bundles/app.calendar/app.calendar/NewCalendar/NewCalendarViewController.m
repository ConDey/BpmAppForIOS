//
//  NewCalendarViewController.m
//  app.calendar
//
//  Created by feng sun on 2017/11/14.
//  Copyright © 2017年 eazytec. All rights reserved.
//

#import "NewCalendarViewController.h"
#import "NewCalendarModel.h"
@interface NewCalendarViewController ()
{
    CGFloat dsHeight;
}
@property(nonatomic,retain)UILabel *divider;//事件描述前的分割线
@property(nonatomic,retain)UILabel *descriptionLabel;//事件描述

@property(nonatomic,retain)NewCalendarModel *calendar;


@property(nonatomic,retain)UITextField *eventId;
@property(nonatomic,retain)UITextField *eventName;
@property(nonatomic,retain)NSString *eventType;
@property(nonatomic,retain)UITextField *location;
@property(nonatomic,retain)UITextField *eventDescription;
@property(nonatomic,retain)UITextField *startDate;
@property(nonatomic,retain)UITextField *startTime;
@property(nonatomic,retain)UITextField *endDate;
@property(nonatomic,retain)UITextField *endTime;
@end

@implementation NewCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventType=@"临时";
    dsHeight=30;
    [self.view addSubview:self.tableview];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    self.tableview.backgroundColor=[UIColor whiteColor];
    // self.tableview.scrollEnabled=NO;
    // self.tableview.estimatedRowHeight=100;
    // self.tableview.rowHeight=UITableViewAutomaticDimension;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Calendar"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"新增日程"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==5){
        return dsHeight+50;
    }else{
        return 50;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Calendar"];
    if(cell!=nil){
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
            
        }
    }
    UIView *singleView=[[UIView alloc]init];//分割线
    [cell addSubview:singleView];
    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    singleView.backgroundColor=UI_DIVIDER_COLOR;
    //事件名称
    UILabel *titleLabel=[[UILabel alloc]init];
    [cell addSubview:titleLabel];
    if(indexPath.row==5){
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH-10);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
    }else{
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(60);
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }
    titleLabel.font=FONT_14;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    if(indexPath.row==0){
        self.eventName=[[UITextField alloc]init];
        self.eventName.delegate=self;
        [cell addSubview:self.eventName];
        [self.eventName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"事件名称:";
        self.eventName.placeholder=@"请填写事件名称";
        
    }else if (indexPath.row==1){
        self.startDate=[[UITextField alloc]init];
        self.startDate.delegate=self;
        [cell addSubview:self.startDate];
        [self.startDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"开始时间:";
        self.startDate.placeholder=@"点击选择";
    }else if (indexPath.row==2){
        self.endDate=[[UITextField alloc]init];
        self.endDate.delegate=self;
        [cell addSubview:self.endDate];
        [self.endDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"结束时间:";
        self.endDate.placeholder=@"点击选择";
        
    }else if (indexPath.row==3){
        titleLabel.text=@"事件类型:";
        UILabel *typeLabel=[[UILabel alloc]init];
        [cell addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        typeLabel.text=self.eventType;
        
        //右侧选择类型按钮
        UIImage *image=[UIImage imageNamed:@"ic_common_left_back.png"];
        UIButton *selectTypeBt=[UIButton buttonWithType:UIButtonTypeCustom];
        
        //   selectTypeBt.backgroundColor=[UIColor blueColor];
        [selectTypeBt setBackgroundImage:image forState:UIControlStateNormal];
        
        
        
        [cell addSubview:selectTypeBt];
        [selectTypeBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.mas_equalTo(-5);
        }];
        [selectTypeBt addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }else if (indexPath.row==4){
        self.location=[[UITextField alloc]init];
        self.location.delegate=self;
        [cell addSubview:self.location];
        [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"事件地点:";
        self.location.placeholder=@"请填写事件名称";
        
    }else if(indexPath.row==5) {
        self.eventDescription=[[UITextField alloc]init];
        self.eventDescription.delegate=self;
        [cell addSubview:self.eventDescription];
        [self.eventDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.height.mas_equalTo(dsHeight);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        //titleLabel.layer.borderWidth=1;
        //self.eventDescription.layer.borderWidth=2;
        titleLabel.text=@"事件描述:";
        self.eventDescription.placeholder=@"时间描述";
        
    }else{
        //保存按钮
        UIButton  *saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:saveButton];
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(cell.mas_centerX);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.width.mas_equalTo(80);
        }];
        [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setBackgroundColor: UI_BLUE_COLOR];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.titleLabel.textColor=[UIColor whiteColor];
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

//文本开始编辑
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.eventName) {
        self.calendar.eventName=self.eventName.text;
    }else if(textField==self.startDate){
        self.calendar.startDate=self.startDate.text;
    }else if(textField==self.endDate){
        self.calendar.endDate=self.endDate.text;
    }else if(textField==self.eventDescription){
        //根据具体的文本大小设置cell大小
        NSString *str = self.eventDescription.text;
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        UIFont *font = [UIFont systemFontOfSize:17];
        [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
        [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) options:options context:nil];
        if(rect.size.height>dsHeight){
            dsHeight=rect.size.height+50;
        }
        self.calendar.Description=self.eventDescription.text;
        [self.tableview reloadData];
        self.calendar.Description=self.eventDescription.text;
        NSLog(@"描述%@",self.calendar.Description);
    }else if(textField==self.location){
        self.location.text=self.calendar.location;
    }
    
    
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//点击保存
-(void)save:(UIButton *)bt{
    if(self.eventName.text.length!=0&&self.eventType.length!=0&&self.location.text.length!=0&&self.eventDescription.text.length!=0&&self.startDate.text.length!=0&&self.startTime.text.length!=0&&self.endDate.text.length!=0&&self.endTime.text.length!=0){
        [self sendNewCalendar];
    }
}

//保存
-(void)sendNewCalendar{
    
    NSMutableDictionary *paramas=[[NSMutableDictionary alloc]init];
    [paramas setObject:@"" forKey:@"id"];
    [paramas setObject:self.eventName forKey:@"eventName"];
    [paramas setObject:self.eventType forKey:@"eventType"];
    [paramas setObject:self.location forKey:@"location"];
    [paramas setObject:self.eventDescription forKey:@"description"];
    [paramas setObject:self.startDate forKey:@"startDate"];
    [paramas setObject:self.startTime forKey:@"startTime"];
    [paramas setObject:self.endDate forKey:@"endDate"];
    [paramas setObject:self.endTime forKey:@"endTime"];
    [self httpGetRequestWithUrl:HttpProtocolServiceScheduleSave params:paramas progress:nil];
}

//选择类别
-(void)selectType:(UIButton *)button{
    UIAlertController *alert=[[UIAlertController alloc]init];
    [alert addAction:[UIAlertAction actionWithTitle:@"临时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.eventType=@"临时";
        [self.tableview reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.eventType=@"会议";
        [self.tableview reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"旅行" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.eventType=@"旅行";
        [self.tableview reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
