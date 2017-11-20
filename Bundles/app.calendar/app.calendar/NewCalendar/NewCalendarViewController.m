////
////  NewCalendarViewController.m
////  app.calendar
////
////  Created by feng sun on 2017/11/17.
////  Copyright © 2017年 eazytec. All rights reserved.
////
//


#import "NewCalendarViewController.h"


@interface NewCalendarViewController ()
{
    CGFloat dsHeight;
    UIButton  *saveButton;
    UIButton  *updateButton;
    UIButton  *deleteButton;
    UIButton  *editButton;
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
    //各部分高度
    NSMutableArray *heightOfCellWithId;
}


@property(nonatomic,retain)NSMutableArray *typeList;

@property(nonatomic,retain)UITextView *eventNameField;
@property(nonatomic,retain)NSString *eventType;
@property(nonatomic,retain)UITextView *locationField;
@property(nonatomic,retain)UITextView *eventDescriptionView;
@property(nonatomic,retain)UITextView *startDateField;
@property(nonatomic,retain)UITextView *endDateField;

//
@property(nonatomic,retain)NSString *eventName;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain)NSString *eventDescription;
//选择时间
@property(nonatomic,retain)NSString *eventStartDate;
@property(nonatomic,retain)NSString *eventStartTime;
@property(nonatomic,retain)NSString *eventEndDate;
@property(nonatomic,retain)NSString *eventEndTime;

//时间选择器
@property (nonatomic,strong)UIPickerView * pickerView1;//年月日
@property (nonatomic,strong)UIPickerView * pickerView2;//时分

//时间选择器的显示范围
@property(nonatomic,retain)NSArray *year;
@property(nonatomic,retain)NSArray *mon;
@property(nonatomic,retain)NSArray *day;
@property(nonatomic,retain)NSArray *hour;
@property(nonatomic,retain)NSArray *min;
@property(nonatomic,retain)NSDate *currentTime;
@property(nonatomic,retain)UILabel *currentTimeLabel;
@property(nonatomic,retain)UILabel *titleLabel;


//显示数据
@property(nonatomic,retain)UITableView *showDataTableView;
@end

@implementation NewCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    heightOfCellWithId=[[NSMutableArray alloc]initWithObjects:@"60",@"60",@"60",@"60",@"60",@"100", nil];
    
    
    [self requestDataById];
    saveButton.hidden=NO;
    updateButton.hidden=YES;
    if(self.eventId.length!=0){
        saveButton.hidden=YES;
        self.showDataTableView.hidden=NO;
        
    }else{
        [self newAddScene];
        deleteButton.hidden=YES;
        editButton.hidden=YES;
        self.tableview.hidden=NO;
        self.showDataTableView.hidden=YES;
        self.eventType=@"临时";
        
    }
}
//新建界面
-(void)newAddScene{
   
    [self.view addSubview:self.tableview];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(380);
    }];
    
    self.tableview.backgroundColor=[UIColor whiteColor];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Calendar"];
    //保存按钮
    saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableview.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundColor: UI_BLUE_COLOR];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.textColor=[UIColor whiteColor];
    
    //更新按钮
    updateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:updateButton];
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableview.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [updateButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setBackgroundColor: UI_BLUE_COLOR];
    [updateButton setTitle:@"更新" forState:UIControlStateNormal];
    updateButton.titleLabel.textColor=[UIColor whiteColor];
}

