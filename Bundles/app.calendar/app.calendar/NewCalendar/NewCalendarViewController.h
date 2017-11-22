//
//  NewCalendarViewController.h
//  app.calendar
//
//  Created by feng sun on 2017/11/14.
//  Copyright © 2017年 eazytec. All rights reserved.
//


@protocol calendarDataDelegete;
@interface NewCalendarViewController :EAViewController
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,retain)NSString *eventId;
@property(nonatomic,retain)id<calendarDataDelegete> delegete;
@end


@protocol calendarDataDelegete<NSObject>
-(void) calendarListReload;
@end
