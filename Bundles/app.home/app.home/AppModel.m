//
//  AppModel.m
//  app.home
//
//  Created by wanyudong on 2017/10/20.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

// 设置属性名与字典key之间的映射关系
+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{
             @"appId" : @"id"
             };
}

@end
