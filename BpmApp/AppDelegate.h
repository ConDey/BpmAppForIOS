//
//  AppDelegate.h
//  BpmApp
//
//  Created by ConDey on 2017/6/21.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "iVersion.h"
#import "com_eazytec_bpm_lib_common/lib.common.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, iVersionDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (weak, nonatomic) id<PushReceiveDelegate> pushDelegate;

- (void)checkUPdate;
- (void)setAlias:(NSString *)alias;


@end

