//
//  FMDBHelper.h
//  lib.common
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageTopicModel.h"
#import "MessageModel.h"

extern NSString *const FMDBUserDetailsTableName; // 用户登录表名

@interface FMDBHelper : NSObject

+ (instancetype)sharedInstance; // 单例对象

@property (nonatomic,readwrite,retain)  FMDatabase *database;

// UserDetail
- (void)inertUserDetailsTableWithUserDetails:(UserDetails *)userdetails;  // 把数据插入至用户信息表
- (UserDetails *)selectUserdetailsWithUsername:(NSString *)username; // 根据用户名查询用户信息模型
- (void)removeUserDetailsByUsername:(NSString*)username; // 清楚当前用户登录信息
- (void)setLastRequestTime:(NSString*)lastRequestTime ByUserName:(NSString*)username; // 设置用户的上次请求时间
- (NSString*)getLastRequestTimeByUsername:(NSString*)username withDateFormat:(Boolean)isDateFormat; // 获得上次请求时间

// CommonParams
- (void)savePushDeviceToken:(NSString*)deviceToken; // 存入devicetoken
- (NSString*)getPushDeviceToken; // 获得devicetokrn
- (void)updateIsRefresh:(NSString*)isRefresh; // 更新是否需要刷新标识
- (NSString*)getIsRefresh; // 获得是否需要刷新标识

// Topic
- (void)insetTopicIntoDB:(NSMutableArray<MessageTopicModel*>*)topics; // 插入Topic到Topic表中
- (NSMutableArray<MessageTopicModel*>*)selectTopicFromDB; // 查询所有Topic
- (void)updateLatestMessageTimeWithTopicId:(NSString*)topicId withLatestTime:(NSString*)latestTime; // 更新最新的message时间
- (NSMutableArray<MessageTopicModel*>*)getTopicById:(NSString*)topicId; // 根据当前topicId查询topic

// Message
- (void)insertMessageIntoDB:(NSMutableArray<MessageModel*>*)messages; // 存入消息到数据库中
- (void)updateMessageReadState:(NSString*)topicId; // 更新消息已读状态
- (NSMutableArray<MessageModel*>*)selectMessageByPage:(NSString*)topicId pageIndex:(int)pageIndex pageSize:(int)pageSize; // 分页查询消息

@end
