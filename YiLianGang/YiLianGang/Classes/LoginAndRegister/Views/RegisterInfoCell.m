//
//  RegisterInfoCell.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/3.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "RegisterInfoCell.h"

@implementation RegisterInfoCell
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    [self.tapDelegate registerInfoCellDidTap:sender];
}

- (void) textFieldDidChange:(UITextField *) TextField{
    [self.textFieldDelegate registerInfoCellTextFieldDidEdit:TextField];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self.textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
