//
//  EAWebController.m
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "EAWebController.h"
#import "BaseDataResult.h"
#import "ListDataResult.h"
#import "UserDataResult.h"
#import "TokenDataResult.h"

typedef void (^ CommonCompletionHandler)(NSString * _Nullable result,BOOL complete);

@interface EAWebController() <LGPhotoPickerViewControllerDelegate>
{
    NSString *userChooseData;
    NSString *rightBtnCallbackName;
    NSString *backBtnCallbackName;
    CommonCompletionHandler commonHandler;
    Boolean isBindBackBtn;
    NSString* mfileName;
    
}
@property (retain, nonatomic) UIProgressView *progressView;
@property (retain, nonatomic) WKWebView *wkwebview;

@property (nonatomic, assign) LGShowImageType showType;

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
    
    if ([NSString isStringBlank:self.url] || [self.url containsString:@"jswebview"]) {
        NSString *htmlPath = [self.bundle pathForResource:@"jswebview"
                                                   ofType:@"html"];
        NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
        
        [self.webview loadRequest:request];
        
    } else {
        NSURL *url = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request]; // 清除缓存
        NSString *cookie = [NSString stringWithFormat:@"%@",[CurrentUser currentUser].token];
        [request addValue:cookie forHTTPHeaderField:@"token"];
        NSLog(@"%@", request.allHTTPHeaderFields);

//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//
//            if (connectionError == nil) {
//                NSLog(@"%",data.length);
//            }
//
//        }];
        [self.webview loadRequest:request];
    }
}

// webview 回调函数
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    // 在url不为nil时重新加载防止白屏现象
    [webView reload];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Err:%@",error);
}

- (void)doNavigationLeftBarButtonItemAction:(UIBarButtonItem *)item {
    if (isBindBackBtn) {
        if (![backBtnCallbackName isEqualToString:@""]) {
            [_webview callHandler:backBtnCallbackName arguments:nil completionHandler:nil];
        }
    }else {
        [super doNavigationLeftBarButtonItemAction:item];
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

// 解除监听最好在dealloc中，避免出现添加监听与解除的次数不一致
- (void)dealloc{
    [self.wkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
    NSString *resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    
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
    NSString* resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    
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
    NSString* resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}
//选择人员
-(void)delegate_userChoose:(NSString *_Nonnull)useChooseNum users:(NSString *_Nonnull)userChoose callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (userChooseData.length!=0) {
        NSDictionary *selectUser=[[NSDictionary alloc]initWithObjectsAndKeys:userChoose,@"users",@(1),@"success",@"",@"errorMsg" ,nil];
        NSData *tempData=[NSJSONSerialization dataWithJSONObject:selectUser options:NSJSONWritingPrettyPrinted error:nil ];
         completionHandler([[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding], YES);
    }else {
       UserChooseDataViewController *cs=[[UserChooseDataViewController alloc]init];
        cs.userDelegate = self;
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
    NSString* resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    
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
        rightBtnCallbackName = callbackName;
        
        result = [[BaseDataResult alloc] initWithSuccess:YES];
    }else {
        result = [[BaseDataResult alloc] initWithSuccess:NO];
    }
    NSString* resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}

// 新建窗口
- (void)delegate_startWindowWithUrl:(NSString *)url title:(NSString *)title {
    [self startWebViewWindowWithUrl:url title:title];
}

// 新建窗口并结束当前窗口
- (void)delegate_skipWindowWithUrl:(NSString *)url title:(NSString *)title {
    [self skipWebViewWindowWithUrl:url title:title];
}

// 选择本地图片
- (void)delegate_getLocalImagesWithMaxNum:(int)maxNum callback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = maxNum;   // 最多能选9张图片
    pickerVc.delegate = self;
    self.showType = LGShowImageTypeImagePicker;
    [pickerVc showPickerVc:self];
    
    commonHandler = completionHandler;
    
}

// 选择本地视频
- (void)delegate_getLocalVideosWithMaxNum:(int)maxNum callback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
    pickerVc.status = PickerViewShowStatusVideo;
    pickerVc.maxCount = maxNum;   // 最多能选9个视频
    pickerVc.delegate = self;
    self.showType = LGShowImageTypeImagePicker;
    [pickerVc showPickerVc:self];
    
    commonHandler = completionHandler;
}

// 调用系统相机
- (void)delegate_getCameraWithCallback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 1;
    // 单拍
    cameraVC.cameraType = ZLCameraSingle;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
         ZLCamera *canamerPhoto = cameras[0];
         UIImage *image = canamerPhoto.photoImage;
        // 保存拍摄的图片到系统相册
        //UIImageWriteToSavedPhotosAlbum(image, self, @selector(), nil);
        __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              
                              NSMutableArray *urls = [[NSMutableArray alloc] init];
                              [urls addObject:assetURL.absoluteString];
                              
                              ListDataResult *result = [[ListDataResult alloc] initWithSuccess:YES withUrls:urls];
                              NSString *resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
                              completionHandler(resultJson, YES);
                              
                          }];
    };
    [cameraVC showPickerVc:self];
}

