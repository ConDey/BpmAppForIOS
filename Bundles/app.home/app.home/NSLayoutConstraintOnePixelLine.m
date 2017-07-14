//
//  NSLayoutConstraintOnePixelLine.m
//  app.home
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "NSLayoutConstraintOnePixelLine.h"

@implementation NSLayoutConstraintOnePixelLine

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.constant == 1) {
        self.constant = 1 / [UIScreen mainScreen].scale;
    }
}

@end
