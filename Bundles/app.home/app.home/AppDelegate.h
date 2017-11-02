//
//  AppDelegate.h
//  app.home
//
//  Created by wanyudong on 2017/11/1.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#ifndef AppDelegate_h
#define AppDelegate_h

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)checkForUpdate;
- (void)setAlias:(NSString *)alias;

@end


#endif /* AppDelegate_h */
