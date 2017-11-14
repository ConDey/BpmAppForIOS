//
//  EAProtocol.h
//  EazyEnterprise
//
//  Created by ConDey on 2016/10/28.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// 服务相关常量
static NSString * _Nonnull const REQUEST_CONTENT_TYPE        = @"text/html";
static NSString * _Nonnull const REQUEST_SERVICE_URL         = @"http://58.215.198.212:8080/external/";
static NSString * _Nonnull const REQUEST_URL         = @"http://58.215.198.212:8080";
//static NSString * _Nonnull const REQUEST_SERVICE_URL         = @"http://192.168.133.107:8080/external/";
//static NSString * _Nonnull const REQUEST_URL         = @"http://192.168.133.107:8080";
// 登录
static NSString * _Nonnull const CommonLoginServiceUrl          = @"common/logon";
// 消息
static NSString * _Nonnull const MessageListServiceUrl          = @"msg/list";
static NSString * _Nonnull const MessageReadedServiceUrl        = @"msg/setInternalMessageReaded";
// 通讯录
static NSString * _Nonnull const ContactDepartServiceUrl        = @"department/listByParentId";
static NSString * _Nonnull const ContactUserDetailServiceUrl        = @"user/detail";
static NSString * _Nonnull const ContactUserListServiceUrl      =@"user/list";
//修改密码
static NSString * _Nonnull const PasswordChangeServiceUrl       =@"password/change";
//通知公告
static NSString * _Nonnull const ContactNoticeDetailServiceUrl      =@"notice/detail";
static NSString * _Nonnull const ContactNoticeListServiceUrl      =@"notice/list";
//App菜单列表
static NSString * _Nonnull const AppMenuListServiceUrl          = @"menu/list";
static NSString * _Nonnull const AppMenuAllListServiceUrl       = @"menu/list";
// 全局配置
static NSString * _Nonnull const CommonConfigServiceUrl         = @"common/config";
//文件上传
static NSString * _Nonnull const AttachmentUploadUrl            =@"attachment/upload";
//日程安排
static NSString * _Nonnull const ScheduleSaveServiceUrl           =@"schedule/save";
// 服务名称枚举
typedef NS_ENUM(NSInteger, HttpProtocolServiceName) {
    // 枚举成员
    HttpProtocolServiceUserLogin            = 0,
    HttpProtocolServiceMessageList          = 1,
    HttpProtocolServiceMessageReaded        = 2,
    HttpProtocolServiceContactDepart        = 3,
    HttpProtocolServiceContactUserDetail    = 4,
    HttpProtocolServiceContactUserList      = 5,
    HttpProtocolServicePasswordChange       = 6,
    HttpProtocolServiceNoticeDetail         = 7,
    HttpProtocolServiceNoticeList           = 8,
    HttpProtocolServiceAppMenuList          = 9,
    HttpProtocolServiceAppMenuAllList       = 10,
    HttpProtocolServiceCommonConfig         = 11,
    HttpProtocolServiceAttachmentUpload     = 12,
    HttpProtocolServiceScheduleSave         = 13,
};

@interface EAProtocol : NSObject

+ (instancetype _Nonnull)sharedInstance;

- (NSString *_Nonnull)getServiceNameByEnum:(HttpProtocolServiceName)serviceName;
- (NSString *_Nonnull)loadRequestServiceUrlWithName:(NSString *_Nonnull)name;  // 根据服务枚举加载服务地址
- (NSDictionary *_Nonnull)doRequestJSONSerializationdDecode:(id _Nullable)responseObject;
- (BOOL)isRequestJSONSerializationSuccess:(NSDictionary *_Nonnull) result;

- (AFHTTPSessionManager *_Nonnull)createAFHTTPSessionManager:(HttpProtocolServiceName)name;

@end
