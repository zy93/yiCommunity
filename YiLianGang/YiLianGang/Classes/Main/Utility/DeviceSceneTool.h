//
//  DeviceSceneTool.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceSceneInfo.h"
#import "DeviceDetailInfo.h"

typedef void(^SceneDeleteBlock) (NSDictionary *dict);
typedef void(^SceneControlBlock) (NSDictionary *dict);
typedef void(^SceneRegisterBlock) (NSDictionary *dict);
typedef void(^SceneBlock) (NSArray<DeviceSceneInfo *>* infoArr);

@interface DeviceSceneTool : NSObject
+(instancetype)sharedDeviceSceneTool;
-(void)sendRegisterWithInfo:(DeviceSceneRegisterInfo*)registerInfo response:(SceneRegisterBlock)block;

-(void)sendRequestToGetAllDeviceSceneWithUserId:(NSNumber*)userId response:(SceneBlock)block;

-(void)sendRequestToDeleteWithSceneId:(NSNumber*)sceneId response:(SceneDeleteBlock)block;

-(void)sendRequestToControlWithSceneId:(NSNumber*)sceneId state:(BOOL)state response:(SceneControlBlock)block;


@property(nonatomic,strong) DeviceSceneRegisterInfo *registerInfo;

@property(nonatomic,strong) DeviceSceneCooperationCellInfo *lastCellInfo;

@property(nonatomic,strong) DeviceSceneCooperationService *lastService;
@end
