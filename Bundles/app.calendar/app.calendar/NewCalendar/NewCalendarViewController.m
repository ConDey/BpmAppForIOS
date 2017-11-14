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
}
@property(nonatomic,retain)UILabel *descriptionLabel;//事件描述

@property(nonatomic,retain)UITextField *eventId;
@property(nonatomic,retain)UITextField *eventName;
@property(nonatomic,retain)NSString *eventType;
@property(nonatomic,retain)UITextField *location;
@property(nonatomic,retain)UITextView *eventDescription;
@property(nonatomic,retain)UITextField *startDate;
@property(nonatomic,retain)UITextField *startTime;
@property(nonatomic,retain)UITextField *endDate;
@property(nonatomic,retain)UITextField *endTime;
//时间选择器
@property(nonatomic,retain)NSData *minStartDate;
@property(nonatomic,retain)NSData *maxStartDate;
@property(nonatomic,retain)NSData *minEndDate;
@property(nonatomic,retain)NSData *maxEndDate;
@end

@implementation NewCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventType=@"临时";
    if(self.eventDescription.text.length==0){
        self.eventDescription=[[UITextView alloc]init];
    }
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
    if(self.eventName.text.length!=0&&self.eventType.length!=0&&self.location.text.length!=0&&self.eventDescription.text.length!=0&&self.startDate.text.length!=0&&self.startTime.text.length!=0&&self.endDate.text.length!=0&&self.endTime.text.length!=0){
        [self sendNewCalendar];
    }else{
        NSLog(@"输入不完整");
        NSLog(@"%@-%@-%@-%@-%@-%@-%@-%@",self.eventName.text,self.eventType,self.startDate.text,self.startTime.text,self.eventDescription.text,self.endDate.text,self.endTime.text,self.location.text);
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



//时间选择器
//选择开始时间
-(void)tapStartTime:(UITapGestureRecognizer *)sender{
    NSLog(@"选择开始时间");
    UIDatePicker *start=[[UIDatePicker alloc]init];
    start.datePickerMode=UIDatePickerModeDateAndTime;
    
   
    [self.view addSubview:start];
}
//选择结束时间
-(void)tapEndTime:(UITapGestureRecognizer *)sender{
    NSLog(@"选择结束时间");
}



@end
