//
//  NoticeDetailViewCell.h
//  app.notice
//
//  Created by feng sun on 2017/10/20.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *noticeDetailTime;

@property (weak, nonatomic) IBOutlet UILabel *noticeDetailContent;

@end

