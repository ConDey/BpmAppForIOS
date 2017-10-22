//
//  AppModelHelper.h
//  app.home
//
//  Created by wanyudong on 2017/10/20.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAApp.h"
#import "AppModel.h"

@interface AppModelHelper : NSObject

+ (NSMutableArray<EAApp*>*)createBpmAppByDatas:(NSMutableArray<AppModel*>*)datas;
+ (EAApp*)createBpmAppByData:(AppModel*)data;

@end
