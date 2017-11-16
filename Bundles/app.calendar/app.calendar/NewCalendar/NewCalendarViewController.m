//
//  NewCalendarViewController.m
//  app.calendar
//
//  Created by feng sun on 2017/11/14.
//  Copyright © 2017年 eazytec. All rights reserved.
//

#import "NewCalendarViewController.h"


@interface NewCalendarViewController ()
{
    CGFloat dsHeight;
    UIButton  *saveButton;
    UIView *pickerAll;
    BOOL isStart;
    NSString *titleYear;
    NSString *titleMon;
    NSString *titleDay;
    NSString *titleHour;
    NSString *titleMin;
    //当前时间
    NSInteger second;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    BOOL isSelectTime;
}
@property(nonatomic,retain)UILabel *descriptionLabel;//事件描述


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
    
    
    self.eventDescription=[[UITextView alloc]init];
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
        make.height.mas_equalTo(55);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
   // self.eventDescription.layer.borderWidth=2;
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
    
    if(self.eventId.length!=0){
        [self requestDataById];
    }else{
        self.eventType=@"临时";
    }
}


//根据id请求数据
-(void)requestDataById{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSURL *URL = [NSURL URLWithString:[REQUEST_SERVICE_URL stringByAppendingString:@"schedule/detail"]];

     NSString *cookie = [NSString stringWithFormat:@"%@",[CurrentUser currentUser].token];
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:self.eventId forKey:@"id"];
    [manager GET:[NSString stringWithFormat:@"%@",URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.eventName.text=[responseObject objectForKey:@"eventName"];
        self.eventType=[responseObject objectForKey:@"eventTypeName"];
        self.location.text=[responseObject objectForKey:@"location"];
        self.eventDescription.text=[responseObject objectForKey:@"description"];
        self.eventStartDate=[responseObject objectForKey:@"startDate"];
        self.eventStartTime=[responseObject objectForKey:@"startTime"];
        
        self.eventEndDate=[responseObject objectForKey:@"endDate"];
        self.eventEndTime=[responseObject objectForKey:@"endTime"];
        
        
        self.startDate.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventStartDate,self.eventStartTime,second];
        self.endDate.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventEndDate,self.eventEndTime,second];
        
        
        
        NSLog(@"name---%@",[responseObject objectForKey:@"eventName"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
            self.eventName.placeholder=@"请填写事件名称";
        }
        self.eventName.delegate=self;
        [cell addSubview:self.eventName];
        [self.eventName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"  事件名称:";
       
        
    }else if (indexPath.row==1){
        if(self.startDate.text.length==0){
        self.startDate=[[UITextField alloc]init];
            self.startDate.placeholder=@"点击选择";
        }
        self.startDate.delegate=self;
        [cell addSubview:self.startDate];
        [self.startDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"  开始时间:";
        
        UITapGestureRecognizer *tapStart=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStartTime:)];
        [self.startDate addGestureRecognizer:tapStart];
    }else if (indexPath.row==2){
        if(self.endDate.text.length==0){
        self.endDate=[[UITextField alloc]init];
        self.endDate.placeholder=@"点击选择";
        }
        self.endDate.delegate=self;
        [cell addSubview:self.endDate];
        [self.endDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"  结束时间:";
        
        UITapGestureRecognizer *tapEnd=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndTime:)];
        [self.endDate addGestureRecognizer:tapEnd];
    }else if (indexPath.row==3){
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
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
        
        
    }else {
        if(self.location.text.length==0){
            self.location=[[UITextField alloc]init];
             self.location.placeholder=@"请填写事件地点";
        }
        self.location.delegate=self;
        [cell addSubview:self.location];
        [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
        titleLabel.text=@"  事件地点:";
       
        
    }
    
    
   
    return cell;
}

//点击选择类别
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==3){
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
       // NSLog(@"%@-%@-%@-%@-%@--%@-%@-%@-%@",self.eventName.text,self.eventType,self.eventEndDate,self.eventEndTime,self.eventStartDate,self.eventStartTime,self.eventDescription.text,self.endDate.text,self.location.text);
    }
}

