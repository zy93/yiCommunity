//
//  DeviceSceneListCell.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceSceneListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sceneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sceneDetailLabel;
@property (weak, nonatomic) IBOutlet UISwitch *sceneSwitch;

@end