//显示界面
-(void)showEventScene{
    self.showDataTableView=[[UITableView alloc]init];
    
    CGFloat h=0;
    for(NSString *ht in heightOfCellWithId){
        h=h+[ht floatValue];
    }
    self.showDataTableView.delegate=self;
    self.showDataTableView.dataSource=self;
    [self.view addSubview:self.showDataTableView];
    [self.showDataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(h);
        make.top.mas_equalTo(0);
    }];
    self.showDataTableView.backgroundColor=[UIColor whiteColor];
    [self.showDataTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Calendar"];
    
    //修改按钮
    editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(80);
        make.right.mas_equalTo(0);
    }];
    UIImage *imageEdit=[UIImage imageNamed:@"ic_btn_change.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UIImageView *ig=[[UIImageView alloc]initWithImage:imageEdit];
    [editButton addSubview:ig];
    [ig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(editButton.mas_centerX);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(50);
    }];
    [editButton addTarget:self action:@selector(editEvent:) forControlEvents:UIControlEventTouchUpInside];
    // [editButton setBackgroundImage:imageEdit forState:UIControlStateNormal];
    editButton.backgroundColor=[UIColor whiteColor];
    
    //删除按钮
    deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(80);
        make.left.mas_equalTo(0);
    }];
    UIImage *imageDelete=[UIImage imageNamed:@"ic_btn_delete.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
    UIImageView *ig2=[[UIImageView alloc]initWithImage:imageDelete];
    [deleteButton addSubview:ig2];
    [ig2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(deleteButton.mas_centerX);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);;
        make.width.mas_equalTo(50);
    }];
    [deleteButton addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.backgroundColor=[UIColor whiteColor];
    // [deleteButton setBackgroundImage:imageDelete forState:UIControlStateNormal];
    
    
    
}



//根据id请求数据
-(void)requestDataById{
    if(self.eventId.length==0){
        NSLog(@"NO ID");
    }else{
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSURL *URL = [NSURL URLWithString:[REQUEST_SERVICE_URL stringByAppendingString:@"schedule/detail"]];
        
        NSString *cookie = [NSString stringWithFormat:@"%@",[CurrentUser currentUser].token];
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"token"];
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:self.eventId forKey:@"id"];
        [manager GET:[NSString stringWithFormat:@"%@",URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            self.eventName=[responseObject objectForKey:@"eventName"];
            self.eventType=[responseObject objectForKey:@"eventTypeName"];
            self.location=[responseObject objectForKey:@"location"];
            self.eventDescription=[responseObject objectForKey:@"description"];
            self.eventStartDate=[responseObject objectForKey:@"startDate"];
            self.eventStartTime=[responseObject objectForKey:@"startTime"];
            
            self.eventEndDate=[responseObject objectForKey:@"endDate"];
            self.eventEndTime=[responseObject objectForKey:@"endTime"];
            
            
            self.startDateField.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventStartDate,self.eventStartTime,second];
            self.endDateField.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventEndDate,self.eventEndTime,second];
            heightOfCellWithId=[[NSMutableArray alloc]init];
            CGFloat height=[self accountHeight:self.eventName];
            [heightOfCellWithId insertObject:[NSString stringWithFormat:@"%f",height] atIndex:0];
            height=[self accountHeight:self.startDateField.text];
             [heightOfCellWithId insertObject:[NSString stringWithFormat:@"%f",height] atIndex:1];
            height=[self accountHeight:self.endDateField.text];
            [heightOfCellWithId insertObject:[NSString stringWithFormat:@"%f",height] atIndex:2];
            height=[self accountHeight:self.eventType];
            [heightOfCellWithId insertObject:[NSString stringWithFormat:@"%f",height] atIndex:3];
            height=[self accountHeight:self.location];
            [heightOfCellWithId insertObject:[NSString stringWithFormat:@"%f",height] atIndex:4];
            height=[self accountHeight:self.eventDescription];
            [heightOfCellWithId insertObject:[NSString stringWithFormat:@"%f",height] atIndex:5];
            
            NSLog(@"%@",heightOfCellWithId);
            
            
            [self showEventScene];//显示数据
            
            NSLog(@"name---%@",[responseObject objectForKey:@"eventName"]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}

