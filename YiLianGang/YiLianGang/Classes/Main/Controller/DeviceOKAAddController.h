//
//  DeviceOKAAddController.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/17.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeviceOKAAddControllerDelegate<NSObject>
-(void)deviceOKAAddControllerDidAddScene;
@end

@interface DeviceOKAAddController : UITableViewController
@property(nonatomic,weak) id<DeviceOKAAddControllerDelegate> delegate;
@end
