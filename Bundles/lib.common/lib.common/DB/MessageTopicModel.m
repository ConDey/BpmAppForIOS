//
//  MessageTopicModel.m
//  app.msg
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "MessageTopicModel.h"

@implementation MessageTopicModel

// 设置属性名与字典key之间的映射关系
+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{
             @"topicId" : @"id"
             };
}

@end
