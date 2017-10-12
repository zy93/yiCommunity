//
//  RegisterInfoCell.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/3.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//
#warning 已弃用
#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"
@protocol RegisterInfoCellTextFieldDidEdit<NSObject>
-(void)registerInfoCellTextFieldDidEdit:(UITextField*)textField;
@end
@protocol RegisterInfoCellTapDelegate<NSObject>
-(void)registerInfoCellDidTap:(UIGestureRecognizer*)gesture;
@end
@interface RegisterInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognize;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *pTextView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic,weak) id<RegisterInfoCellTapDelegate> tapDelegate;
@property(nonatomic,weak) id<RegisterInfoCellTextFieldDidEdit> textFieldDelegate;

@end
