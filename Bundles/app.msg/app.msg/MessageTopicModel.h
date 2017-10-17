//
//  MessageTopicModel.h
//  app.msg
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTopicModel : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* topicId;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* topic;

//数据库使用
@property (nonatomic, assign) int unReadMessages;
@property (nonatomic, strong) NSString* latestMessage;
@property (nonatomic, strong) NSString* latestUpdateTime;

@end
