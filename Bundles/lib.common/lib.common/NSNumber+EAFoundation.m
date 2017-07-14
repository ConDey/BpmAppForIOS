//
//  NSNumber+EAFoundation.m
//  EazyEnterprise
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import "NSNumber+EAFoundation.h"

@implementation NSNumber (EAFoundation)

+ (BOOL)isNumberNil:(NSNumber *)number {
    if (number == nil || [number isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

+ (NSNumber *)getNumberWithString:(NSString *)string {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    if ([format numberFromString:string]) {
        return [NSNumber numberWithInt:[string intValue]];
    }else{
        return [NSNumber numberWithInt:0];
    }
}

+ (NSInteger)integerValue:(NSNumber *)number {
    if ([NSNumber isNumberNil:number]) {
        return 0;
    }
    return [number integerValue];
}

+ (int)intValue:(NSNumber *)number {
    if ([NSNumber isNumberNil:number]) {
        return 0;
    }
    return [number intValue];
}

@end
