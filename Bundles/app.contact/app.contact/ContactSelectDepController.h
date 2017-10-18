//
//  ContactSelectController.h
//  app.contact
//
//  Created by feng sun on 2017/10/18.
//  Copyright © 2017年 Eazytec. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "com_eazytec_bpm_lib_common/lib.common.h"

@interface ContactSelectDepController : EAViewController<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,retain) NSString *dep;

@end
