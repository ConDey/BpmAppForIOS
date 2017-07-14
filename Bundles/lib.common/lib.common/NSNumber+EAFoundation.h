//
//  NSNumber+EAFoundation.h
//  EazyEnterprise
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNumber (EAFoundation)

+ (BOOL)isNumberNil:(NSNumber *)number;
+ (NSNumber *)getNumberWithString:(NSString *)string;
+ (NSInteger)integerValue:(NSNumber *)number;
+ (int)intValue:(NSNumber *)number;

@end
