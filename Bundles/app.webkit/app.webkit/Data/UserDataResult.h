//
//  UserDataResult.h
//  app.webkit
//
//  Created by wanyudong on 2017/10/30.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "BaseDataResult.h"

@interface UserDataResult : BaseDataResult

@property (nonatomic, strong) UserDetails *user;

- (instancetype)initWithSuccess:(Boolean)isSuccess withUserDetails:(UserDetails *)user;

@end
