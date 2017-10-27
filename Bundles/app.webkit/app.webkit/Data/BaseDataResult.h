//
//  BaseDataResult.h
//  app.webkit
//
//  Created by wanyudong on 2017/10/27.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDataResult : NSObject

@property (nonatomic, assign) Boolean success;
@property (nonatomic, retain) NSString *errorMsg;

- (instancetype)initWithSuccess:(Boolean)isSuccess;

@end
