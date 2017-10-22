//
//  AppModel.h
//  app.home
//
//  Created by wanyudong on 2017/10/20.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

@property (nonatomic, strong) NSString* appId;
@property (nonatomic, strong) NSString* orderNo;
@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* packageName;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* helpText;
@property (nonatomic, strong) NSString* imageUrlType;
@property (nonatomic, strong) NSString* bundleName;
@property (nonatomic, strong) NSString* type;

@end
