//
//  NoticeDetailViewController.h
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailViewController : EAViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(retain,nonatomic)NSString *notice_id;

@end

