//
//  UIConstant.h
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#ifndef UIConstant_h
#define UIConstant_h

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAV_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_HEIGHT self.tabBarController.tabBar.frame.size.height

#define ONE_PX  (1 / [UIScreen mainScreen].scale)

#define UI_GRAY_COLOR  [UIColor colorWithHexString:@"#d9d9d9"]
#define UI_BLACK_COLOR  [UIColor colorWithHexString:@"#2d2d2d"]

#define UI_BLUE_COLOR  [UIColor colorWithHexString:@"#3083FB"]
#define UI_BK_COLOR  [UIColor colorWithHexString:@"#f7f8f9"]

#endif /* UIConstant_h */
