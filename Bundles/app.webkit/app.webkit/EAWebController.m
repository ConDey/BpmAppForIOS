//
//  EAWebController.m
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//
#import "ChooseViewController.h"
#import "EAWebController.h"

@interface EAWebController()

@property (retain, nonatomic) UIProgressView *progressView;
@property (retain,nonatomic) WKWebView *wkwebview;

@end

@implementation EAWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 解码
    self.view.backgroundColor = [UIColor whiteColor];
    self.urltitle = [NSString decodeString:self.urltitle];
    self.url = [NSString decodeString:self.url];
    // 这里把EAZYTEC换回&
    self.url = [self.url stringByReplacingOccurrencesOfString:@"EAZYTEC" withString:@"&"];
    
    [self.view addSubview:self.webview];
    [self.view addSubview:self.progressView];
    
    
    if ([NSString isStringBlank:self.url]) {
        NSString *htmlPath = [self.bundle pathForResource:@"jswebview"
                                                   ofType:@"html"];
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
        
        [self.webview loadRequest:request];
        
    } else {
        NSURL *url = [NSURL URLWithString:self.url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSString *cookie = [NSString stringWithFormat:@"token=%@",[CurrentUser currentUser].token];
        [request addValue:cookie forHTTPHeaderField:@"Cookie"];
        [self.webview loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setTitleOfNav:self.urltitle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.wkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (DWebview *)webview {
    if(_webview == nil) {
        CGRect bounds = self.view.bounds;
        _webview = [[DWebview alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
        _webview.backgroundColor= UI_BK_COLOR;
        
        _wkwebview = [_webview getXWebview];
        
        _jsApi = [[BPMJsApi alloc] init];
        _jsApi.delegate = self;
        _webview.JavascriptInterfaceObject= _jsApi;
        [_wkwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
        
    }
    return _webview;
}

- (UIProgressView *)progressView {
    if(_progressView == nil) {
        CGRect bounds = self.view.bounds;
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width,ONE_PX)];
        _progressView.progressTintColor= UI_BLUE_COLOR;//设置已过进度部分的颜色
        _progressView.trackTintColor= [UIColor whiteColor];//设置未过进度部分的颜色
        
    }
    return _progressView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.wkwebview) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkwebview.estimatedProgress animated:YES];
        if(self.wkwebview.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark BPMJsApiDelegate

// 关闭此页面
- (void)delegate_close {
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置标题
- (void)delegate_setTitle:(NSString *_Nonnull)title {
    [self setTitleOfNav:title];
    
}
//人员选择
-(void)delegate_choose{
    ChooseViewController *cs=[[ChooseViewController alloc]init];
    [self.navigationController pushViewController:cs animated:YES];
}
@end
