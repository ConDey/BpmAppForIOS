//
//  CalendarViewController.h
//  app.calendar
//
//  Created by feng sun on 2017/11/14.
//  Copyright © 2017年 eazytec. All rights reserved.
//


#import "NewCalendarViewController.h"
@interface CalendarViewController : EAViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,calendarDataDelegete>

@end
