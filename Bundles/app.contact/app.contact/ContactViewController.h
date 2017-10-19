//
//  ContactViewController.h
//  app.contact
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : EAViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,retain) NSString *dep;

@end
