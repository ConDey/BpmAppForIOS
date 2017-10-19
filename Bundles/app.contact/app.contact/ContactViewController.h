//
//  ContactViewController.h
//  app.contact
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@interface ContactViewController : EAViewController<UITableViewDelegate, UITableViewDataSource,CNContactPickerDelegate>

@property (nonatomic,retain) NSString *dep;
@property (nonatomic,assign) CGFloat numOfHideSection;
@end
