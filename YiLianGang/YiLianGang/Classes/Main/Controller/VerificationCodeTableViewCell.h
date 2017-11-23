//
//  VerificationCodeTableViewCell.h
//  payViewDemo
//
//  Created by 编程 on 2017/11/14.
//  Copyright © 2017年 YiLiANGANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationCodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infolabel;
@property (weak, nonatomic) IBOutlet UITextField *inputInfoTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeButton;

@end
