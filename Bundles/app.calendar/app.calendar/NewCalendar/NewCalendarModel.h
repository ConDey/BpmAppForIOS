//
//  NewCalendarModel.h
//  app.calendar
//
//  Created by feng sun on 2017/11/14.
//  Copyright © 2017年 eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCalendarModel : NSObject
@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *eventName;
@property (nonatomic,retain) NSString *eventType;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *Description;
@property (nonatomic,retain) NSString *startDate;
@property (nonatomic,retain) NSString *startTime;
@property (nonatomic,retain) NSString *endDate;
@property (nonatomic,retain) NSString *endTime;
@end
