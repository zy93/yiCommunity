//
//  DeviceAddCooperationController.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteBlock) ();
@interface DeviceAddCooperationController : UITableViewController
-(instancetype)initWithNumber:(NSInteger)number completeBlock:(CompleteBlock)block;

@end
