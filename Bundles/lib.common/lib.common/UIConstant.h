//
//  UIConstant.h
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#ifndef UIConstant_h
#define UIConstant_h

#define RGB_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGB_ACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

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

// 分割线颜色
#define UI_DIVIDER_COLOR  [UIColor colorWithHexString:@"#e0e0e0"]
#define LIGHT_GRAY_COLOR RGB_COLOR(246, 246, 246)

#define FONT_GRAY_COLOR      [UIColor colorWithHexString:@"#8f8f8f"]

// Font
#define FONT_12       [UIFont systemFontOfSize:12.0]
#define FONT_14       [UIFont systemFontOfSize:14.0]
#define FONT_16       [UIFont systemFontOfSize:16.0]
#define FONT_18       [UIFont systemFontOfSize:18.0]

// GCD
//GCD - 一次性执行
#define DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

#endif /* UIConstant_h */
