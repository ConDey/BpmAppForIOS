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
- (void)delegate_choose;
- (void)delegate_setTitlebarVisible:(NSString *_Nonnull)visible callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_setTitlebarBgColor:(NSString *_Nonnull)bgcolor callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_setTitlebarBgImage:(NSString *_Nonnull)bgimageUrl callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
- (void)delegate_bindRightBtn:(NSString *_Nonnull)imageUrl callbackName:(NSString *_Nonnull)callbackName callback:(void (^ _Nonnull)(NSString * _Nullable result,BOOL complete))completionHandler;
@end
