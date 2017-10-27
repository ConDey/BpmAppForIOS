//
//  BPMJsApi.m
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "BPMJsApi.h"
@interface BPMJsApi()

@end
@implementation BPMJsApi

- (void)close:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_close];
    }
}

- (void)setTitlebarVisible:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_setTitlebarVisible:(Boolean)[args valueForKey:@"visible"]];
    }
}

- (void)setTitle:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_setTitle:(NSString *)[args valueForKey:@"title"]];
    }
}

- (void)choose:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_choose];
    }
}


@end
