//
//  DevicePopoverController.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceController.h"
@protocol DevicePopoverControllerDelegate<NSObject>
-(void)devicePopoverContollerDidChooseIndex:(NSInteger)index;
@end
@interface DevicePopoverController : UITableViewController
@property(nonatomic,assign) BOOL isNeedRefresh;
@property(nonatomic,weak) DeviceController *controller;
@property(nonatomic,weak) id<DevicePopoverControllerDelegate> delegate;
@end
