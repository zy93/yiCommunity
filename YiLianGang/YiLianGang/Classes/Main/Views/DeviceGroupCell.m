//
//  DeviceGroupCell.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/30.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceGroupCell.h"

@implementation DeviceGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickModifyButton:(id)sender {
    [self.delegate deviceGroupClickModifyButtonAtRow:self.indexRow];
}
- (IBAction)clickDeleteButton:(id)sender {
    [self.delegate deviceGroupClickDeleteButtonAtRow:self.indexRow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
