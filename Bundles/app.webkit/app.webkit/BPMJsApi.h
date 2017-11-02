//
//  BPMJsApi.h
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BPMJsApiDelegate;

@interface BPMJsApi : NSObject

@property(nullable, nonatomic,weak) id<BPMJsApiDelegate> delegate;

@end

@protocol BPMJsApiDelegate <NSObject>

- (void)delegate_close;
- (void)delegate_setTitle:(NSString *_Nonnull)title fontSize:(NSString *_Nonnull)fontsize fontColor:(NSString *_Nonnull)fontcolor callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
//-(void)delegate_userChoose:(NSString *_Nonnull)userChooseNum users:(NSString *_Nonnull)userChooseData callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
-(void)delegate_userChoose:(NSString *_Nonnull)useChooseNum users:(NSString *_Nonnull)userChoose callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_setTitlebarVisible:(NSString *_Nonnull)visible callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_setTitlebarBgColor:(NSString *_Nonnull)bgcolor callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_setTitlebarBgImage:(NSString *_Nonnull)bgimageUrl callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_bindRightBtn:(NSString *_Nonnull)imageUrl callbackName:(NSString *_Nonnull)callbackName callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_startWindowWithUrl:(NSString *_Nonnull)url title:(NSString *_Nonnull)title;
- (void)delegate_skipWindowWithUrl:(NSString *_Nonnull)url title:(NSString *_Nonnull)title;
- (void)delegate_getLocalImagesWithMaxNum:(int)maxNum callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_getLocalVideosWithMaxNum:(int)maxNum callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_getCameraWithCallback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_getUserWithCallback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_getTokenWithCallback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_ToastShowWithToast:(NSString *_Nonnull)toast withType:(NSString *_Nonnull)type;
- (void)delegate_bindAlertWithTitle:(NSString *_Nonnull)title withInfo:(NSString *_Nonnull)info withCallbackName:(NSString *_Nonnull)name Callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_showProgress;
- (void)delegate_dismissProgress;
- (void)delegate_bindBackBtnWithcallbackName:(NSString *_Nonnull)callbackName callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_unbindBackBtnWithCallback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
@end
