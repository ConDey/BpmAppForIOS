//
//  MessageModel.h
//  app.msg
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageTopicModel.h"

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString* msgId;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* clickUrl;
@property (nonatomic, strong) NSString* createdTime;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) Boolean needPush ;
@property (nonatomic, assign) Boolean pushed;
@property (nonatomic, assign) Boolean canClick;

@property (nonatomic, strong) NSString* topicIcon;
@property (nonatomic, strong) NSString* topicId;
@property (nonatomic, strong) NSString* internalMsgId;
@property (nonatomic, strong) NSString* topicName;

// 给数据库使用
@property (nonatomic, assign) Boolean isRead;
@property (nonatomic, strong) NSString* username;

@end
