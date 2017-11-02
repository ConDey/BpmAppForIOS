//
//  ViewController.m
//  BpmApp
//
//  Created by ConDey on 2017/6/21.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "ViewController.h"
#import <Small/Small.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *bgimageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    bgimageview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:bgimageview];
    
    [Small setBaseUri:@"http://"];
    [Small setUpWithComplection:^{
        UIViewController *mainController = [Small controllerForUri:@"app.home"];
        [self presentViewController:mainController animated:NO completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
