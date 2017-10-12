//
//  DeviceAddInfoController.h
//  YiLianGang
//
//  Created by Way_Lone on 16/9/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeviceAddDelegate<NSObject>
-(void)deviceDidAdded;
@end
@interface DeviceAddInfoController : UITableViewController
@property(nonatomic,weak) id<DeviceAddDelegate> delegate;
@end
