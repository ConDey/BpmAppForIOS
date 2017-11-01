//
//  UserAuthViewController.m
//  app.home
//
//  Created by ConDey on 2017/7/5.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserAuthViewController.h"
#import "UserHomeNavController.h"
#import "UserHomeTabController.h"
#import "ImageModel.h"
#import "UMessage.h"

@interface UserAuthViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userBgIv;

@property (weak, nonatomic) IBOutlet UIView *userAuthPanel;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *authButton;

@end

@implementation UserAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userAuthPanel.layer.shadowColor = [UIColor grayColor].CGColor;
    self.userAuthPanel.layer.shadowOffset = CGSizeMake(4,4);
    self.userAuthPanel.layer.shadowOpacity = 0.5;
    self.userAuthPanel.layer.shadowRadius = 3;
    
    self.userNameTextField.layer.borderColor = UI_GRAY_COLOR.CGColor;
    self.userNameTextField.layer.borderWidth = 1;
    self.userNameTextField.layer.cornerRadius = 0;
    self.userNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 10.0, 20.0)];
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTextField.delegate = self;
    
    self.passwordTextField.layer.borderColor = UI_GRAY_COLOR.CGColor;
    self.passwordTextField.layer.borderWidth = 1;
    self.passwordTextField.layer.cornerRadius = 0;
    self.passwordTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 10.0, 20.0)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    
    [self.authButton addTarget:self action:@selector(userWillLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboadWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSDictionary* dict = @{
                           @"token" : [CurrentUser defaultToken],
                           };
    
    [self httpPostRequestWithUrl:HttpProtocolServiceCommonConfig params:dict progress:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userNameTextField.text = [[CurrentUser currentUser] username];
    self.passwordTextField.text = [[CurrentUser currentUser] password];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
 * 用户点击登录后的逻辑
 */
- (void)userWillLogin:(UIButton *)button {
    
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([NSString isStringBlank:username]) {
        [SVProgressHUD showErrorWithStatus:@"用户名不得为空"];
        return;
    }
    
    if ([NSString isStringBlank:password]) {
        [SVProgressHUD showErrorWithStatus:@"密码不得为空"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:username  forKey:@"username"];
    [params setObject:password  forKey:@"password"];
    [params setObject:@"ios" forKey:@"clientType"];
    
    [self httpPostRequestWithUrl:HttpProtocolServiceUserLogin params:params progress:YES];
    
}

- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    
    if (name == HttpProtocolServiceCommonConfig) {
        
        ImageModel* model = [ImageModel mj_objectWithKeyValues:result];
        if (model.success) {
            if (model.loginBackgroundImg != nil && ![model.loginBackgroundImg isEqualToString:@""]) {
                NSString* imgPath = [NSString stringWithFormat:@"%@/%@", REQUEST_URL, model];
                
                [_userBgIv sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"bg_auth" inBundle:self.bundle compatibleWithTraitCollection:nil]];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:model.errorMsg];
        }
        
    }
    
    if (name == HttpProtocolServiceUserLogin) {
    
        UserDetails *userdetail = [[UserDetails alloc]init];
        
        userdetail.username = self.userNameTextField.text;
        userdetail.password = self.passwordTextField.text;
        userdetail.fullName = [result objectForKey:@"fullName"];
        userdetail.email = [result objectForKey:@"email"];
        userdetail.mobile = [result objectForKey:@"mobile"];
        userdetail.departmentName = [result objectForKey:@"departmentName"];
        userdetail.position = [result objectForKey:@"position"];
        NSString *token = [result objectForKey:@"token"];
        [[CurrentUser currentUser] updateWithUserDetails:userdetail Token:token];
        
        [UMessage setAlias:@"admin" type:kUMessageAliasTypeSina response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (responseObject) {
                NSLog(@"ADD_ALIAS_SUCCESS");
            }else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
        
//        [UMessage setAlias:userdetail.username type:@"BPM" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//            if (responseObject) {
//                NSLog(@"ADD_ALIAS_SUCCESS");
//            }else {
//                NSLog(@"Error: %@", error.localizedDescription);
//            }
//        }];
        // Push 添加别名(先remove再add）
//        [UMessage removeAlias:userdetail.username type:@"BPM" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//            if (responseObject) {
//                NSLog(@"ADD_ALIAS_SUCCESS");
//            }
//        }];
        
        UserHomeTabController *tab = [[UserHomeTabController alloc]init];
        UserHomeNavController *nav = [[UserHomeNavController alloc]initWithRootViewController:tab];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

#pragma mark - TextViewDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - 键盘注册事件

- (void)keyboadWillShow:(NSNotification *)note{
    CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat offY = keyboardSize.height - (SCREEN_HEIGHT - self.authButton.frame.origin.y + 25);
    if (offY < 0) { return;}
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0.0f, -offY, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
@end
