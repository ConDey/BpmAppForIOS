//
//  ListDataResult.m
//  app.webkit
//
//  Created by wanyudong on 2017/10/28.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "ListDataResult.h"

@implementation ListDataResult

- (instancetype)initWithSuccess:(Boolean)isSuccess withUrls:(NSMutableArray *)urls {
    self = [super initWithSuccess:isSuccess];
    if (self) {
        self.list = urls;
    }
    return self;
}

@end
