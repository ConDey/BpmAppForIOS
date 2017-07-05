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
