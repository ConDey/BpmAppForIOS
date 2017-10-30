//
//  ListDataResult.h
//  app.webkit
//
//  Created by wanyudong on 2017/10/28.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataResult.h"

@interface ListDataResult : BaseDataResult

@property (nonatomic, retain) NSMutableArray *list;

- (instancetype)initWithSuccess:(Boolean)isSuccess withUrls:(NSMutableArray *)urls;

@end
