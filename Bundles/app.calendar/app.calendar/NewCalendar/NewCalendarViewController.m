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
    UIButton  *saveButton;
    BOOL isFeb;//是不是二月
    BOOL isFour;//是不是闰年
    BOOL isThirtyOne;//是不是31日，是为31
    BOOL isThirty;
    UIView *pickerAll;
    BOOL isStart;
}
@property(nonatomic,retain)UILabel *descriptionLabel;//事件描述

@property(nonatomic,retain)UITextField *eventId;
@property(nonatomic,retain)UITextField *eventName;
@property(nonatomic,retain)NSString *eventType;
@property(nonatomic,retain)UITextField *location;
@property(nonatomic,retain)UITextView *eventDescription;
@property(nonatomic,retain)UITextField *startDate;
@property(nonatomic,retain)UITextField *endDate;


//选择时间
@property(nonatomic,retain)NSString *eventStartDate;
@property(nonatomic,retain)NSString *eventStartTime;
@property(nonatomic,retain)NSString *eventEndDate;
@property(nonatomic,retain)NSString *eventEndTime;

//时间选择器
@property (nonatomic,strong)UIPickerView * pickerView1;//年月日
@property (nonatomic,strong)UIPickerView * pickerView2;//时分
@property(nonatomic,retain)NSData *minStartDate;
@property(nonatomic,retain)NSData *maxStartDate;
@property(nonatomic,retain)NSData *minEndDate;
@property(nonatomic,retain)NSData *maxEndDate;
//时间选择器的显示范围
@property(nonatomic,retain)NSArray *year;
@property(nonatomic,retain)NSArray *mon;
@property(nonatomic,retain)NSArray *day;
@property(nonatomic,retain)NSArray *hour;
@property(nonatomic,retain)NSArray *min;
@property(nonatomic,retain)NSDate *currentTime;
@property(nonatomic,retain)UILabel *currentTimeLabel;
@property(nonatomic,retain)UILabel *titleLabel;
@end

@implementation NewCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isThirtyOne=YES;
    self.eventType=@"临时";
    if(self.eventDescription.text.length==0){
        self.eventDescription=[[UITextView alloc]init];
    }
    //选择器
    pickerAll=[[UIView alloc]init];
    [self.view addSubview:pickerAll];
    [pickerAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(230);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    pickerAll.backgroundColor=[UIColor whiteColor];
    
    
    self.eventDescription.delegate=self;
    
    [self.view addSubview:self.tableview];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(250);
    }];
    
    self.tableview.backgroundColor=[UIColor whiteColor];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Calendar"];
    //具体描述
    
    UILabel *title=[[UILabel alloc]init];
    [self.view addSubview:title];
    [self.view addSubview:self.eventDescription];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.tableview.mas_bottom).mas_equalTo(2);
    }];
    [self.eventDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    self.eventDescription.layer.borderWidth=2;
    title.text=@"  事件描述:";
    title.font=FONT_14;
    title.textAlignment=NSTextAlignmentLeft;
    title.backgroundColor=[UIColor whiteColor];
    //保存按钮
    saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.eventDescription.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundColor: UI_BLUE_COLOR];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.textColor=[UIColor whiteColor];
    
    
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
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
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
        make.height.mas_equalTo(1);
    }];
    singleView.backgroundColor=UI_DIVIDER_COLOR;
    //事件名称
    UILabel *titleLabel=[[UILabel alloc]init];
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    
    titleLabel.font=FONT_14;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    if(indexPath.row==0){
        if(self.eventName.text.length==0){
            self.eventName=[[UITextField alloc]init];
        }
        self.eventName.delegate=self;
        [cell addSubview:self.eventName];
        [self.eventName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"  事件名称:";
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
        titleLabel.text=@"  开始时间:";
        self.startDate.placeholder=@"点击选择";
        UITapGestureRecognizer *tapStart=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStartTime:)];
        [self.startDate addGestureRecognizer:tapStart];
    }else if (indexPath.row==2){
        self.endDate=[[UITextField alloc]init];
        self.endDate.delegate=self;
        [cell addSubview:self.endDate];
        [self.endDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"  结束时间:";
        self.endDate.placeholder=@"点击选择";
        UITapGestureRecognizer *tapEnd=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndTime:)];
        [self.endDate addGestureRecognizer:tapEnd];
    }else if (indexPath.row==3){
        titleLabel.text=@"  事件类型:";
        UILabel *typeLabel=[[UILabel alloc]init];
        [cell addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        typeLabel.text=self.eventType;
        typeLabel.font=FONT_14;
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
        
        
        
    }else {
        if(self.location.text.length==0){
            self.location=[[UITextField alloc]init];
        }
        self.location.delegate=self;
        [cell addSubview:self.location];
        [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"  事件地点:";
        self.location.placeholder=@"请填写事件地点";
        
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

//文本开始编辑

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField==self.startDate||textField==self.endDate){
        return NO;
    }else{
        return YES;
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
    if(self.eventName.text.length!=0&&self.startDate.text.length!=0&&self.endDate.text.length!=0){
        [self sendNewCalendar];
    }else{
        NSLog(@"输入不完整");
        NSLog(@"%@-%@-%@-%@-%@--%@",self.eventName.text,self.eventType,self.startDate.text,self.eventDescription.text,self.endDate.text,self.location.text);
    }
}

//保存
-(void)sendNewCalendar{
    
    NSMutableDictionary *paramas=[[NSMutableDictionary alloc]init];
    [paramas setObject:@"" forKey:@"id"];
    [paramas setObject:self.eventName.text forKey:@"eventName"];
    [paramas setObject:self.eventType forKey:@"eventType"];
    [paramas setObject:self.location.text forKey:@"location"];
    [paramas setObject:self.eventDescription.text forKey:@"description"];
    [paramas setObject:self.eventStartDate forKey:@"startDate"];
    [paramas setObject:self.eventStartTime forKey:@"startTime"];
    [paramas setObject:self.eventEndDate forKey:@"endDate"];
    [paramas setObject:self.eventEndTime forKey:@"endTime"];
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



// 文本发生改变
//计算文本大小
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}
//更改文本区域高度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    CGRect frame = textView.frame;
    CGRect frameSave =saveButton.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    
    frame.size.height = height;
    frameSave.origin.y=frame.origin.y+height+20;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        textView.frame = frame;
        saveButton.frame=frameSave;
        
    } completion:nil];
    
    return YES;
}



