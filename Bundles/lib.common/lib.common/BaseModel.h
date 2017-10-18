//
//  BaseModel.h
//  lib.common
//
//  Created by wanyudong on 2017/10/18.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic,assign) BOOL success; // 业务请求返回结果标识，标识业务处理是否正确被执行。

@property (nonatomic,copy) NSString *errorMsg; // 业务请求的相关错误信息，当业务正确被执行也就是success = YES的时候，通常这个字段没有意义也不会被赋值，当success = NO时，这个字段通常会记录下错误原因，业务系统可以直接以此原因返回给用户。

@end