-(CGFloat)accountHeight:(NSString *)text{
    NSString *str =text;
    if(text.length==0){
        return 60;
    }else{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    UIFont *font = [UIFont systemFontOfSize:14];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, CGFLOAT_MAX) options:options context:nil];
    if(rect.size.height>40){
        //初始默认textView的高度为40，cell高度为20
        if([text isEqualToString:self.eventDescription]){
            return rect.size.height+50;
        }else{
        return rect.size.height+20;
        }
    }else{
        return 60;
    }
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navDisplay=YES;
    if(self.eventId.length==0){
        [self setTitleOfNav:@"新增日程"];
    }else{
        [self setTitleOfNav:@"修改日程"];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return 6;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return [[heightOfCellWithId objectAtIndex:indexPath.row] floatValue];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Calendar"];
    if(cell!=nil){
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
            
        }
    }
    if(tableView==self.tableview){
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(indexPath.row<6){
        UIView *singleView=[[UIView alloc]init];//分割线
        [cell addSubview:singleView];
        [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        singleView.backgroundColor=UI_DIVIDER_COLOR;
        }
        //事件名称
        UILabel *titleLabel=[[UILabel alloc]init];
        [cell addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
        
        titleLabel.font=FONT_14;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        if(indexPath.row==0){
            self.eventNameField=[[UITextView alloc]init];
            self.eventNameField.delegate=self;
            self.eventNameField.font=FONT_14;
            self.eventNameField.scrollEnabled=NO;
            [cell addSubview:self.eventNameField];
            [self.eventNameField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
            }];
            titleLabel.text=@"  事件名称:";
            if(self.eventName.length==0){
                self.eventNameField.text=@"请填写事件名称";
                self.eventNameField.textColor=FONT_GRAY_COLOR;
            }else{
                self.eventNameField.text=self.eventName;
            }
            
        }else if (indexPath.row==1){
            self.startDateField=[[UITextView alloc]init];
            self.startDateField.delegate=self;
            self.startDateField.font=FONT_14;
            [cell addSubview:self.startDateField];
            [self.startDateField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
            }];
            titleLabel.text=@"  开始时间:";
            if(self.eventStartDate.length==0&&self.eventStartTime.length==0){
                self.startDateField.text=@"点击选择";
                self.startDateField.textColor=FONT_GRAY_COLOR;
            }else{
                self.startDateField.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventStartDate,self.eventStartTime,second];
            }
            UITapGestureRecognizer *tapStart=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStartTime:)];
            [self.startDateField addGestureRecognizer:tapStart];
        }else if (indexPath.row==2){
            self.endDateField=[[UITextView alloc]init];
            self.endDateField.delegate=self;
            self.endDateField.font=FONT_14;
            [cell addSubview:self.endDateField];
            [self.endDateField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
            }];
            titleLabel.text=@"  结束时间:";
            if(self.eventEndDate.length==0&&self.eventEndTime.length==0){
                self.endDateField.text=@"点击选择";
                self.endDateField.textColor=FONT_GRAY_COLOR;
            }else{
                self.endDateField.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventEndDate,self.eventEndTime,second];
            }
            UITapGestureRecognizer *tapEnd=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndTime:)];
            [self.endDateField addGestureRecognizer:tapEnd];
        }else if (indexPath.row==3){
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            titleLabel.text=@"  事件类型:";
            UILabel *typeLabel=[[UILabel alloc]init];
            [cell addSubview:typeLabel];
            [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
            }];
            typeLabel.text=self.eventType;
            typeLabel.font=FONT_14;
            
        }else if(indexPath.row==4){
            self.locationField=[[UITextView alloc]init];
            self.locationField.delegate=self;
            self.locationField.font=FONT_14;
            self.locationField.scrollEnabled=NO;
            [cell addSubview:self.locationField];
            [self.locationField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).mas_equalTo(10);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
            }];
            titleLabel.text=@"  事件地点:";
            if(self.location.length==0){
                self.locationField.text=@"请填写事件地点";
                self.locationField.textColor=FONT_GRAY_COLOR;
            }else{
                self.locationField.text=self.location;
            }
        }else{
            self.eventDescriptionView=[[UITextView alloc]init];
            self.eventDescriptionView.delegate=self;
            self.eventDescriptionView.font=FONT_14;
            self.eventDescriptionView.scrollEnabled=NO;
            [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(28);
            }];
            [cell addSubview:self.eventDescriptionView];
            [self.eventDescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.right.mas_equalTo(-10);
                make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(5);
                make.bottom.mas_equalTo(-10);
            }];
            titleLabel.text=@"  事件描述:";
            if(self.eventDescription.length==0){
                self.eventDescriptionView.text=@"事件描述";
                self.eventDescriptionView.textColor=FONT_GRAY_COLOR;
            }else{
                self.eventDescriptionView.text=self.eventDescription;
            }
            
        }
    }
    
    
    
    
    if(tableView==self.showDataTableView){
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *singleView1=[[UIView alloc]init];//分割线
        [cell addSubview:singleView1];
        [singleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        singleView1.backgroundColor=UI_DIVIDER_COLOR;
        //事件名称
        UILabel *titleLabel=[[UILabel alloc]init];
        [cell addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        titleLabel.numberOfLines=0;
        titleLabel.font=FONT_14;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        //事件内容
        UILabel *contentLabel=[[UILabel alloc]init];
        [cell addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(titleLabel.mas_right).mas_offset(10);
            make.bottom.mas_equalTo(-10);
        }];
        contentLabel.font=FONT_14;
        contentLabel.numberOfLines=0;
        contentLabel.textAlignment=NSTextAlignmentLeft;
        if(indexPath.row==0){
            titleLabel.text=@"  事件名称:";
            if(self.eventName.length!=0){
                contentLabel.text=self.eventName;
            }
        }else if(indexPath.row==1){
            titleLabel.text=@"  开始时间:";
            if(self.eventStartDate.length!=0)
            {
                contentLabel.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventStartDate,self.eventStartTime,second];
            }
        }else if(indexPath.row==2){
            titleLabel.text=@"  结束时间:";
            if (self.eventEndDate.length!=0) {
                contentLabel.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventEndDate,self.eventEndTime,second];
            }
            
        }else if(indexPath.row==3){
            titleLabel.text=@"  事件类别:";
            if (self.eventType.length!=0) {
                contentLabel.text=self.eventType;
            }
            
        }else if(indexPath.row==4){
            titleLabel.text=@"  事件地点:";
            if(self.location.length!=0){
                contentLabel.text=self.location;
            }
        }else if(indexPath.row==5){
            titleLabel.text=@"  事件描述:";
            if(self.eventDescription.length!=0){
                contentLabel.text=self.eventDescription;
            }
        }
        
        
        
        
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



