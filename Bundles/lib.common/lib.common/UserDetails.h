//
//  UserDetails.h
//  lib.common
//
//  Created by ConDey on 2017/7/11.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetails : NSObject

@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;

@property (nonatomic,retain) NSString *fullName;
@property (nonatomic,retain) NSString *orgFullName;
@property (nonatomic,retain) NSString *photo;
@property (nonatomic,retain) NSString *departmentName;
@property (nonatomic,retain) NSString *position;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *mobile;


@end
