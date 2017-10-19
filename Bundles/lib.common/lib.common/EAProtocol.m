//
//  EAProtocol.m
//  EazyEnterprise
//
//  Created by ConDey on 2016/10/28.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import "EAProtocol.h"
#import "CurrentUser.h"
#import "NSString+EAFoundation.h"

@interface EAProtocol()

@property (nonatomic,retain) NSArray *webServiceUrls;

@end

@implementation EAProtocol

static EAProtocol *_instance;

+ (instancetype)sharedInstance {
    DISPATCH_ONCE_BLOCK(^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSString *_Nonnull)getServiceNameByEnum:(HttpProtocolServiceName)serviceName {
    return [self.webServiceUrls objectAtIndex:serviceName];
}

- (NSString *)loadRequestServiceUrlWithName:(NSString *)name {
    return [REQUEST_SERVICE_URL stringByAppendingString:name];
}

- (NSDictionary *)doRequestJSONSerializationdDecode:(id _Nullable)responseObject {
    return [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
}

- (BOOL)isRequestJSONSerializationSuccess:(NSDictionary *) result {
    BOOL code = [[result objectForKey:@"success"] boolValue];
    if(code == YES){
        return YES;
    }
    return NO;
}

- (AFHTTPSessionManager *)createAFHTTPSessionManager:(HttpProtocolServiceName)name {
    NSString* url = [self getServiceNameByEnum:name];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:REQUEST_CONTENT_TYPE];
    manager.requestSerializer                         = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer                        = [AFHTTPResponseSerializer serializer];
    
    if ([NSString isEqualToString:url origin:@"common/logon"]) {
        [manager.requestSerializer setValue:[CurrentUser defaultToken] forHTTPHeaderField:@"token"];
    }else {
        [manager.requestSerializer setValue:[CurrentUser currentUser].token forHTTPHeaderField:@"token"];
    }
    return manager;
}

- (NSArray *)webServiceUrls {
    if (_webServiceUrls == nil) {
        _webServiceUrls = [NSArray arrayWithObjects:CommonLoginServiceUrl,
                                                    MessageListServiceUrl,
                                                    MessageReadedServiceUrl,
                                                    ContactDepartServiceUrl,
                                                    ContactUserDetailServiceUrl,
                                                    ContactUserListServiceUrl,
                                                    PasswordChangeServiceUrl,
                                                    ContactNoticeDetailServiceUrl,
                                                    ContactNoticeListServiceUrl,
                           nil];
    }
    return _webServiceUrls;
}

@end
