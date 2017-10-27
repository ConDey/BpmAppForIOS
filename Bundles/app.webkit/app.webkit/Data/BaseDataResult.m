//
//  BaseDataResult.m
//  app.webkit
//
//  Created by wanyudong on 2017/10/27.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "BaseDataResult.h"

@implementation BaseDataResult

- (instancetype)initWithSuccess:(Boolean)isSuccess {
    self = [super init];
    if (self) {
        self.success = isSuccess;
        if (isSuccess) {
            self.errorMsg = @"";
        }else {
            self.errorMsg = @"请求出错";
        }
    }
    return self;
}

@end
