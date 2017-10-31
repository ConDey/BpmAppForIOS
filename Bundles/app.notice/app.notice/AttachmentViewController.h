//
//  AttachmentViewController.h
//  app.notice
//
//  Created by feng sun on 2017/10/30.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentViewController : EAViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSArray *attachmentList;

@end
