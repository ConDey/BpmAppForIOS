//
//  BPMJsApi.m
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "BPMJsApi.h"

@implementation BPMJsApi

- (void)close:(NSDictionary *)args {
    if (self.delegate != nil) {
        [self.delegate delegate_close];
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
