//
//  EAApp.h
//  app.home
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EAApp : NSObject

typedef NS_ENUM(NSInteger, ImageUrlType) {
    ImageUrlTypeInner,       // 代表本地图片
    ImageUrlTypeRemote       // 代表远程图片
};

typedef NS_ENUM(NSInteger, APPType) {
    AppTypeInner,        // 代表本地图片
    AppTypeRemote,       // 代表远程应用
    AppTypeWeb           // 代表WEB应用
};

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *displayName;
@property (nonatomic,retain) NSString *imageUrl;

// 代表图片类型，如果图片是本地图片直接通过imageUrl加载图片，如果图片是远程图片，需要先下载后使用
@property (nonatomic) ImageUrlType imageUrlType;

// 应用类型，非常重要的字段
@property (nonatomic) APPType appType;

@property (nonatomic,retain) NSString *bundleName;
@property (nonatomic,retain) NSString *packageName;

- (BOOL)installed; // 判断这个应用是否被安装
- (void)install; // 安装这个应用，暂时没有实现

- (BOOL)canInstall; // 判断这个应用是否需要被安装，web应用就不需要被安装
- (void)getInfoApp:(UIViewController *)controller;


@end
