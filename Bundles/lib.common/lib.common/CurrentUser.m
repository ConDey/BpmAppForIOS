//
//  CurrentUser.m
//  lib.common
//
//  Created by ConDey on 2017/7/11.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "CurrentUser.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CurrentUser

NSString * const USER_DEFAULT_LOGIN_USERNAME = @"username";
NSString * const USER_DEFAULT_LOGIN_PASSWORD = @"password";

NSString * const DEFAULT_TOKEN = @"EAZYTEC";

+ (CurrentUser *)currentUser {
    
    static CurrentUser *sharedCurrentUserInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedCurrentUserInstance = [[self alloc] init];
    });
    return sharedCurrentUserInstance;
}

+ (NSString *)defaultToken {
    NSString *result = [self md5:DEFAULT_TOKEN];
    return [result substringToIndex:8];
}

- (void)updateWithUserDetails:(UserDetails *)userdetails Token:(NSString *)token {
    
    self.userdetails = userdetails;
    self.token = token;
    
    if (userdetails != nil) {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:userdetails.username forKey:USER_DEFAULT_LOGIN_USERNAME];
        [[NSUserDefaults standardUserDefaults] setObject:userdetails.password forKey: USER_DEFAULT_LOGIN_PASSWORD];
    }
}

- (NSString *)username {
    if (self.userdetails == nil) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOGIN_USERNAME];
    }
    return self.userdetails.username;
}

- (NSString *)password {
    if (self.userdetails == nil) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOGIN_PASSWORD];
    }
    return self.userdetails.password;
}


+ (NSString *)md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

@end
