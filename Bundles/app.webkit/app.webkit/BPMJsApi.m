//
//  BPMJsApi.m
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "BPMJsApi.h"

@implementation BPMJsApi

- (void)close:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_close];
    }
}
//人员选择
- (void)userChoose:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (self.delegate != nil) {
        [self.delegate delegate_userChoose:(NSString *)[args valueForKey:@"selectNum"] users:(NSString *)[args valueForKey:@"users"] callback:completionHandler];
    }
}
// 标题栏隐藏和显示
- (void)setTitlebarVisible:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    if (self.delegate != nil) {
        [self.delegate delegate_setTitlebarVisible:(NSString *)[args valueForKey:@"visible"] callback:completionHandler];
    }
}

// 标题栏背景颜色
- (void)setTitlebarBgColor:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    if (self.delegate != nil) {
        [self.delegate delegate_setTitlebarBgColor:(NSString *)[args valueForKey:@"bgColor"] callback:completionHandler];
    }
}

// 标题栏背景图片
- (void)setTitlebarBgImage:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    if (self.delegate != nil) {
        [self.delegate delegate_setTitlebarBgImage:(NSString *)[args valueForKey:@"bgImgUrl"] callback:completionHandler];
    }
}

// 设置标题
- (void)setTitlebarTextView:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    if (self.delegate != nil) {
        [self.delegate delegate_setTitle:(NSString *)[args valueForKey:@"title"] fontSize:(NSString *)[args valueForKey:@"fontSize"] fontColor:(NSString *)[args valueForKey:@"fontColor"] callback:completionHandler];
    }
}

// 设置标题栏右边按钮图片并触发js事件
- (void)bindRightBtn:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    if (self.delegate != nil) {
        [self.delegate delegate_bindRightBtn:(NSString *)[args objectForKey:@"imageUrl"] callbackName:(NSString *)[args objectForKey:@"callback"] callback:completionHandler];
    }
}

// 新建窗口
- (void)startWindow:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_startWindowWithUrl:(NSString *)[args valueForKey:@"url"] title:(NSString *)[args valueForKey:@"title"]];
    }
    
}

// 新建窗口并结束当前窗口
- (void)skipWindow:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_skipWindowWithUrl:(NSString *)[args valueForKey:@"url"] title:(NSString *)[args valueForKey:@"title"]];
    }
    
}

// 选择本地图片
- (void)getImages:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (self.delegate != nil) {
        [self.delegate delegate_getLocalImagesWithMaxNum:(int)[args objectForKey:@"selectNum"] callback:completionHandler];
    }
}

// 选择本地视频
- (void)getVideos:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (self.delegate != nil) {
        [self.delegate delegate_getLocalVideosWithMaxNum:(int)[args objectForKey:@"selectNum"] callback:completionHandler];
    }
}

// 调用系统相机
- (void)getCamera:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (self.delegate != nil) {
        [self.delegate delegate_getCameraWithCallback:completionHandler];
    }
}

// 得到当前用户信息
- (void)getUser:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (self.delegate != nil) {
        [self.delegate delegate_getUserWithCallback:completionHandler];
    }
}

// 得到token
- (void)getToken:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (self.delegate != nil) {
        [self.delegate delegate_getTokenWithCallback:completionHandler];
    }
}

// Toast显示
- (void)toastShow:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_ToastShowWithToast:(NSString *)[args valueForKey:@"toast"] withType:(NSString *)[args valueForKey:@"toastType"]];
    }
}

// Alert确认框显示js
- (void)bindAlert:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler {
    if (self.delegate != nil) {
        [self.delegate delegate_bindAlertWithTitle:(NSString *)[args valueForKey:@"dialogTitle"] withInfo:(NSString *)[args valueForKey:@"dialogInfo"] withCallbackName:(NSString *)[args valueForKey:@"callback"] Callback:completionHandler];
    }
}

// show progress
- (void)progressShow:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_showProgress];
    }
}

// dismiss progress
- (void)progressCancel:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_dismissProgress];
    }
}

- (void)bindBackBtn:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    if (self.delegate != nil) {
        [self.delegate delegate_bindBackBtnWithcallbackName:(NSString *)[args objectForKey:@"callback"] callback:completionHandler];
    }
}

- (void)unbindBackBtn:(NSDictionary *)args :(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    if (self.delegate != nil) {
        [self.delegate delegate_unbindBackBtnWithCallback:completionHandler];
    }
}

@end
