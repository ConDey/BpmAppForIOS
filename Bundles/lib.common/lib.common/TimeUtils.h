//
//  TimeUtils.h
//  lib.common
//
//  Created by wanyudong on 2017/10/18.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtils : NSObject

// 获取当前时间戳
+ (NSString*)getNowMills;

+ (long)getNowMillsByLong;

+ (NSString*)getDate:(long)date ByDateFormate:(NSString*)dateFormat;

+ (NSString*)getDateStr:(NSString*)date ByDateFormate:(NSString*)dateFormat;

// 时间格式转换
+ (NSString*) showDate:(NSDate*)date isShowHAndM:(Boolean)isShowHAndM;

@end
