//
//  DeviceTableCell.h
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/22.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceFactoryLabel;
@end
