//
//  UIImage+LGExtension.h
//  lib.common
//
//  Created by ConDey on 2017/7/15.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LGExtension)

// 生成一张如钉钉头像的图片
+ (UIImage *)circleImageWithText:(NSString *)text size:(CGSize)size;


// 生成一张倒三角图片
+ (UIImage *)triangleImageWithSize:(CGSize)size tintColor:(UIColor *)tintColor;

@end
