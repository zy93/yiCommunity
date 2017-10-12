//
//  DeviceFromGroupTool.h
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/22.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
typedef void (^DeviceBlock)(NSArray *arr);

@interface DeviceFromGroupTool : NSObject
//获取所有设备-请不要用单例调用
#warning 请不要用单例调用
-(void)sendRequestToGetAllDeviceWithGroupId:(NSNumber*)groupId Response:(DeviceBlock)deviceBlock;
@end
