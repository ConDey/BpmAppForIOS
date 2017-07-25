//
//  UIImage+LGExtension.m
//  lib.common
//
//  Created by ConDey on 2017/7/15.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UIImage+LGExtension.h"
#import "UIColor+EAFoundation.h"

@implementation UIImage (LGExtension)

- (UIImage *)circleImage{
    
    UIGraphicsBeginImageContextWithOptions(self.size,NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    
    [self drawInRect:rect];
    UIImage *circleImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return circleImage;
}

+ (UIImage *)circleImageWithText:(NSString *)text size:(CGSize)size{
    
    NSDictionary *fontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGSize textSize = [text sizeWithAttributes:fontAttributes];
    CGPoint drawPoint = CGPointMake((size.width - textSize.width)/2, (size.height - textSize.height)/2);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    
    NSArray *array = [NSArray arrayWithObjects:@"#EE4542",@"#F2725E",@"#0099cc",@"#f36c60",@"#ab47bc",@"#FF943D",@"#17C295", nil];
    int index = (int)((arc4random() % 7));
    
    NSString *color = [array objectAtIndex:index];
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:color].CGColor);
    [path fill];
    [text drawAtPoint:drawPoint withAttributes:fontAttributes];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

+ (UIImage *)triangleImageWithSize:(CGSize)size tintColor:(UIColor *)tintColor{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width/2,size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path closePath];
    CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
    [path fill];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


@end