//保存
-(void)sendNewCalendar{
    
    NSMutableDictionary *paramas=[[NSMutableDictionary alloc]init];
    if(self.eventId.length==0){
    [paramas setObject:@"" forKey:@"id"];
    }else{
    [paramas setObject:self.eventId forKey:@"id"];
    }
    [paramas setObject:self.eventName.text forKey:@"eventName"];
    [paramas setObject:self.eventType forKey:@"eventType"];
    [paramas setObject:self.location.text forKey:@"location"];
    [paramas setObject:self.eventDescription.text forKey:@"description"];
    [paramas setObject:self.eventStartDate forKey:@"startDate"];
    [paramas setObject:self.eventStartTime forKey:@"startTime"];
    [paramas setObject:self.eventEndDate forKey:@"endDate"];
    [paramas setObject:self.eventEndTime forKey:@"endTime"];
    NSLog(@"parmas--%@",paramas);
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSURL *URL = [NSURL URLWithString:[REQUEST_SERVICE_URL stringByAppendingString:@"schedule/detail"]];
    
    NSString *cookie = [NSString stringWithFormat:@"%@",[CurrentUser currentUser].token];
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [manager POST:[NSString stringWithFormat:@"%@",URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
   
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
    isStart=YES;
    isSelectTime=NO;
    pickerAll.hidden=NO;
    [self beginningTime];
    [self addPickerDataYearAndMinAndHourAndMon];
    [self addTimePicker];
    [self beginningTimeWithXY];
   
    
}
//选择结束时间
-(void)tapEndTime:(UITapGestureRecognizer *)sender{
    isStart=NO;
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
    pickerAll.hidden=NO;
    [self beginningTime];
    [self addPickerDataYearAndMinAndHourAndMon];
    [self addTimePicker];
    [self beginningTimeWithXY];

    
}
//时间选择器时间初始化
-(void)beginningTime{
    NSDate*date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    // 年月日获得
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
                       fromDate:date];
     year = [comps year];
     month = [comps month];
     day = [comps day];
    titleYear=[NSString stringWithFormat:@"%ld年",year];
    titleMon=[NSString stringWithFormat:@"%ld月",month];
    titleDay=[NSString stringWithFormat:@"%ld日",day];
    //当前的时分秒获得
    comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)
                       fromDate:date];
     hour = [comps hour];
     minute = [comps minute];
    second=[comps second];
    titleHour=[NSString stringWithFormat:@"%ld时",hour];
    titleMin=[NSString stringWithFormat:@"%ld分",minute];
    
        if(month==1||month==3||month==5||month==7||month==8||month==10||month==12)
    {
        [self addPickerDataDay:1 withEnd:31];
    }else if (month==4||month==6||month==9||month==11){
        [self addPickerDataDay:1 withEnd:30];
    }else if(month==2){
        if(year%4==0){
            [self addPickerDataDay:1 withEnd:29];
        }else{
            [self addPickerDataDay:1 withEnd:28];
        }
    }
    
   
}

-(void)beginningTimeWithXY{
    //初始位置
    [self.pickerView1 selectRow:self.year.count*20+year-2011 inComponent:0 animated:NO];
    [self.pickerView1 selectRow:self.mon.count*20+month-1 inComponent:1 animated:NO];
    [self.pickerView1 selectRow:self.day.count*20+day-1 inComponent:2 animated:NO];
    [self.pickerView2 selectRow:self.hour.count*20+hour inComponent:0 animated:NO];
    [self.pickerView2 selectRow:self.min.count*20+minute inComponent:1 animated:NO];
    if(!isSelectTime){
        if(isStart){
            self.eventStartDate=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
            self.eventStartTime=[NSString stringWithFormat:@"%ld:%ld",hour,minute];
        }else{
            self.eventEndDate=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
            self.eventEndTime=[NSString stringWithFormat:@"%ld:%ld",hour,minute];
        }
        
    }
}



