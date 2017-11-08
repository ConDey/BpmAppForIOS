//
//  UserHomeSettingController.m
//  app.home
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserHomeSettingController.h"
#import "UserAuthViewController.h"
#import <Small/Small.h>
#import "PasswordChangeController.h"
#import "AppDelegate.h"
@interface UserHomeSettingController ()
{
    CGFloat cellHeight;
    NSString *cacheSize;
    NSURL *documentsDirectoryURL;
}
@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet UILabel *nameTextView;

@property (weak, nonatomic) IBOutlet UILabel *departmentTextView;

@property (weak, nonatomic) IBOutlet UILabel *poTextView;

@property (nonatomic, strong) UILabel *cacheSizeLabel;
@end

@implementation UserHomeSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellHeight=55;
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(240);
    }];
    self.panelView.layer.cornerRadius=2.0f;
    self.panelView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.panelView.layer.shadowOffset=CGSizeMake(3, 3);
    self.panelView.layer.shadowRadius=2.0f;
    self.panelView.layer.shadowOpacity=0.2;
    
    self.nameTextView.text = [CurrentUser currentUser].userdetails.fullName;
    self.departmentTextView.text = [CurrentUser currentUser].userdetails.departmentName;
    self.poTextView.text=[CurrentUser currentUser].userdetails.position;
    
    [self.view addSubview:self.tableview];
    self.tableview.scrollEnabled=NO;
    CGFloat height=cellHeight*4;
    if(height>SCREEN_HEIGHT-self.panelView.frame.size.height){
        height=SCREEN_HEIGHT-self.panelView.frame.size.height;
    }
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.panelView.mas_bottom).mas_equalTo(25);
        make.height.mas_equalTo(height);
    }];
    [self.tableview setFrame:CGRectMake(0, self.panelView.bounds.size.height+20, self.view.bounds.size.width, self.view.bounds.size.height-self.panelView.bounds.size.height-20)];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeSet"];
 //   [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTheVersionNotification) name:@"iversion" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"设置"];
    
    documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    cacheSize = [ClearCacheUtils getCacheSizeWithFilePath:[documentsDirectoryURL absoluteString]];
    [self.tableview reloadData];
}

#pragma mark-<UITableViewDelegete,UITableViewDatasource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HomeSet"];
    UILabel *label=[[UILabel alloc]init];
    UIImageView *picView=[[UIImageView alloc]init];
    UIView *singleView=[[UIView alloc]init];//分割线
    [cell addSubview:singleView];
    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    singleView.backgroundColor=UI_DIVIDER_COLOR;
    if(indexPath.row==0){
        picView.image=[UIImage imageNamed:@"ic_setting_update.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        label.text=@"在线更新";
    }else if(indexPath.row==1){
        picView.image=[UIImage imageNamed:@"ic_setting_updatepwd.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        label.text=@"修改密码";
    }else if (indexPath.row==2){
        picView.image=[UIImage imageNamed:@"ic_setting_browser.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        label.text=@"清除缓存";
        
        if (_cacheSizeLabel == nil) {
            _cacheSizeLabel=[[UILabel alloc]init];
            if (cacheSize == nil) {
                cacheSize = @"0M";
            }
            _cacheSizeLabel.text=cacheSize;
            _cacheSizeLabel.font=FONT_14;
            _cacheSizeLabel.textColor=FONT_GRAY_COLOR;
            [_cacheSizeLabel sizeToFit];
            [cell.contentView addSubview:_cacheSizeLabel];
            [_cacheSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.contentView);
                make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
            }];
        }else {
            if (cacheSize == nil) {
                cacheSize = @"0M";
            }
            _cacheSizeLabel.text=cacheSize;
        }
        
    }else{
        UIView *singleBottomView=[[UIView alloc]init];
        [cell addSubview:singleBottomView];
        [singleBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        singleBottomView.backgroundColor=UI_DIVIDER_COLOR;
        picView.image=[UIImage imageNamed:@"ic_setting_loginout.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
        label.text=@"退出";
        
    }
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:picView];
    //layout
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.left.mas_equalTo(picView.mas_right).mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:15];
    picView.contentMode=UIViewContentModeScaleToFill;
    cell.contentView.backgroundColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=indexPath.row;
    if(row==0){
        //在线更新
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate checkUPdate];
    
    }else if (row==1){
        //改密码
        PasswordChangeController *pc=[[PasswordChangeController alloc]init];
        [self.navigationController pushViewController: pc animated:YES];
    }else if (row==2){
        //清除缓存
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定清除缓存吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureOut=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //  清除缓存操作
            if ([ClearCacheUtils  clearCacheWithFilePath:[documentsDirectoryURL absoluteString]]){
                [SVProgressHUD showSuccessWithStatus:@"缓存清除成功"];
                cacheSize = [ClearCacheUtils getCacheSizeWithFilePath:[documentsDirectoryURL absoluteString]];
                [self.tableview reloadData];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"缓存清除失败"];
            }
            
        }];
        [alert addAction:cancel];
        [alert addAction:sureOut];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //退出
        UIAlertController *alertOut=[UIAlertController alertControllerWithTitle:@"确定退出吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureOut=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [Small setUpWithComplection:^{
                UIViewController *mainController = [Small controllerForUri:@"app.home"];
                [self presentViewController:mainController animated:NO completion:nil];
            }];
        }];
        [alertOut addAction:cancel];
        [alertOut addAction:sureOut];
        [self presentViewController:alertOut animated:YES completion:nil];
    }
    
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)receiveTheVersionNotification {
    UIAlertController *versionInfo=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前版本已是最新版本。版本号：%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [versionInfo addAction:cancel];
    [self presentViewController:versionInfo animated:YES completion:nil];
}

@end