#pragma <UIPickerViewDelegate,UIPickerViewDataSource>
//选择开始时间
-(void)tapStartTime:(UITapGestureRecognizer *)sender{
    NSLog(@"选择开始时间");
    isStart=YES;
    pickerAll.hidden=NO;
    [self addPickerDataYearAndMinAndHourAndMon];
    [self addTimePicker];
    [self addPickerDataDay:1 withEnd:30];
}
//选择结束时间
-(void)tapEndTime:(UITapGestureRecognizer *)sender{
    isStart=NO;
    pickerAll.hidden=NO;
    [self addPickerDataYearAndMinAndHourAndMon];
    [self addTimePicker];
    [self addPickerDataDay:1 withEnd:30];
    [self.pickerView1 selectRow:5 inComponent:0 animated:YES];
    [self.pickerView1 selectRow:56 inComponent:1 animated:YES];
    [self.pickerView1 selectRow:12 inComponent:2 animated:YES];
    [self.pickerView2 selectRow:3 inComponent:0 animated:YES];
    [self.pickerView2 selectRow:78 inComponent:1 animated:YES];
}

//时间选择器界面
-(void)addTimePicker{
    
    //2个选择器
    self.pickerView1=[[UIPickerView alloc]init];
    self.pickerView2=[[UIPickerView alloc]init];
    [pickerAll addSubview:self.pickerView1];
    [pickerAll addSubview:self.pickerView2];
    [self.pickerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(SCREEN_WIDTH*3/5);
    }];
    [self.pickerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(SCREEN_WIDTH*2/5);
    }];
    //    self.pickerView2.layer.borderWidth=2;
    //    self.pickerView1.layer.borderWidth=1;
    //数据源
    self.pickerView1.delegate=self;
    self.pickerView1.dataSource=self;
    self.pickerView2.delegate=self;
    self.pickerView2.dataSource=self;
    //选择器初始位置
    
    
    
    
    //显示当前时间
    self.currentTimeLabel=[[UILabel alloc]init];
    self.currentTimeLabel.backgroundColor=UI_BLUE_COLOR;
    [pickerAll addSubview:self.currentTimeLabel];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(150);
    }];
    self.currentTimeLabel.textAlignment=NSTextAlignmentRight;
    self.currentTimeLabel.text=@"2017-11-14 20:11:03";
    self.currentTimeLabel.font=FONT_14;
    //标题
    self.titleLabel=[[UILabel alloc]init];
    self.titleLabel.backgroundColor=UI_BLUE_COLOR;
    [pickerAll addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(150);
    }];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.text=@"选择计划时间";
    self.titleLabel.font=FONT_14;
    //取消按钮
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [pickerAll addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(SCREEN_WIDTH/2-11);
    }];
    [cancel setBackgroundColor: UI_BLUE_COLOR];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    //返回日期
    UIButton *date=[UIButton buttonWithType:UIButtonTypeCustom];
    [pickerAll addSubview:date];
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(SCREEN_WIDTH/2-11);
    }];
    [date setBackgroundColor: UI_BLUE_COLOR];
    [date setTitle:@"确定" forState:UIControlStateNormal];
    [date addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    
}
//返回时间选择结果或者取消
-(void)selectDate:(UIButton *)bt{
    if(isStart){
        self.startDate.text=[NSString stringWithFormat:@"%@ %@",self.eventStartDate,self.eventStartTime];
    }else{
        self.endDate.text=[NSString stringWithFormat:@"%@ %@",self.eventEndDate,self.eventEndTime];
    }
    pickerAll.hidden=YES;
}
-(void)cancel:(UIButton *)bt{
    pickerAll.hidden=YES;
    if(isStart){
        self.startDate.text=@"";
    }else{
        self.endDate.text=@"";
    }
}

