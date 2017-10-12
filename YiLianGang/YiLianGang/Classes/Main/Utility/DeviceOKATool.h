//
//  DeviceOKATool.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/14.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceSceneInfo.h"
@class DeviceOKAInfo;
typedef void(^OKABlock)(NSDictionary *dict);
@interface DeviceOKATool : NSObject
//一键执行工具类
+(instancetype)sharedDeviceOKATool;
-(void)sendRequestToGetOKAListWithResponse:(OKABlock)block;
-(void)sendRequestToRegisterOKAWithName:(NSString *)name services:(NSArray<DeviceSceneCooperationService*>*)serviceArr response:(OKABlock)block;
-(void)sendRequestToDeleteOKAWithSceneId:(NSNumber*)number response:(OKABlock)block;
-(void)sendRequestToExecuteOKAWithSceneId:(NSNumber*)number response:(OKABlock)block;

//一键执行列表
@property(nonatomic,strong) NSArray<DeviceOKAInfo*> *deviceOKAListArr;
@end

@interface DeviceOKAInfo : NSObject
/**一键执行id*/
@property(nonatomic,strong) NSNumber *sceneId;
/**一键执行名称*/
@property(nonatomic,strong) NSString *sceneName;

@end
