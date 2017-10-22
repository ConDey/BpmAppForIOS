//
//  AppListModel.h
//  app.home
//
//  Created by wanyudong on 2017/10/20.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"

@interface AppListModel : BaseModel

@property (nonatomic, strong) NSMutableArray<AppModel*>* apps;

@end
