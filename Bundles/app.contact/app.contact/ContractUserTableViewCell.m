//
//  ContractUserTableViewCell.m
//  app.contact
//
//  Created by ConDey on 2017/7/18.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "ContractUserTableViewCell.h"

#import "com_eazytec_bpm_lib_common/lib.common.h"

@implementation ContractUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //更改图片位置、尺寸
    self.contentView.frame = CGRectMake(0,0,SCREEN_WIDTH, 60);
    
}


@end
