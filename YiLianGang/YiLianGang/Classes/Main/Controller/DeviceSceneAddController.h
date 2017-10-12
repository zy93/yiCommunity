//
//  DeviceSceneAddController.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeviceSceneAddControllerDelegate<NSObject>
-(void)deviceSceneAddControllerDidAddScene;
@end
@interface DeviceSceneAddController : UITableViewController
@property(nonatomic,weak) id<DeviceSceneAddControllerDelegate> delegate;
@end
