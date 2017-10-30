//
//  TokenDataResult.m
//  app.webkit
//
//  Created by wanyudong on 2017/10/30.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "TokenDataResult.h"

@implementation TokenDataResult

- (instancetype)initWithSuccess:(Boolean)isSuccess withToken:(NSString *)token {
    self = [super initWithSuccess:isSuccess];
    if (self) {
        self.token = token;
    }
    return self;
}

@end
