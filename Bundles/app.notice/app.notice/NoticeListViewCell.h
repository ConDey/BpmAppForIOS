//
//  NoticeListViewCell.h
//  app.notice
//
//  Created by feng sun on 2017/10/19.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
@property (weak, nonatomic) IBOutlet UILabel *createdBy;
@property (weak, nonatomic) IBOutlet UILabel *createdTime;



@end
