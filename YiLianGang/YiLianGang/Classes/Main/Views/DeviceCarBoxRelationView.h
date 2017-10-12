//
//  DeviceCarBoxRelationView.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/19.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceRelationBaseView.h"
typedef void(^CarBoxBlock)(NSInteger typeIndex);
@interface DeviceCarBoxRelationView : DeviceRelationBaseView
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeButton;
@property (weak, nonatomic) IBOutlet UISwitch *relationSwitch;


@property(nonatomic,copy) CarBoxBlock carBoxBlock;




@end
