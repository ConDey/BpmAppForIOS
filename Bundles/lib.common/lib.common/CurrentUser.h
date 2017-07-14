//
//  CurrentUser.h
//  lib.common
//
//  Created by ConDey on 2017/7/11.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetails.h"

@interface CurrentUser : NSObject

+ (CurrentUser *)currentUser; // 获取当前的登录对象
+ (NSString *)defaultToken;

@property (nonatomic,retain) UserDetails *userdetails;
@property (nonatomic,retain) NSString *token;

// 更新用户登录信息
- (void)updateWithUserDetails:(UserDetails *)userdetails Token:(NSString *)token;

- (NSString *)username;
- (NSString *)password;


@end
