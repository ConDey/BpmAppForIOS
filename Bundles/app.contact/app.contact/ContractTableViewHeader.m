//
//  ContractTableViewHeader.m
//  app.contact
//
//  Created by ConDey on 2017/7/17.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "ContractTableViewHeader.h"

@implementation ContractTableViewHeader

+ (instancetype)initWithTitle:(NSString *)title {
    
    NSBundle *bundle =  [NSBundle bundleForClass:[self class]];
    ContractTableViewHeader *header = [[bundle loadNibNamed:@"ContractTableViewHeader" owner:nil options:nil] firstObject];
    header.titleLabel.text = title;
    return header;
}

@end
