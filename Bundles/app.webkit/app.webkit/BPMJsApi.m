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

@end
