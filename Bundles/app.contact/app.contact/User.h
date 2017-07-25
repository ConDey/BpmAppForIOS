//
//  User.h
//  app.contact
//
//  Created by ConDey on 2017/7/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,retain) NSString *id;
@property (nonatomic,retain) NSString *username;

@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *fullName;
@property (nonatomic,retain) NSString *departmentId;
@property (nonatomic,retain) NSString *departmentName;
@property (nonatomic,retain) NSString *position;

@end
