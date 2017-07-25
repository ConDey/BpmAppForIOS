//
//  ContractTableViewHeader.h
//  app.contact
//
//  Created by ConDey on 2017/7/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractTableViewHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (instancetype)initWithTitle:(NSString *) title;


@end
