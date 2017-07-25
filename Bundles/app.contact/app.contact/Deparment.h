//
//  Deparment.h
//  app.contact
//
//  Created by ConDey on 2017/7/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deparment : NSObject

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *order;

@property (nonatomic,assign) NSInteger childCount;
@property (nonatomic,assign) NSInteger userCount;


@end
