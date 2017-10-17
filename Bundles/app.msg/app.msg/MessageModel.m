//
//  MessageModel.m
//  app.msg
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

// 设置属性名与字典key之间的映射关系
+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{
             @"msgId" : @"id"
             };
}

+ (NSDictionary*) mj_objectClassInArray {
    return @{
             @"topicObject" : @"MessageTopicModel"
             };
}

@end
