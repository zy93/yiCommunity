//
//  PayContentCell.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/21.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayContentCell;
@protocol PayContentCellDelegate <NSObject>

// 点击单个商品选择按钮回调
- (void)payBillSelected:(PayContentCell *)cell isSelected:(BOOL)choosed;

@end
@interface PayContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *selectedBuuton;
@property (nonatomic,assign) id<PayContentCellDelegate>delegate;
@end
