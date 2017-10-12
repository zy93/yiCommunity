//
//  DeviceCooperationDetailCell.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/13.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceCooperationDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDetailTypeLabel;
@end
