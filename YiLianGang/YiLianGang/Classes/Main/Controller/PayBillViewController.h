//
//  PayBillViewController.h
//  YiLianGang
//
//  Created by 编程 on 2017/10/13.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PayContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *state;

@end

@interface PayTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@end


@interface PayBillViewController : UIViewController

@end
