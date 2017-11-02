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

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (weak, nonatomic) id<PushReceiveDelegate> pushDelegate;

- (void)checkForUpdate;
- (void)setAlias:(NSString *)alias;


@end