//时间选择器数据-年时分
-(void)addPickerDataYearAndMinAndHourAndMon{
    //年
    for(int yearInt=2011;yearInt<2023;yearInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.year];
        [temp addObject:[NSString stringWithFormat:@"%d年",yearInt]];
        self.year=[[NSArray alloc]initWithArray:temp];
    }
    NSLog(@"++++%@",self.year);
    //时
    for(int hourInt=0;hourInt<24;hourInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.hour];
        [temp addObject:[NSString stringWithFormat:@"%d时",hourInt]];
        self.hour=[[NSArray alloc]initWithArray:temp];
    }
    NSLog(@"++++%@",self.hour);
    //分
    for(int minInt=0;minInt<60;minInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.min];
        [temp addObject:[NSString stringWithFormat:@"%d分",minInt]];
        self.min=[[NSArray alloc]initWithArray:temp];
    }
    NSLog(@"++++%@",self.min);
    //月
    for(int monInt=1;monInt<13;monInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.mon];
        [temp addObject:[NSString stringWithFormat:@"%d月",monInt]];
        self.mon=[[NSArray alloc]initWithArray:temp];
    }
    NSLog(@"++++%@",self.mon);
}
//时间选择器数据-月日
-(void)addPickerDataDay:(int)count withEnd:(int)end{
    
    for(int dayInt=count;dayInt<=end;dayInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.day];
        [temp addObject:[NSString stringWithFormat:@"%d日",dayInt]];
        self.day=[[NSArray alloc]initWithArray:temp];
    }
    
}



//选择器布局
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView==self.pickerView1){
        return 3;
    }else{
        return 2;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 16000;
}
//显示数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title=nil;
    if(pickerView==self.pickerView1){
        if(component==0){
            NSInteger count=row%self.year.count;
            title=[self.year objectAtIndex:count];
        }else if(component==1){
            NSInteger count=row%12;
            title=[self.mon objectAtIndex:count];
        }else{
            NSInteger count=row%self.day.count;
            title=[self.day objectAtIndex:count];
        }
    }
    if(pickerView==self.pickerView2){
        if(component==0){
            NSInteger count=row%24;
            title=[self.hour objectAtIndex:count];
        }else if(component==1){
            NSInteger count=row%60;
            title=[self.min objectAtIndex:count];
        }
    }
    return title;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *la=(UILabel *)view;
    if(!la){
        la=[[UILabel alloc]init];
    }
    [la setFont:[UIFont systemFontOfSize:14]];
    [la setBackgroundColor:[UIColor whiteColor]];
    la.textAlignment=NSTextAlignmentCenter;
    la.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return la;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *titleYear=[self pickerView:self.pickerView1 titleForRow:row forComponent:0];
    NSString *titleMon=[self pickerView:self.pickerView1 titleForRow:row forComponent:1];
    NSString *titleDay=[self pickerView:self.pickerView1 titleForRow:row forComponent:2];
    NSString *titleHour=[self pickerView:self.pickerView2 titleForRow:row forComponent:0];
    NSString *titleMin=[self pickerView:self.pickerView2 titleForRow:row forComponent:1];
    NSString *yearNum=[titleYear substringToIndex:[titleYear length]-1];
    NSString *monNum=[titleYear substringToIndex:[titleMon length]-1];
    NSString *dayNum=[titleYear substringToIndex:[titleDay length]-1];
    NSString *hourNum=[titleYear substringToIndex:[titleHour length]-1];
    NSString *minNum=[titleYear substringToIndex:[titleMin length]-1];
    if(isStart){
        self.eventStartDate=[NSString stringWithFormat:@"%@-%@-%@",yearNum,monNum,dayNum];
        self.eventStartTime=[NSString stringWithFormat:@"%@:%@:12",hourNum,minNum];
    }else{
        self.eventEndDate=[NSString stringWithFormat:@"%@-%@-%@",yearNum,monNum,dayNum];
        self.eventEndTime=[NSString stringWithFormat:@"%@:%@:12",hourNum,minNum];
    }
    int yearInt=[yearNum intValue];
    int monInt=[monNum intValue];
    
    if(monInt==1||monInt==3||monInt==5||monInt==7||monInt==8||monInt==10||monInt==12){
        [self addPickerDataDay:1 withEnd:31];
    }else if(monInt==4||monInt==6||monInt==9||monInt==11){
        [self addPickerDataDay:1 withEnd:30];
        [self.pickerView1 reloadComponent:2];
    }else{
        if(yearInt%4==0){
            [self addPickerDataDay:1 withEnd:28];
            [self.pickerView1 reloadComponent:2];
        }else{
            [self addPickerDataDay:1 withEnd:29];
            [self.pickerView1 reloadComponent:2];
        }
    }
    [self.pickerView1 reloadAllComponents];
    [self.pickerView2 reloadAllComponents];
    // [self.pickerView1 reloadComponent:2];
}














@end

