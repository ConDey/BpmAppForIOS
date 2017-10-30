//
//  EAWebController.m
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "EAWebController.h"
#import "BaseDataResult.h"


@interface EAWebController()
{
    NSString *userChooseData;
}
@property (retain, nonatomic) UIProgressView *progressView;
@property (retain,nonatomic) WKWebView *wkwebview;

@end

@implementation EAWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    userChooseData=[[NSString alloc]initWithData:self.selectData encoding:NSUTF8StringEncoding];
    // 解码
    self.view.backgroundColor = [UIColor whiteColor];
    self.urltitle = [NSString decodeString:self.urltitle];
    self.url = [NSString decodeString:self.url];
    // 这里把EAZYTEC换回&
    self.url = [self.url stringByReplacingOccurrencesOfString:@"EAZYTEC" withString:@"&"];
    
    [self.view addSubview:self.webview];
    [self.view addSubview:self.progressView];
    
    
    if ([NSString isStringBlank:self.url] || [self.url containsString:@"jswebview"]) {
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
    if(userChooseData.length!=0){
    __weak DWebview * web=self.webview;
    [self.webview setJavascriptContextInitedListener:^(){
        [web callHandler:@"showUserChoose"
                    arguments:[[NSArray alloc] initWithObjects:userChooseData, nil]
            completionHandler:^(NSString * value){
                userChooseData=[[NSString alloc]init];;
            }];
    }];
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
- (void)delegate_setTitle:(NSString *)title fontSize:(NSString *)fontsize fontColor:(NSString *)fontcolor callback:(void (^ _Nonnull)(NSString * _Nullable, BOOL))completionHandler{
    
    BaseDataResult *result;

    if (![NSString isStringNil:title] && ![NSString isStringNil:fontsize] && ![NSString isStringNil:fontcolor]) {
        
        [self setTitleOfNav:title];
        UIFont *titleFont = [UIFont systemFontOfSize:[fontsize floatValue]];
        UIColor *titleColor = [UIColor colorWithHexString:fontcolor];
        [self setTitleStyleOfNavFont:titleFont Color:titleColor];
        
        result = [[BaseDataResult alloc] initWithSuccess:YES];
    }else {
        result = [[BaseDataResult alloc] initWithSuccess:NO];
    }
    NSString *resultJson = [JsonUtils dictionaryToJson:result.keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}


// 显示标题栏
- (void)delegate_setTitlebarVisible:(NSString *_Nonnull)visible callback:(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    
    BaseDataResult *result;
    
    if (![NSString isStringNil:visible]) {
        if ([visible isEqualToString:@"YES"]) {
            [self.navigationController setNavigationBarHidden:NO];
        }else if ([visible isEqualToString:@"NO"]) {
            [self.navigationController setNavigationBarHidden:YES];
        }
        result = [[BaseDataResult alloc] initWithSuccess:YES];
    }else {
        result = [[BaseDataResult alloc] initWithSuccess:NO];
    }
    NSString* resultJson = [JsonUtils dictionaryToJson:result.keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}

// 设置标题栏背景颜色
- (void)delegate_setTitlebarBgColor:(NSString *_Nonnull)bgcolor callback:(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    
    BaseDataResult *result;
    
    if (![NSString isStringNil:bgcolor]) {
        UIColor* bgColor = [UIColor colorWithHexString:bgcolor];
        [self.navigationController.navigationBar setBarTintColor:bgColor];
        
        result = [[BaseDataResult alloc] initWithSuccess:YES];
    }else {
        result = [[BaseDataResult alloc] initWithSuccess:NO];
    }
    NSString* resultJson = [JsonUtils dictionaryToJson:result.keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}
//选择人员
-(void)delegate_userChoose:(NSString *_Nonnull)useChooseNum users:(NSString *_Nonnull)userChoose callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (userChooseData.length!=0) {
         completionHandler(userChooseData, YES);
    }else {
        ChoosePeopleViewController *cs=[[ChoosePeopleViewController alloc]init];
        [self.navigationController pushViewController:cs animated:YES];

    }


}


// 设置标题栏背景图片
- (void)delegate_setTitlebarBgImage:(NSString *_Nonnull)bgimageUrl callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler {
    
    BaseDataResult *result;
    
    
    if (![NSString isStringNil:bgimageUrl]) {
        
        NSURL* imageUrl = [NSURL URLWithString:bgimageUrl];
        NSData* imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage* bgImg = [UIImage sd_imageWithData:imageData];
        [self.navigationController.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
        
        result = [[BaseDataResult alloc] initWithSuccess:YES];
    }else {
        result = [[BaseDataResult alloc] initWithSuccess:NO];
    }
    NSString* resultJson = [JsonUtils dictionaryToJson:result.keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}

// 设置右边标题栏按钮并绑定事件
- (void)delegate_bindRightBtn:(NSString *)imageUrl callbackName:(NSString *)callbackName callback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    
    BaseDataResult *result;
    
    if (![NSString isStringNil:imageUrl] && ![NSString isStringNil:callbackName]) {
        
        NSURL* btnImageUrl = [NSURL URLWithString:imageUrl];
        NSData* imageData = [NSData dataWithContentsOfURL:btnImageUrl];
        UIImage* bgImg = [UIImage sd_imageWithData:imageData];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:bgImg style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnBindAction:)];
        //self.navigationItem.rightBarButtonItem s
        
        result = [[BaseDataResult alloc] initWithSuccess:YES];
    }else {
        result = [[BaseDataResult alloc] initWithSuccess:NO];
    }
    NSString* resultJson = [JsonUtils dictionaryToJson:result.keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}

#pragma mark - additional methods
- (void)rightBtnBindAction:(id)sender {
    
}

@end
