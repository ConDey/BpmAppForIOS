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

-(void)delegate_close;
-(void)delegate_setTitle:(NSString *_Nonnull)title;
-(void)delegate_choose;
@end
