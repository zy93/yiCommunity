//
//  PayContentCell.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/21.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PayContentCell.h"

@implementation PayContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickSelected:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payBillSelected:isSelected:)])
    {
        [self.delegate payBillSelected:self isSelected:!sender.selected];
    }
}



@end
