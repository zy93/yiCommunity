//
//  InfoTableViewCell.m
//  payViewDemo
//
//  Created by 编程 on 2017/11/14.
//  Copyright © 2017年 YiLiANGANG. All rights reserved.
//

#import "InfoTableViewCell.h"

@interface  InfoTableViewCell()<UITextFieldDelegate>

@end

@implementation InfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputInfoTextField.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.superview endEditing:YES];
    return YES;
}

@end
