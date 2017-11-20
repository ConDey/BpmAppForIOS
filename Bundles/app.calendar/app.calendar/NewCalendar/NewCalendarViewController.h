//
//  NewCalendarViewController.h
//  app.calendar
//
//  Created by feng sun on 2017/11/14.
//  Copyright © 2017年 eazytec. All rights reserved.
//



@interface NewCalendarViewController : EAViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>



@property(nonatomic,retain)NSString *eventId;

@end
