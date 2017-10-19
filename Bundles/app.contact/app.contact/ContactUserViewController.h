//
//  ContactUserViewController.h
//  app.contact
//
//  Created by ConDey on 2017/7/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface ContactUserViewController : EAViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain) User *user;
@property (nonatomic,copy) NSString *userId;

@end
