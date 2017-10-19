//
//  NoticeViewController.h
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoticeViewController : EAViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) NSArray *noticeList;


@end
