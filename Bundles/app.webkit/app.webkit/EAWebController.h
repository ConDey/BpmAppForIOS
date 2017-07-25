//
//  EAWebController.h
//  app.webkit
//
//  Created by ConDey on 2017/7/14.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dsbridge.h"
#import "BPMJsApi.h"
#import "com_eazytec_bpm_lib_common/lib.common.h"

@interface EAWebController : EAViewController<BPMJsApiDelegate>


@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *urltitle;

@property (nonatomic,retain) BPMJsApi *jsApi;
@property (nonatomic,retain) DWebview *webview;


@end