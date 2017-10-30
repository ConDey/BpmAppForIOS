//
//  UserDataResult.m
//  app.webkit
//
//  Created by wanyudong on 2017/10/30.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserDataResult.h"

@implementation UserDataResult

- (instancetype)initWithSuccess:(Boolean)isSuccess withUserDetails:(UserDetails *)user {
    self = [super initWithSuccess:isSuccess];
    if (self) {
        self.user = user;
    }
    return self;
}

@end
