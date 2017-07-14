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


@implementation EAProtocol

+ (NSString *)loadRequestServiceUrlWithName:(NSString *)name {
    return [REQUEST_SERVICE_URL stringByAppendingString:name];
}

+ (NSDictionary *)doRequestJSONSerializationdDecode:(id _Nullable)responseObject {
    return [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
}

+ (BOOL)isRequestJSONSerializationSuccess:(NSDictionary *) result {
    BOOL code = [[result objectForKey:@"success"] boolValue];
    if(code == YES){
        return YES;
    }
    return NO;
}

+ (AFHTTPSessionManager *)createAFHTTPSessionManager:(NSString *)url {
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

@end
