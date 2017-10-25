//
//  DeviceSubTableController.h
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/22.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DeviceSubTableController : UITableViewController
-(instancetype)initWithGroupId:(NSNumber *)groupId;
@property(nonatomic,weak) UIViewController *mainController;

@end