// 当前用户信息
- (void)delegate_getUserWithCallback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    UserDetails *userDetail = [[CurrentUser currentUser] userdetails];
    UserDataResult *result;
    if (userDetail == nil) {
        result = [[UserDataResult alloc] initWithSuccess:NO withUserDetails:nil];
    }else {
        result = [[UserDataResult alloc] initWithSuccess:YES withUserDetails:userDetail];
    }
    NSString *resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    completionHandler(resultJson, YES);
}

// token
- (void)delegate_getTokenWithCallback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    NSString *token = [[CurrentUser currentUser] token];
    TokenDataResult *result;
    if (token == nil || [token isEqualToString:@""]) {
        result = [[TokenDataResult alloc] initWithSuccess:NO withToken:@""];
    }else {
        result = [[TokenDataResult alloc] initWithSuccess:YES withToken:token];
    }
    NSString *resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    completionHandler(resultJson, YES);
}

// Toast显示
- (void)delegate_ToastShowWithToast:(NSString *)toast withType:(NSString *)type {
    
    if (type == nil || toast == nil) {
        [SVProgressHUD showWithStatus:@"参数设置错误"];
    }else {
    
        if ([type isEqualToString:@"info"]) {
            [SVProgressHUD showInfoWithStatus:toast];
        }else if ([type isEqualToString:@"error"]) {
            [SVProgressHUD showErrorWithStatus:toast];
        }else if ([type isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:toast];
        }else {
            //[SVProgressHUD addGestureToDismiss];
            [SVProgressHUD showWithStatus:toast];
        }
    }
}

// 绑定alert
- (void)delegate_bindAlertWithTitle:(NSString *)title withInfo:(NSString *)info withCallbackName:(NSString *)name Callback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    if (title == nil || info == nil || name == nil) {
        [SVProgressHUD showWithStatus:@"参数设置错误"];
    }else {
        UIAlertController *alert   = [UIAlertController alertControllerWithTitle:title message:info preferredStyle:UIAlertControllerStyleAlert];
        // 加入取消按钮
        UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:canelAction];
        // 加入确认按钮
        UIAlertAction *sureAction   = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             if (![name isEqualToString:@""]) {
                 [_webview callHandler:name arguments:nil completionHandler:nil];
             }
        }];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 显示progress
- (void)delegate_showProgress {
    //[SVProgressHUD addGestureToDismiss];
    [SVProgressHUD showWithStatus:@"加载中..."];
}


// 隐藏progress
- (void)delegate_dismissProgress {
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

// 绑定返回键
- (void)delegate_bindBackBtnWithcallbackName:(NSString *)callbackName callback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    BaseDataResult *result;
    
    if (![NSString isStringNil:callbackName]) {
        backBtnCallbackName = callbackName;
        commonHandler = completionHandler;
        isBindBackBtn = YES;
        
        result = [[BaseDataResult alloc] initWithSuccess:YES];
    }else {
        result = [[BaseDataResult alloc] initWithSuccess:NO];
    }
    NSString* resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    
    completionHandler(resultJson, YES);
    
    return;
}

// 解绑返回键
- (void)delegate_unbindBackBtnWithCallback:(void (^)(NSString * _Nullable, BOOL))completionHandler {
    isBindBackBtn = NO;
    BaseDataResult *result = [[BaseDataResult alloc] initWithSuccess:YES];
    NSString* resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    completionHandler(resultJson, YES);
}