//点击保存和更新
-(void)save:(UIButton *)bt{
   [self sendNewCalendar];
}

//点击修改
-(void)editEvent:(UIButton *)button{
    [self newAddScene];
    self.showDataTableView.hidden=YES;
    self.tableview.hidden=NO;
    updateButton.hidden=NO;
    saveButton.hidden=YES;
    deleteButton.hidden=YES;
    editButton.hidden=YES;
    [self.tableview reloadData];
}

//点击删除
-(void)deleteEvent:(UIButton *)button{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSURL *URL = [NSURL URLWithString:[REQUEST_SERVICE_URL stringByAppendingString:@"schedule/delete"]];
    
    NSString *cookie = [NSString stringWithFormat:@"%@",[CurrentUser currentUser].token];
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:self.eventId forKey:@"id"];
    [manager GET:[NSString stringWithFormat:@"%@",URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}



//保存
-(void)sendNewCalendar{
    
    NSMutableDictionary *paramas=[[NSMutableDictionary alloc]init];
    if(self.eventId.length==0){
        [paramas setObject:@"" forKey:@"id"];
    }else{
        [paramas setObject:self.eventId forKey:@"id"];
    }
    [paramas setObject:self.eventName forKey:@"eventName"];
    [paramas setObject:self.eventType forKey:@"eventType"];
    [paramas setObject:self.location forKey:@"location"];
    [paramas setObject:self.eventDescription forKey:@"description"];
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"点击选择"]||[textView.text isEqualToString:@"请填写事件名称"]||[textView.text isEqualToString:@"请填写事件地点"]||[textView.text isEqualToString:@"事件描述"]){
        textView.text=@"";
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if(textView==self.eventNameField){
     self.eventName=self.eventNameField.text;
    }
    if(textView==self.locationField){
    self.location=self.locationField.text;
    }
    if(textView==self.eventDescriptionView){
    self.eventDescription=self.eventDescriptionView.text;
    }
    //[self.tableview reloadData];
    [self.tableview beginUpdates];
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.tableview beginUpdates];
    [self.tableview reloadData];
     [self.tableview endUpdates];
}

