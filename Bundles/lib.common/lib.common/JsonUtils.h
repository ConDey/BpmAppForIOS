//
//  JsonUtils.h
//  lib.common
//
//  Created by wanyudong on 2017/10/27.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