#pragma mark - additional methods
// 右边按钮点击事件
- (void)rightBtnBindAction:(id)sender {
    if (![rightBtnCallbackName isEqualToString:@""]) {
        [_webview callHandler:rightBtnCallbackName arguments:nil completionHandler:nil];
    }
}

// 新建webview的回调方法
- (void)startWebViewWindowWithUrl:(NSString *)url title:(NSString *)title {
    
    if ([url hasPrefix:@"http:"] || [url hasPrefix:@"https:"] || [url hasPrefix:@"file:"]) {
        url = [NSString encodeToPercentEscapeString:url];
    } else {
        url = [NSString encodeToPercentEscapeString:[NSString stringWithFormat:@"%@%@",REQUEST_SERVICE_URL ,url]];
    }
    
    NSString *allurl = [NSString stringWithFormat:@"app.webkit?url=%@&urltitle=%@", url, [NSString encodeString:title]] ;
    [Small openUri:allurl fromController:self];
}

// 新建webview的回调方法并结束当前窗口
- (void)skipWebViewWindowWithUrl:(NSString *)url title:(NSString *)title {
    
    if ([url hasPrefix:@"http:"] || [url hasPrefix:@"https:"] || [url hasPrefix:@"file:"]) {
        url = [NSString encodeToPercentEscapeString:url];
    } else {
        url = [NSString encodeToPercentEscapeString:[NSString stringWithFormat:@"%@%@",REQUEST_SERVICE_URL ,url]];
    }
    
    NSString *allurl = [NSString stringWithFormat:@"app.webkit?url=%@&urltitle=%@", url, [NSString encodeString:title]] ;

    [Small openUri:allurl fromController:self];
    
    // 移除当前视图
    NSMutableArray* vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    if ([vcArr count] >= 2) {
        [vcArr removeObjectAtIndex:([vcArr count]-2)];
    }
    self.navigationController.viewControllers = vcArr;
    
}

#pragma mark - LGPhotoPickerViewControllerDelegate

// 选择图片等回调方法
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    /*
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
     NSMutableArray *thumbImageArray = [NSMutableArray array];
     NSMutableArray *originImage = [NSMutableArray array];
     NSMutableArray *fullResolutionImage = [NSMutableArray array];
     
     for (LGPhotoAssets *photo in assets) {
     //缩略图
     [thumbImageArray addObject:photo.thumbImage];
     //原图
     [originImage addObject:photo.originImage];
     //全屏图
     [fullResolutionImage addObject:fullResolutionImage];
     }
     */
    
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (LGPhotoAssets* asset in assets) {
        [urls addObject:asset.assetURL.absoluteString];
    }
    
    ListDataResult *result = [[ListDataResult alloc] initWithSuccess:YES withUrls:urls];
    NSString* resultJson = [JsonUtils dictionaryToJson:result.mj_keyValues];
    commonHandler(resultJson, YES);
}

// 点击 progress 消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

-(void)sendSelectData:(NSDictionary *)data{
    NSDictionary  *allSelectData=data;
    //人员选择数据
    if(allSelectData!=nil){
        NSData *selectData=[NSJSONSerialization dataWithJSONObject:allSelectData options:NSJSONWritingPrettyPrinted error:nil ];
        userChooseData=[[NSString alloc]initWithData:selectData encoding:NSUTF8StringEncoding];
    }
        __weak DWebview * web=self.webview;
        //数据转为string
        NSString *selectNum=[NSString stringWithFormat:@"%ld",[[allSelectData objectForKey:@"users"] count]];
        NSDictionary *selectUserData=[allSelectData objectForKey:@"users"];
        NSData *select=[NSJSONSerialization dataWithJSONObject:selectUserData options:NSJSONWritingPrettyPrinted error:nil ];
        NSString *str=[[NSString alloc]initWithData:select encoding:NSUTF8StringEncoding];
        
       [web callHandler:@"showUserChoose"
                   arguments:[[NSArray alloc] initWithObjects:selectNum,str,nil]
           completionHandler:^(NSString * value){
               userChooseData=[[NSString alloc]init];
           
        }];
    
}

#pragma mark 获取指定URL的MIMEType类型
- (NSString *)mimeType:(NSURL *)url
{
    //1NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2NSURLConnection
    
    //3 在NSURLResponse里，服务器告诉浏览器用什么方式打开文件。
    
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

@end
