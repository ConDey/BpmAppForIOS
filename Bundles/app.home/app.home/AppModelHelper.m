//
//  AppModelHelper.m
//  app.home
//
//  Created by wanyudong on 2017/10/20.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "AppModelHelper.h"

@implementation AppModelHelper

+ (NSMutableArray<EAApp*>*)createBpmAppByDatas:(NSMutableArray<AppModel*>*)datas {
    NSMutableArray* apps = [[NSMutableArray alloc] init];
    if (datas != nil && [datas count] > 0) {
        for (int i=0; i<[datas count]; i++) {
            AppModel* model = [datas objectAtIndex:i];
            EAApp* app = [self createBpmAppByData:model];
            if (app != nil) {
                [apps addObject:app];
            }
        }
    }
    return apps;
}

/**
 *  根据AppModel创建EAApp。如果数据有错误则跳过此app的创建。
 */
+ (EAApp*)createBpmAppByData:(AppModel*)data {
    EAApp* mApp = [[EAApp alloc] init];
    mApp.appId = data.appId;
    mApp.packageName = data.packageName;
    mApp.name = data.name;
    mApp.displayName = data.diplayName;
    mApp.imageUrl = data.imageUrl;
    mApp.bundleName = data.bundleName;
    
    if ([data.imageUrlType isEqualToString:@"1"]) {
        mApp.imageUrlType = ImageUrlTypeInner;
    }else {
        mApp.imageUrlType = ImageUrlTypeRemote;
    }
    
    if ([data.type isEqualToString:@"1"]) {
        mApp.imageUrlType = AppTypeInner;
    }else {
        mApp.imageUrlType = AppTypeRemote;
    }
    
    return mApp;
}

@end