//更改文本区域高度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView==self.eventNameField){
        self.eventName=self.eventNameField.text;
    }
    if(textView==self.locationField){
        self.location=self.locationField.text;
    }
    if(textView==self.eventDescriptionView){
        self.eventDescription=self.eventDescriptionView.text;
    }
    
    
    CGRect frame = textView.frame;
    CGFloat oldHeight=frame.size.height;
    if(oldHeight<40){
        oldHeight=40;
    }
    CGRect frameSave =saveButton.frame;
    float height=[self accountHeight:textView.text];
    if(textView==self.eventNameField){
        if(text){
            [heightOfCellWithId replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f",height]];
        }
    }else if(textView==self.startDateField){
        if(text){
            [heightOfCellWithId replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f",height]];
        }
    }else if (textView==self.endDateField){
        if(text){
            [heightOfCellWithId replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%f",height]];
        }
    }else if (textView==self.locationField){
        if(text){
            [heightOfCellWithId replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%f",height]];
        }
    }else if(textView==self.eventDescriptionView){
        if(text){
            [heightOfCellWithId replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%f",height]];
        }
    }
    if(textView==self.eventDescriptionView){
        height=height-40;
    }else{
        height=height-20;
    }
 
    frame.size.height = height;
    if(height>oldHeight){
        frameSave.origin.y=frameSave.origin.y+height-oldHeight;
    }
    

    
    
    CGFloat h=0;
    for(NSString *ht in heightOfCellWithId){
        h=h+[ht floatValue];
    }
    NSLog(@"输入%@",heightOfCellWithId);
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(h);
        }];
        textView.frame= frame;
        saveButton.frame=frameSave;
        updateButton.frame=frameSave;
        
       
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
    [self beginningTime];//开始当前时间
    [self addPickerDataYearAndMinAndHourAndMon];//增加年月时分信息
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
    [self beginningTimeWithXY];//控制时间选择器的初始位置
    
    
}
//时间选择器时间初始化
-(void)beginningTime{
    NSDate*date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    // 年月日获得
    comps =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay)
                       fromDate:date];
    year = [comps year];
    month = [comps month];
    day = [comps day];
    titleYear=[NSString stringWithFormat:@"%ld年",year];
    titleMon=[NSString stringWithFormat:@"%ld月",month];
    titleDay=[NSString stringWithFormat:@"%ld日",day];
    //当前的时分秒获得
    comps =[calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond)
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
        self.startDateField.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventStartDate,self.eventStartTime,second];
    }else{
        self.endDateField.text=[NSString stringWithFormat:@"%@ %@:%ld",self.eventEndDate,self.eventEndTime,second];
    }
    pickerAll.hidden=YES;
}
-(void)cancel:(UIButton *)bt{
    pickerAll.hidden=YES;
    if(isStart){
        if(self.startDateField.text==nil){
            self.startDateField.text=@"";
        }
    }else{
        if(self.endDateField.text==nil){
            self.endDateField.text=@"";
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



//获取项目种类
//-(void)getTypeListOfSchedule{
//    NSMutableArray *params=[[NSMutableArray alloc]init];
//    [self httpGetRequestWithUrl:HttpProtocolServiceScheduleTypeList  params:nil progress:nil];
//}
//
//-(void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name{
//    NSLog(@"typeList--%@",result);
//}








@end


