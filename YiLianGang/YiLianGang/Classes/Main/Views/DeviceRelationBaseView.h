//
//  DeviceRelationBaseView.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/19.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"
typedef DeviceInfo*(^DeviceInfoBlock) ();
@interface DeviceRelationBaseView : UIView
@property(nonatomic,strong) NSDictionary *param;
@property(nonatomic,strong) DeviceInfo *deviceInfo;
@property(nonatomic,copy) DeviceInfoBlock infoBlock;
@property(nonatomic,assign) BOOL on;
@end
