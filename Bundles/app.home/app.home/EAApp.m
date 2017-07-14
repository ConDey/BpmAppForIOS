//
//  EAApp.m
//  app.home
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "EAApp.h"
#import <Small/SMBundle.h>
#import <Small/Small.h>

#import "com_eazytec_bpm_lib_common/lib.common.h"


@implementation EAApp

- (BOOL)installed {
    
    if (self.appType == AppTypeWeb) {
        return YES;
    }
    
    if ([SMBundle bundleForName:self.packageName] == nil) {
        return NO;
    }
    
    return YES;
}

- (void)install {
    // 暂时不实现
}

- (BOOL)canInstall {
    if (self.appType == AppTypeRemote) {
        // 只有远程应用才需要安装
        return YES;
    }
    return NO;
}


- (void)getInfoApp:(UIViewController *)controller {
    if (![self installed]) {
        return;
    }
    
    if (self.appType == AppTypeWeb) {
        if ([NSString isStringBlank:self.bundleName]) {
            // 表明是debug模式
            [Small openUri:[NSString stringWithFormat:@"app.webkit?urltitle=%@",self.displayName] fromController:controller];
            return;
        }
        NSString *url = [NSString encodeToPercentEscapeString:[NSString stringWithFormat:@"%@%@",REQUEST_SERVICE_URL ,self.
                                                               bundleName]];
        NSString *allurl = [NSString stringWithFormat:@"app.webkit?url=%@&urltitle=%@", url, [NSString encodeString:self.displayName]] ;
        [Small openUri:allurl fromController:controller];
        return;
    }
    [Small openUri:self.bundleName fromController:controller];
}


@end
