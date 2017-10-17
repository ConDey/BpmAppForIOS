//
//  FMDBHelper.m
//  lib.common
//
//  Created by wanyudong on 2017/10/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "FMDBHelper.h"

NSString *const FMDBCommonParamsTableName = @"EWK_COMMON_PARAMS";
NSString *const FMDBUserDetailsTableName = @"EWK_USER_DETAILS";
NSString *const FMDBTopicTableName = @"EWK_TOPIC";
NSString *const FMDBMessageTableName = @"EWK_MESSAGE";
static NSString *const kDatabaseName = @"eazytec.ework.db"; // 数据库的名称

@interface FMDBHelper ()

@end

@implementation FMDBHelper

static FMDBHelper *_instance;

+ (instancetype)sharedInstance {
    DISPATCH_ONCE_BLOCK(^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    DISPATCH_ONCE_BLOCK(^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

// 数据库
- (FMDatabase *)database {
    if (_database == nil) {
        _database = [FMDatabase databaseWithPath:self.databaseName];
        if([_database open]){
            [self createOrUpdateTable:_database];
            //[_database close];
        }
    }
    return _database;
}

- (NSString *)databaseName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"PTAH--%@", [path stringByAppendingPathComponent:kDatabaseName]);
    return [path stringByAppendingPathComponent:kDatabaseName];
}

/// 创建或更新数据库，这个方法可能会被频繁的维护
- (void)createOrUpdateTable:(FMDatabase *)database {
    
    // 创建用户信息表
    NSMutableString *createUserDetailsTableSQL = [[NSMutableString alloc]initWithString:
                                                  @"create table if not exists "];
    [createUserDetailsTableSQL appendString:FMDBUserDetailsTableName];
    [createUserDetailsTableSQL appendString:@"( "];
    [createUserDetailsTableSQL appendString:@"id integer primary key autoincrement,"];
    [createUserDetailsTableSQL appendString:@"username varchar(50),"];
    [createUserDetailsTableSQL appendString:@"password varchar(100),"];
    [createUserDetailsTableSQL appendString:@"fullname varchar(100),"];
    [createUserDetailsTableSQL appendString:@"orgfullname varchar(200),"];
    [createUserDetailsTableSQL appendString:@"position varchar(200),"];
    [createUserDetailsTableSQL appendString:@"email varchar(100),"];
    [createUserDetailsTableSQL appendString:@"mobile varchar(100),"];
    [createUserDetailsTableSQL appendString:@"photoserviceurl varchar(200),"];
    [createUserDetailsTableSQL appendString:@"createTime varchar(100),"];
    [createUserDetailsTableSQL appendString:@"lastrequesttime varchar(100)"];
    [createUserDetailsTableSQL appendString:@")"];
    [database executeUpdate:createUserDetailsTableSQL];
    
    // 创建通用参数表
    NSMutableString *createCommonParamsTableSQL = [[NSMutableString alloc] initWithString:@"create table if not exists "];
    [createCommonParamsTableSQL appendString:FMDBCommonParamsTableName];
    [createCommonParamsTableSQL appendString:@"( "];
    [createCommonParamsTableSQL appendString:@"common_key varchar(50), "];
    [createCommonParamsTableSQL appendString:@"common_value varchar(50) "];
    [createCommonParamsTableSQL appendString:@")"];
    [database executeUpdate:createCommonParamsTableSQL];
    // 初始化数据库数据
    
    [self initDBCommonParamsDeviceToken];
    [self initDBCommonParamsIsRefresh];
    
    // 创建Topic表
    NSMutableString* createTopicTableSQL = [[NSMutableString alloc] initWithString:@"create table if not exists "];
    [createTopicTableSQL appendString:FMDBTopicTableName];
    [createTopicTableSQL appendString:@"( "];
    [createTopicTableSQL appendString:@"id integer primary key autoincrement, "];
    [createTopicTableSQL appendString:@"topic_id varchar(200), "];
    [createTopicTableSQL appendString:@"username varchar(200), "];
    [createTopicTableSQL appendString:@"icon varchar(200), "];
    [createTopicTableSQL appendString:@"topic varchar(200), "];
    [createTopicTableSQL appendString:@"update_time varchar(200) "];
    [createTopicTableSQL appendString:@")"];
    [database executeUpdate:createTopicTableSQL];
    
    // 创建Message表
    NSMutableString* createMessageTableSQL = [[NSMutableString alloc] initWithString:@"create table if not exists "];
    [createMessageTableSQL appendString:FMDBMessageTableName];
    [createMessageTableSQL appendString:@"( "];
    [createMessageTableSQL appendString:@"id integer primary key autoincrement, "];
    [createMessageTableSQL appendString:@"message_id varchar(200), "];
    [createMessageTableSQL appendString:@"content varchar(200), "];
    [createMessageTableSQL appendString:@"clickUrl varchar(200), "];
    [createMessageTableSQL appendString:@"gmtCreate varchar(200), "];
    [createMessageTableSQL appendString:@"title varchar(200), "];
    [createMessageTableSQL appendString:@"topic varchar(200), "];
    [createMessageTableSQL appendString:@"needPush varchar(200), "];
    [createMessageTableSQL appendString:@"toemp varchar(200), "];
    [createMessageTableSQL appendString:@"pushed varchar(200), "];
    [createMessageTableSQL appendString:@"canClick varchar(200), "];
    [createMessageTableSQL appendString:@"isread varchar(200), "];
    [createMessageTableSQL appendString:@"updatetime varchar(200), "];
    [createMessageTableSQL appendString:@"username varchar(200) "];
    [createMessageTableSQL appendString:@")"];
    [database executeUpdate:createMessageTableSQL];
    
}

- (void)initDBCommonParamsDeviceToken{
    NSMutableString* deviceTokenSql = [[NSMutableString alloc] initWithString:@"select * from "];
    [deviceTokenSql appendString:FMDBCommonParamsTableName];
    [deviceTokenSql appendString:@" where common_key == 'device_token' "];
    FMResultSet* deviceTokenResult = [self.database executeQuery:deviceTokenSql];
    while ([deviceTokenResult next]) {
        return;
    }
    [self.database executeUpdate:[NSString stringWithFormat:@"insert into %@ (common_key) values ('device_token')",FMDBCommonParamsTableName]];
}

- (void)initDBCommonParamsIsRefresh{
    NSMutableString* isRefreshSql = [[NSMutableString alloc] initWithString:@"select * from "];
    [isRefreshSql appendString:FMDBCommonParamsTableName];
    [isRefreshSql appendString:@" where common_key == 'is_refresh' "];
    FMResultSet* isRefreshResult = [self.database executeQuery:isRefreshSql];
    while ([isRefreshResult next]) {
        return;
    }
    [self.database executeUpdate:[NSString stringWithFormat:@"insert into %@ (common_key) values ('is_refresh')",FMDBCommonParamsTableName]];
}

/**
 *
 *  UserDetails
 *  用户信息
 *
 */
#pragma mark - userdetails

- (void)inertUserDetailsTableWithUserDetails:(UserDetails *)userdetails {
    
    if (userdetails == nil) {
        return;
    }
    
    if ([self selectUserdetailsWithUsername:[userdetails username]] == nil) {
        NSMutableString* insertUserSql = [[NSMutableString alloc] initWithString:@"insert into "];
        [insertUserSql appendString:FMDBUserDetailsTableName];
        [insertUserSql appendString:@" (username, password, fullname, orgfullname, position, email, mobile, photoserviceurl, createTime) values (?, ?, ?, ?, ?, ?, ?, ?, ?)"];
        Boolean result = [self.database executeUpdate:insertUserSql, userdetails.username, userdetails.password, userdetails.fullName, userdetails.orgFullName, userdetails.position, userdetails.email, userdetails.mobile, userdetails.photo, [TimeUtils getDateStr:[TimeUtils getNowMills] ByDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        NSLog(@"Insert_User_Info: %hhu", result);
    }else {
        NSMutableString* updateUserSql = [[NSMutableString alloc] initWithString:@"update "];
        [updateUserSql appendString:FMDBUserDetailsTableName];
        [updateUserSql appendString:@" set username = ?, password = ?, fullname = ?, orgfullname = ?, position = ?, email = ?, mobile = ?, photoserviceurl = ? where username == ? "];
        Boolean result = [self.database executeUpdate:updateUserSql, userdetails.username, userdetails.password, userdetails.fullName, userdetails.orgFullName, userdetails.position, userdetails.email, userdetails.mobile, userdetails.photo, userdetails.username];
        NSLog(@"Update_User_Info: %hhu", result);
    }
    
    
}

- (UserDetails *)selectUserdetailsWithUsername:(NSString *)username {
    if([BOBUtils is_string_null:username]) {
        return nil;
    }
    NSMutableString* getUserDetailsSql = [[NSMutableString alloc] initWithString:@"select * from "];
    [getUserDetailsSql appendString:FMDBUserDetailsTableName];
    [getUserDetailsSql appendString:@" where username == '%@' "];
    FMResultSet* result = [self.database executeQuery:[NSString stringWithFormat:getUserDetailsSql, username]];
    return [self convertWithUserResult:result];
}

- (void)removeUserDetailsByUsername:(NSString*)username {
    NSMutableString* deleteUserSql = [[NSMutableString alloc] initWithString:@"delete from "];
    [deleteUserSql appendString:FMDBUserDetailsTableName];
    [deleteUserSql appendString:@" where username == ? "];
    Boolean result = [self.database executeUpdate:deleteUserSql, username];
    NSLog(@"Delete_user_Info: %hhu", result);
}

- (void)setLastRequestTime:(NSString*)lastRequestTime ByUserName:(NSString*)username {
    NSMutableString* updateRequestTimeSql = [[NSMutableString alloc] initWithString:@"update "];
    [updateRequestTimeSql appendString:FMDBUserDetailsTableName];
    [updateRequestTimeSql appendString:@" set lastrequesttime = ? where username == ? "];
    Boolean result = [self.database executeUpdate:updateRequestTimeSql, lastRequestTime, username];
    NSLog(@"Update_Request_Time_Info: %hhu", result);
}

- (NSString*)getLastRequestTimeByUsername:(NSString*)username withDateFormat:(Boolean)isDateFormat {
    NSMutableString* getLastRequestTimeSql = [[NSMutableString alloc] initWithString:@"select * from "];
    [getLastRequestTimeSql appendString:FMDBUserDetailsTableName];
    [getLastRequestTimeSql appendString:@" where username == '%@' "];
    FMResultSet* result = [self.database executeQuery:[NSString stringWithFormat:getLastRequestTimeSql, username]];
    while ([result next]) {
        NSString* lastRequestTime = [result stringForColumn:@"lastrequesttime"];
        if ([BOBUtils is_string_not_null:lastRequestTime]) {
            if (isDateFormat) {
                return [TimeUtils getDateStr:lastRequestTime ByDateFormate:@"yyyy-MM-dd HH:mm:ss"];
            }else {
                return lastRequestTime;
            }
        }
    }
    
    return [self getFiveDaysAgoTime:isDateFormat];
}

// 处理查询结果
- (UserDetails*)convertWithUserResult:(FMResultSet*)result {
    if (result == nil) {
        NSLog(@"Select_User_Error: %@", [self.database lastErrorMessage]);
        return nil;
    }
    while ([result next]) {
        UserDetails* userDetails = [[UserDetails alloc] init];
        userDetails.username = [result stringForColumn:@"username"];
        userDetails.password = [result stringForColumn:@"password"];
        userDetails.fullName = [result stringForColumn:@"fullname"];
        userDetails.email = [result stringForColumn:@"email"];
        userDetails.mobile = [result stringForColumn:@"mobile"];
        userDetails.orgFullName = [result stringForColumn:@"orgfullname"];
        userDetails.photo = [result stringForColumn:@"photoserviceurl"];
        userDetails.position = [result stringForColumn:@"position"];
        return userDetails;
    }
    return nil;
}


/**
 *
 *  commonparams
 *  通用参数表
 *
 */

#pragma mark - params
- (void)savePushDeviceToken:(NSString*)deviceToken {
    NSMutableString* deviceTokenUpdateSql = [[NSMutableString alloc] initWithString:@"update "];
    [deviceTokenUpdateSql appendString:FMDBCommonParamsTableName];
    [deviceTokenUpdateSql appendString:@" set common_value = ? where common_key == 'device_token' "];
    Boolean result = [self.database executeUpdate:deviceTokenUpdateSql, deviceToken];
    NSLog(@"Update_Device_Token_Info: %hhu", result);
}

- (NSString*)getPushDeviceToken {
    NSMutableString* getDeviceTokenSql = [[NSMutableString alloc] initWithString:@"select * from "];
    [getDeviceTokenSql appendString:FMDBCommonParamsTableName];
    [getDeviceTokenSql appendString:@" where common_key == 'device_token' "];
    FMResultSet* result = [self.database executeQuery:getDeviceTokenSql];
    while ([result next]) {
        NSString* deviceToken = [result stringForColumn:@"common_value"];
        if (deviceToken != nil) {
            return deviceToken;
        }
    }
    return nil;
}

- (void)updateIsRefresh:(NSString*)isRefresh {
    NSMutableString* isRefreshUpdateSql = [[NSMutableString alloc] initWithString:@"update "];
    [isRefreshUpdateSql appendString:FMDBCommonParamsTableName];
    [isRefreshUpdateSql appendString:@" set common_value = ? where common_key == 'is_refresh' "];
    Boolean result = [self.database executeUpdate:isRefreshUpdateSql, isRefresh];
    NSLog(@"Update_Is_Refresh_Info: %hhu", result);
}

- (NSString*)getIsRefresh {
    NSMutableString* getIsRefreshSql = [[NSMutableString alloc] initWithString:@"select * from "];
    [getIsRefreshSql appendString:FMDBCommonParamsTableName];
    [getIsRefreshSql appendString:@" where common_key == 'is_refresh' "];
    FMResultSet* result = [self.database executeQuery:getIsRefreshSql];
    while ([result next]) {
        NSString* isRefresh = [result stringForColumn:@"common_value"];
        if (isRefresh != nil) {
            return isRefresh;
        }
    }
    return @"0";
}


/**
 *
 *  Topic
 *  主题
 *
 */

#pragma mark - topic

- (void)insetTopicIntoDB:(NSMutableArray<MessageTopicModel*>*)topics {
    for (int i=0; i<[topics count]; i++) {
        MessageTopicModel* topic = [topics objectAtIndex:i];
        if ([[self getTopicById:topic.topicId] count] > 0) {
            // 已存在
        }else {
            NSMutableString* insertTopicSql = [[NSMutableString alloc] initWithString:@"insert into "];
            [insertTopicSql appendString:FMDBTopicTableName];
            [insertTopicSql appendString:@" (topic_id, username, icon, topic, update_time) values (?, ?, ?, ?, ?)"];
            Boolean result = [self.database executeUpdate:insertTopicSql, topic.topicId, topic.name, topic.icon, topic.topic, [TimeUtils getNowMills]];
            NSLog(@"Insert_Topic_Info: %hhu", result);
        }
    }
    
}

- (NSMutableArray<MessageTopicModel*>*)selectTopicFromDB {
    NSString* username = [[[CurrentUser sharedInstance] userdetails] username];
    // 根据message来获取topic
    NSMutableArray* topicIds = [[NSMutableArray alloc] init];
    NSMutableString* topicSql = [[NSMutableString alloc] initWithString:@"select distinct topic from "];
    [topicSql appendString:FMDBMessageTableName];
    [topicSql appendString:@" where username == '%@'"];
    FMResultSet* topicResult = [self.database executeQuery:[NSString stringWithFormat:topicSql, username]];
    while ([topicResult next]) {
        [topicIds addObject:[topicResult stringForColumn:@"topic"]];
    }
    if ([topicIds count] <= 0) {
        return topicIds;
    }
    
    NSMutableString* sqlTopic = [[NSMutableString alloc] init];
    for (int i=0; i<[topicIds count]; i++) {
        [sqlTopic appendString:@"'"];
        [sqlTopic appendString:[topicIds objectAtIndex:i]];
        [sqlTopic appendString:@"',"];
    }
    NSString* sqlTopicStr = [sqlTopic substringWithRange:NSMakeRange(0, (sqlTopic.length-1))];
    
    NSMutableString* getTopicSql = [[NSMutableString alloc] initWithString:@"select * from "];
    [getTopicSql appendString:FMDBTopicTableName];
    [getTopicSql appendString:@" where topic_id in (%@) order by update_time desc "];
    FMResultSet* getTopicResult = [self.database executeQuery:[NSString stringWithFormat:getTopicSql, sqlTopicStr]];
    return [self convertWithTopicResult:getTopicResult];
}

- (void)updateLatestMessageTimeWithTopicId:(NSString*)topicId withLatestTime:(NSString*)latestTime {
    NSMutableString* updateTimeSql = [[NSMutableString alloc] initWithString:@"update "];
    [updateTimeSql appendString:FMDBTopicTableName];
    [updateTimeSql appendString:@" set update_time = ? where topic_id == ?"];
    Boolean result = [self.database executeUpdate:updateTimeSql, latestTime, topicId];
    NSLog(@"Update_Latest_Time_Info: %hhu", result);
}

- (NSMutableArray<MessageTopicModel*>*)getTopicById:(NSString*)topicId {
    NSMutableString* sql = [[NSMutableString alloc] initWithString:@"select * from "];
    [sql appendString:FMDBTopicTableName];
    [sql appendString:@" where topic_id == '%@'"];
    FMResultSet* result = [self.database executeQuery:[NSString stringWithFormat:sql, topicId]];
    return [self convertWithTopicResult:result];
}

// 对查询结果做一些处理
- (NSMutableArray<MessageTopicModel*>*)convertWithTopicResult:(FMResultSet*)result {
    NSMutableArray<MessageTopicModel*>* topics = [[NSMutableArray alloc] init];
    if (result == nil) {
        NSLog(@"Select_Error: %@", [self.database lastErrorMessage]);
        return topics;
    }
    while ([result next]) {
        MessageTopicModel* topic = [[MessageTopicModel alloc] init];
        topic.topicId = [result stringForColumn:@"topic_id"];
        topic.name = [result stringForColumn:@"username"];
        topic.icon = [result stringForColumn:@"icon"];
        topic.topic = [result stringForColumn:@"topic"];
        // 查询当前主题下的未读消息数
        NSMutableString* unReadSql = [[NSMutableString alloc] initWithString:@"select count(*) from "];
        [unReadSql appendString:FMDBMessageTableName];
        [unReadSql appendString:@" where topic == '%@' and username == '%@' and isread == '0'"];
        FMResultSet* unReadResult = [self.database executeQuery:[NSString stringWithFormat:unReadSql, topic.topicId, [[[CurrentUser sharedInstance] userdetails] username]]];
        if (unReadResult != nil) {
            topic.unReadMessages = [self.database intForQuery:[NSString stringWithFormat:unReadSql, topic.topicId, [[[CurrentUser sharedInstance] userdetails] username]]] ;
        }else {
            NSLog(@"UnRead_Select_Error: %@", [self.database lastErrorMessage]);
            topic.unReadMessages = 0;
        }
        // 查询最新消息内容
        NSMutableString* latestMessageSql = [[NSMutableString alloc] initWithString:@"select * from "];
        [latestMessageSql appendString:FMDBMessageTableName];
        [latestMessageSql appendString:@" where topic == '%@' and username == '%@' order by gmtCreate desc limit 0 , 1"];
        FMResultSet* latestMessageResult = [self.database executeQuery:[NSString stringWithFormat:latestMessageSql, topic.topicId, [[[CurrentUser sharedInstance] userdetails] username]]];
        // 查询数目
        NSMutableString* latestMessageNumSql = [[NSMutableString alloc] initWithString:@"select count(*) as num from "];
        [latestMessageNumSql appendString:FMDBMessageTableName];
        [latestMessageNumSql appendString:@" where topic == '%@' and username == '%@' order by gmtCreate desc limit 0 , 1"];
        FMResultSet* latestMessageNumResult = [self.database executeQuery:[NSString stringWithFormat:latestMessageNumSql, topic.topicId, [[[CurrentUser sharedInstance] userdetails] username]]];
        
        if ([latestMessageResult next]) {
            
            topic.latestMessage = [latestMessageResult stringForColumn:@"content"];
            topic.latestUpdateTime = [latestMessageResult stringForColumn:@"gmtCreate"];
            // 这里再做一次更新
            [self updateLatestMessageTimeWithTopicId:topic.topicId withLatestTime:topic.latestUpdateTime];
            
        }else {
            topic.latestMessage = @"暂无消息";
        }
        [topics addObject:topic];
    }
    return topics;
}

/**
 *
 *  Message
 *  消息
 *
 */

#pragma mark - message

- (void)insertMessageIntoDB:(NSMutableArray<MessageModel*>*)messages {
    NSString* username = [[[CurrentUser sharedInstance] userdetails] username];
    
    for (int i=0; i<[messages count]; i++) {
        MessageModel* message = [messages objectAtIndex:i];
        if ([[self getMessageById:message.msgId] count] > 0) {
            // 已存在
        }else {
            NSMutableString* insertMessageSql = [[NSMutableString alloc] initWithString:@"insert into "];
            [insertMessageSql appendString:FMDBMessageTableName];
            [insertMessageSql appendString:@" (message_id,  \
             content,     \
             clickUrl,    \
             gmtCreate,   \
             title,       \
             topic,       \
             needPush,    \
             toemp,       \
             pushed,      \
             canClick,    \
             isread,      \
             updatetime,  \
             username) values (?,?,?,?,?,?,?,?,?,?,?,?,?)"];
            Boolean result = [self.database executeUpdate:insertMessageSql,
                              message.msgId,
                              message.content,
                              message.clickUrl,
                              [NSString stringWithFormat:@"%ld",message.gmtCreate],
                              message.title,
                              [NSString stringWithFormat:@"%d",message.topic],
                              [self transBool2Str:message.needPush],
                              message.toemp,
                              [self transBool2Str:message.pushed],
                              [self transBool2Str:message.canClick],
                              @"0", // 默认未读状态
                              [TimeUtils getNowMills],
                              username];
            // 更新topic最新的时间
            [self updateLatestMessageTimeWithTopicId:[NSString stringWithFormat:@"%d",message.topic] withLatestTime:[NSString stringWithFormat:@"%ld",message.gmtCreate]];
            
            NSLog(@"Insert_Message_Info: %hhu", result);
        }
    }
}

- (void)updateMessageReadState:(NSString*)topicId {
    NSString* username = [[[CurrentUser sharedInstance] userdetails] username];
    
    NSMutableString* readStatesql = [[NSMutableString alloc] initWithString:@"update "];
    [readStatesql appendString:FMDBMessageTableName];
    [readStatesql appendString:@" set isread = '1' where username == ? and topic == ?"];
    Boolean result = [self.database executeUpdate:readStatesql, username, topicId];
    NSLog(@"Update_Read_State_Info: %hhu", result);
}

- (NSMutableArray<MessageModel*>*)selectMessageByPage:(NSString*)topicId pageIndex:(int)pageIndex pageSize:(int)pageSize {
    NSString* username = [[[CurrentUser sharedInstance] userdetails] username];
    
    NSMutableString* sql = [[NSMutableString alloc] initWithString:@"select * from "];
    [sql appendString:FMDBMessageTableName];
    [sql appendString:@" where topic == '%@' and username == '%@' order by gmtCreate desc limit %@ , %@"];
    FMResultSet* result = [self.database executeQuery:[NSString stringWithFormat:sql, topicId, username, [NSString stringWithFormat:@"%d", pageIndex], [NSString stringWithFormat:@"%d", pageSize]]];
    return [self convertWithMessageResult:result];
}

// 根据当前messageId来查询message
- (NSMutableArray<MessageModel*>*)getMessageById:(NSString*)messageId {
    NSString* username = [[[CurrentUser sharedInstance] userdetails] username];
    
    NSMutableString* sql = [[NSMutableString alloc] initWithString:@"select * from "];
    [sql appendString:FMDBMessageTableName];
    [sql appendString:@" where message_id == '%@' and username == '%@'"];
    FMResultSet* result = [self.database executeQuery:[NSString stringWithFormat:sql, messageId, username]];
    return [self convertWithMessageResult:result];
}

// 处理查询结果
- (NSMutableArray<MessageModel*>*)convertWithMessageResult:(FMResultSet*)result {
    NSMutableArray<MessageModel*>* messages = [[NSMutableArray alloc] init];
    if (result == nil) {
        NSLog(@"Select_Error: %@", [self.database lastErrorMessage]);
        return messages;
    }
    while ([result next]) {
        MessageModel* message = [[MessageModel alloc] init];
        message.msgId = [result stringForColumn:@"message_id"];
        message.content = [result stringForColumn:@"content"];
        message.clickUrl = [result stringForColumn:@"clickUrl"];
        message.gmtCreate = [[result stringForColumn:@"gmtCreate"] longLongValue];
        message.title = [result stringForColumn:@"title"];
        message.topic = [[result stringForColumn:@"topic"] intValue];
        message.needPush = [self transStr2Bool:[result stringForColumn:@"needPush"]];
        message.toemp = [result stringForColumn:@"toemp"];
        message.pushed = [self transStr2Bool:[result stringForColumn:@"pushed"]];
        message.canClick = [self transStr2Bool:[result stringForColumn:@"canClick"]];
        message.isRead = [self transStr2Bool:[result stringForColumn:@"isread"]];
        message.username = [result stringForColumn:@"username"];
        
        [messages addObject:message];
    }
    return messages;
}

/**
 *  工具方法
 */

#pragma mark - utils

- (NSString*)transBool2Str:(Boolean)mBool {
    if (mBool) {
        return @"1";
    }else {
        return @"0";
    }
}

- (Boolean)transStr2Bool:(NSString*)s {
    if ([s isEqualToString:@"0"]) {
        return NO;
    }else {
        return YES;
    }
}

static const int FIVE_DAYS_TIMESTAMP = 5;
static const int TIME_CONSTANT_DAY = 86400000; // 天与毫秒的倍数

// 获取距离今天五天前的时间
- (NSString*)getFiveDaysAgoTime:(Boolean)isDateFormat {
    if (isDateFormat) {
        return [TimeUtils getDate:([TimeUtils getNowMillsByLong] - (FIVE_DAYS_TIMESTAMP*TIME_CONSTANT_DAY)) ByDateFormate:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [NSString stringWithFormat:@"%ld", ([TimeUtils getNowMillsByLong] - (FIVE_DAYS_TIMESTAMP*TIME_CONSTANT_DAY))];
}

@end
