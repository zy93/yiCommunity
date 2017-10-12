//
//  DeviceCollectionViewCell.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceFactoryLabel;

@end
