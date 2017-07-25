//
//  UserHomeSettingController.m
//  app.home
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserHomeSettingController.h"

@interface UserHomeSettingController ()

@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet UILabel *nameTextView;

@property (weak, nonatomic) IBOutlet UILabel *departmentTextView;

@end

@implementation UserHomeSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.panelView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.panelView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.panelView.layer.mask = maskLayer;
    
    self.nameTextView.text = [CurrentUser currentUser].userdetails.fullName;
    self.departmentTextView.text = [CurrentUser currentUser].userdetails.departmentName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"设置"];
}

@end
