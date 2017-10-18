//
//  PasswordChange.m
//  app.home
//
//  Created by feng sun on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "PasswordChangeController.h"
#import "UserAuthViewController.h"
#import <Small/Small.h>

@interface PasswordChangeController ()

@property(strong,nonatomic)UITextField *currentPassword;
@property(strong,nonatomic)UITextField *changedPassword;
@property(strong,nonatomic)UITextField *changedPassword2;
@property(strong,nonatomic)UIButton *bt;
@end
@implementation PasswordChangeController

-(void)viewDidLoad{
    //输入当前密码
    self.currentPassword=[[UITextField alloc]init];
    self.currentPassword.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.currentPassword];
    [self.currentPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    UIView *vc=[[UIView alloc]init];
    vc.frame=CGRectMake(0, 0, 25, 25);
    self.currentPassword.leftView=vc;
    self.currentPassword.leftViewMode=UITextFieldViewModeAlways;
    self.currentPassword.secureTextEntry=YES;
    self.currentPassword.placeholder=@"点击输入现在的密码";
    self.currentPassword.layer.borderColor=UI_GRAY_COLOR.CGColor;
    self.currentPassword.layer.borderWidth=1;
    //第一次新密码
    self.changedPassword=[[UITextField alloc]init];
    self.changedPassword.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.changedPassword];
    [self.changedPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.currentPassword.mas_bottom).mas_equalTo(50);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    UIView *cp=[[UIView alloc]init];
    cp.frame=CGRectMake(0, 0, 25, 25);
    self.changedPassword.leftView=cp;
    self.changedPassword.leftViewMode=UITextFieldViewModeAlways;
    self.changedPassword.secureTextEntry=YES;
    self.changedPassword.placeholder=@"点击输入新密码";
    self.changedPassword.layer.borderColor=UI_GRAY_COLOR.CGColor;
    self.changedPassword.layer.borderWidth=1;
    //再次确认新密码
    self.changedPassword2=[[UITextField alloc]init];
    self.changedPassword2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.changedPassword2];
    [self.changedPassword2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.changedPassword.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    UIView *cp2=[[UIView alloc]init];
    cp2.frame=CGRectMake(0, 0, 25, 25);
    self.changedPassword2.leftView=cp2;
    self.changedPassword2.leftViewMode=UITextFieldViewModeAlways;
    self.changedPassword2.secureTextEntry=YES;
    self.changedPassword2.placeholder=@"点击再次输入新密码";
    self.changedPassword2.layer.borderColor=UI_GRAY_COLOR.CGColor;
    self.changedPassword2.layer.borderWidth=1;
    
    //确认按钮
    UIButton *b=[[UIButton alloc]init];
    self.bt=b;
    [self.view addSubview:self.bt];
    [self.bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(self.changedPassword2.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(40);
    }];
    self.bt.backgroundColor=UI_BLUE_COLOR ;
    UILabel *buttonlabel=[[UILabel alloc]init];
    buttonlabel.text=@"确认修改";
    buttonlabel.textAlignment=NSTextAlignmentCenter;
    buttonlabel.textColor=[UIColor whiteColor];
    [self.bt addSubview:buttonlabel];
    [buttonlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bt.mas_centerX);
        make.centerY.equalTo(self.bt.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    //点击按钮
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToButton:)];
    [self.bt addGestureRecognizer:tap];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navDisplay=YES;
    [self setTitleOfNav:@"修改密码"];
    
}

//点击修改
-(void)tapToButton:(UITapGestureRecognizer *)sender{
    
    NSString *oldPassword=self.currentPassword.text;
    NSString *newPassword=self.changedPassword.text;
    NSString *confirmPassowrd=self.changedPassword2.text;
    NSLog(@"jiu= %@    xin= %@  er= %@",oldPassword,newPassword,confirmPassowrd);
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:oldPassword forKey:@"oldPassword"];
    [params setObject:newPassword forKey:@"newPassword"];
    [params setObject:confirmPassowrd forKey:@"confirmPassword"];
    [self httpPostRequestWithUrl:@"password/change" params:params progress:YES];
    
}







@end

