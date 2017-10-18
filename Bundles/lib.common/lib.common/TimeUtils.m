//
//  TimeUtils.m
//  lib.common
//
//  Created by wanyudong on 2017/10/18.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "TimeUtils.h"

@implementation TimeUtils

+ (NSString*)getNowMills {
    double mills =  [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%f", mills];
}

+ (long)getNowMillsByLong {
    double mills =  [[NSDate date] timeIntervalSince1970] * 1000;
    return mills;
}

+ (NSString*)getDate:(long)date ByDateFormate:(NSString*)dateFormat {
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:dateFormat];
    NSString* newDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(date/1000)]];
    return newDate;
}

+ (NSString*)getDateStr:(NSString*)date ByDateFormate:(NSString*)dateFormat {
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:dateFormat];
    NSString* newDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([date longLongValue]/1000)]];
    return newDate;
}

+ (NSString*) showDate:(NSDate*)date isShowHAndM:(Boolean)isShowHAndM {
    NSString* pattern = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:pattern];
    NSString* dateStr = [formatter stringFromDate:date];
    //NSString* year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    int month = [[dateStr substringWithRange:NSMakeRange(5, 2)] intValue];
    int day = [[dateStr substringWithRange:NSMakeRange(8, 2)] intValue];
    NSString* hour = [dateStr substringWithRange:NSMakeRange(11, 2)];
    NSString* minute = [dateStr substringWithRange:NSMakeRange(14, 2)];
    
    NSTimeInterval addTime = [date timeIntervalSince1970]*1000;
    long today = [self getNowMillsByLong]; // 当前时间的毫秒数
    NSDate* now = [NSDate dateWithTimeIntervalSince1970:today/1000];
    NSString* nowStr = [formatter stringFromDate:now];
    int nowDay = [[nowStr substringWithRange:NSMakeRange(8, 2)] intValue];
    NSString* result = @"";
    long l = today - addTime; // 当前时间与给定时间差的毫秒数
    long days = l/(24*60*60*1000);// 这个时间相差的天数整数，大于1天为前天的时间了，小于24小时则为昨天和今天的时间
    long hours = (l/(60*60*1000)-days*24);// 这个时间相差的减去天数的小时数
    long min=((l/(60*1000))-days*24*60-hours*60);
    //long s=(l/1000-days*24*60*60-hours*60*60-min*60);
    if (days > 0) {
        if (days>0 && days<2) {
            if (isShowHAndM) {
                result = [NSString stringWithFormat:@"前天 %@:%@", hour, minute];
            }else {
                result = @"前天";
            }
        }else {
            if (isShowHAndM) {
                result = [NSString stringWithFormat:@"%d-%d %@:%@", month, day, hour, minute];
            }else {
                result = [NSString stringWithFormat:@"%d月%d日", month, day];
            }
        }
    }else if (hours > 0){
        if (day!=nowDay) {
            if (isShowHAndM) {
                result = [NSString stringWithFormat:@"昨天 %@:%@", hour, minute];
            }else {
                result = @"昨天";
            }
        }else {
            result = [NSString stringWithFormat:@"%ld小时前", hours];
        }
    }else if (min > 0) {
        if (min > 0 && min < 1) {
            result = @"刚刚";
        }else {
            result = [NSString stringWithFormat:@"%ld分钟前", min];
        }
    }else {
        result = @"刚刚";
    }
    return result;
}

@end
