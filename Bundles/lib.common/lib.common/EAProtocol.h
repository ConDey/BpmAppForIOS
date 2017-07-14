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

@interface EAProtocol : NSObject

+ (NSString *_Nonnull)loadRequestServiceUrlWithName:(NSString *_Nonnull)name;  // 根据服务枚举加载服务地址
+ (NSDictionary *_Nonnull)doRequestJSONSerializationdDecode:(id _Nullable)responseObject;
+ (BOOL)isRequestJSONSerializationSuccess:(NSDictionary *_Nonnull) result;

+ (AFHTTPSessionManager *_Nonnull)createAFHTTPSessionManager:(NSString *_Nonnull)url;

@end
