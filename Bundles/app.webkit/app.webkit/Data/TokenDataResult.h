//
//  TokenDataResult.h
//  app.webkit
//
//  Created by wanyudong on 2017/10/30.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "BaseDataResult.h"

@interface TokenDataResult : BaseDataResult

@property (nonatomic, retain) NSString *token;

- (instancetype)initWithSuccess:(Boolean)isSuccess withToken:(NSString *)token;

@end