//时间选择器界面
-(void)addTimePicker{
    //显示当前时间
    self.currentTimeLabel=[[UILabel alloc]init];
   // self.currentTimeLabel.backgroundColor=UI_BLUE_COLOR;
    [pickerAll addSubview:self.currentTimeLabel];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(39);
        make.width.mas_equalTo(150);
    }];
    NSDate *cd = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:cd];

    
    self.currentTimeLabel.textAlignment=NSTextAlignmentRight;
    self.currentTimeLabel.text=DateTime;
    self.currentTimeLabel.font=FONT_14;
    //标题
    self.titleLabel=[[UILabel alloc]init];
    //self.titleLabel.backgroundColor=UI_BLUE_COLOR;
    [pickerAll addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(39);
        make.width.mas_equalTo(150);
    }];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.text=@"选择计划时间";
    self.titleLabel.font=FONT_14;
    //分割线1
    UIView *singleView1=[[UIView alloc]init];
    [pickerAll addSubview:singleView1];
    [singleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.currentTimeLabel.mas_bottom);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(0);
    }];
    singleView1.backgroundColor=UI_DIVIDER_COLOR;
    //2个选择器
    self.pickerView1=[[UIPickerView alloc]init];
    self.pickerView2=[[UIPickerView alloc]init];
    [pickerAll addSubview:self.pickerView1];
    [pickerAll addSubview:self.pickerView2];
    [self.pickerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.top.mas_equalTo(singleView1.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH*3/5);
    }];
    [self.pickerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.top.mas_equalTo(singleView1.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH*2/5);
    }];
    //    self.pickerView2.layer.borderWidth=2;
    //    self.pickerView1.layer.borderWidth=1;
    //数据源
    self.pickerView1.delegate=self;
    self.pickerView1.dataSource=self;
    self.pickerView2.delegate=self;
    self.pickerView2.dataSource=self;
    
    //分割线2
    UIView *singleView2=[[UIView alloc]init];//分割线
    [pickerAll addSubview:singleView2];
    [singleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pickerView1.mas_bottom);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(0);
    }];
    singleView2.backgroundColor=UI_DIVIDER_COLOR;
   
    
    //取消按钮
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [pickerAll addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
        make.top.mas_equalTo(singleView2.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH/2-11);
    }];
    [cancel setTitleColor:UI_GRAY_COLOR forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    //返回日期
    UIButton *date=[UIButton buttonWithType:UIButtonTypeCustom];
    [pickerAll addSubview:date];
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
         make.top.mas_equalTo(singleView2.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH/2-11);
    }];
    
    [date setTitleColor:UI_GRAY_COLOR forState:UIControlStateNormal];
    [date setTitle:@"确定" forState:UIControlStateNormal];
    [date addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    //分割线3
    UIView *singleView3=[[UIView alloc]init];//分割线
    [pickerAll addSubview:singleView3];
    [singleView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(pickerAll.mas_centerX);
        make.bottom.mas_equalTo(-4);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
    }];
    singleView3.backgroundColor=UI_DIVIDER_COLOR;
    
}
//返回时间选择结果或者取消
-(void)selectDate:(UIButton *)bt{
    if(isStart){
        self.startDate.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventStartDate,self.eventStartTime,second];
    }else{
        self.endDate.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventEndDate,self.eventEndTime,second];
    }
    pickerAll.hidden=YES;
}
-(void)cancel:(UIButton *)bt{
    pickerAll.hidden=YES;
    if(isStart){
        if(self.startDate.text==nil){
        self.startDate.text=@"";
        }
    }else{
        if(self.endDate.text==nil){
        self.endDate.text=@"";
        }
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
   // NSLog(@"++++%@",self.year);
    //时
    for(int hourInt=0;hourInt<24;hourInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.hour];
        [temp addObject:[NSString stringWithFormat:@"%d时",hourInt]];
        self.hour=[[NSArray alloc]initWithArray:temp];
    }
    //NSLog(@"++++%@",self.hour);
    //分
    for(int minInt=0;minInt<60;minInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.min];
        [temp addObject:[NSString stringWithFormat:@"%d分",minInt]];
        self.min=[[NSArray alloc]initWithArray:temp];
    }
    //NSLog(@"++++%@",self.min);
    //月
    for(int monInt=1;monInt<13;monInt++){
        NSMutableArray *temp=[[NSMutableArray alloc]initWithArray:self.mon];
        [temp addObject:[NSString stringWithFormat:@"%d月",monInt]];
        self.mon=[[NSArray alloc]initWithArray:temp];
    }
   // NSLog(@"++++%@",self.mon);
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
    isSelectTime=YES;
    NSString *yearNum;
    NSString *monNum;
    NSString *dayNum;
    NSString *hourNum;
    NSString *minNum;
    if(pickerView==self.pickerView1&&component==0){
        NSString *title=[self pickerView:pickerView titleForRow:row forComponent:component];
        if(title!=nil){
            titleYear=title;
        }
       
    }else if (pickerView==self.pickerView1&&component==1){
        NSString *title=[self pickerView:pickerView titleForRow:row forComponent:component];
        if(title!=nil){
            titleMon=title;
        }
    }else if (pickerView==self.pickerView1&&component==2){
        NSString *title= [self pickerView:pickerView titleForRow:row forComponent:component];
        if(title!=nil){
            titleDay=title;
        }
    }else if (pickerView==self.pickerView2&&component==0){
        NSString *title=[self pickerView:pickerView titleForRow:row forComponent:component];
        if(title!=nil){
            titleHour=title;
        }
    }else if (pickerView==self.pickerView2&&component==1){
        NSString *title=[self pickerView:pickerView titleForRow:row forComponent:component];
        if(title!=nil){
            titleMin=title;
        }
    }
     yearNum=[titleYear substringToIndex:[titleYear length]-1];
     monNum=[titleMon substringToIndex:[titleMon length]-1];
     dayNum=[titleDay substringToIndex:[titleDay length]-1];
     hourNum=[titleHour substringToIndex:[titleHour length]-1];
     minNum=[titleMin substringToIndex:[titleMin length]-1];
    
    
   //  NSLog(@"%@-%@-%@-%@-%@",yearNum,monNum,dayNum,hourNum,minNum);
    if(isStart){
        self.eventStartDate=[NSString stringWithFormat:@"%@-%@-%@",yearNum,monNum,dayNum];
        self.eventStartTime=[NSString stringWithFormat:@"%@:%@",hourNum,minNum];
    }else{
        self.eventEndDate=[NSString stringWithFormat:@"%@-%@-%@",yearNum,monNum,dayNum];
        self.eventEndTime=[NSString stringWithFormat:@"%@:%@",hourNum,minNum];
    }
    int yearInt=[yearNum intValue];
    int monInt=[monNum intValue];
    self.day=[[NSArray alloc]init];
    if(monInt==1||monInt==3||monInt==5||monInt==7||monInt==8||monInt==10||monInt==12){
        [self addPickerDataDay:1 withEnd:31];
        [self.pickerView1 reloadComponent:2];
       
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

}














@end

