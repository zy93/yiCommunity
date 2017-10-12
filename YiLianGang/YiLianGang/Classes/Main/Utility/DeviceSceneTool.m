//
//  DeviceSceneTool.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceSceneTool.h"
#import "WN_YL_RequestTool.h"
static  DeviceSceneTool *instance;
@interface DeviceSceneTool()<WN_YL_RequestToolDelegate>
@property(nonatomic,copy) SceneBlock sceneBlock;
@property(nonatomic,copy) SceneRegisterBlock sceneRegisterBlock;
@property(nonatomic,copy) SceneControlBlock sceneControlBlock;
@property(nonatomic,copy) SceneDeleteBlock sceneDeleteBlock;

@property(nonatomic,strong) WN_YL_RequestTool *sceneGetListRequest;
@property(nonatomic,strong) WN_YL_RequestTool *sceneRegisterRequest;
@property(nonatomic,strong) WN_YL_RequestTool *sceneDeleteRequest;
@property(nonatomic,strong) WN_YL_RequestTool *sceneControlRequest;
@end

@implementation DeviceSceneTool
+(instancetype)sharedDeviceSceneTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DeviceSceneTool new];
    });
    return instance;
}
-(void)sendRegisterWithInfo:(DeviceSceneRegisterInfo *)registerInfo response:(SceneRegisterBlock)block{
    self.sceneRegisterBlock = block;
    NSDictionary *dict = [NSDictionary dictionary];
    if ([registerInfo.conditionType isEqualToString:@"time"] ) {
        dict = @{@"userId":registerInfo.userId,
                 @"cooperationName":registerInfo.cooperationName,
                 @"conditionType":registerInfo.conditionType,
                 @"exeFrequency":registerInfo.exeFrequency,
                 @"time":registerInfo.time,
                 @"cooperationServices":registerInfo.cooperationServices,
                 };
    }else{
        dict = @{@"userId":registerInfo.userId,
                 @"cooperationName":registerInfo.cooperationName,
                 @"conditionType":registerInfo.conditionType,
                 @"conditions":registerInfo.conditions,
                 @"cooperationServices":registerInfo.cooperationServices,
                 };
    }
    
    [self.sceneRegisterRequest sendPostJsonRequestWithExStr:@"Service_Platform/cooperation/add.do" andParam:dict];
    
}
-(void)sendRequestToGetAllDeviceSceneWithUserId:(NSNumber *)userId response:(SceneBlock)block{
    self.sceneBlock = block;
    [self.sceneGetListRequest sendGetRequestWithExStr:@"Service_Platform/cooperation/all.do" andParam:@{@"userId":userId}];
}

-(void)sendRequestToDeleteWithSceneId:(NSNumber *)sceneId response:(SceneDeleteBlock)block{
    self.sceneDeleteBlock = block;
    [self.sceneDeleteRequest sendPostRequestWithExStr:@"Service_Platform/cooperation/delete.do" andParam:@{@"cooperationId":sceneId}];
    
}

-(void)sendRequestToControlWithSceneId:(NSNumber *)sceneId state:(BOOL)state response:(SceneControlBlock)block{
    self.sceneControlBlock = block;
    [self.sceneControlRequest sendPostRequestWithExStr:@"Service_Platform/cooperation/execute.do" andParam:@{@"cooperationId":sceneId,@"commandState":state?@"on":@"off"}];
    
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.sceneRegisterRequest) {
        if (dict) {
            if (self.sceneRegisterBlock) {
                self.sceneRegisterBlock(dict);
            }
            
        }
    }else if(requestTool == self.sceneGetListRequest){
        if (dict) {
            if (self.sceneBlock) {
                NSArray *arr = dict[@"data"];
                NSMutableArray *mutaArr = [NSMutableArray array];
                if (arr) {
                    for (NSDictionary *sceneDict in arr) {
                        DeviceSceneInfo *info = [DeviceSceneInfo new];
                        if ([sceneDict[@"conditionType"] isEqualToString:@"time"]) {
                            info.cooperationId = sceneDict[@"cooperationId"];
                            info.cooperationName = sceneDict[@"cooperationName"];
                            info.state = sceneDict[@"state"];
                            info.conditionType = sceneDict[@"conditionType"];
                            info.exeFrequency = sceneDict[@"exeFrequency"];
                            info.time = sceneDict[@"time"];
                        }else{
                            info.cooperationId = sceneDict[@"cooperationId"];
                            info.cooperationName = sceneDict[@"cooperationName"];
                            info.state = sceneDict[@"state"];
                            info.conditionType = sceneDict[@"conditionType"];
                            info.conditionsRelation = sceneDict[@"conditionsRelation"];
                            NSArray *listArr = sceneDict[@"conditionList"];
                            NSMutableArray *mutaListArr = [NSMutableArray array];
                            if (listArr) {
                                for (NSDictionary *listDict in listArr) {
                                    DeviceSceneConditionListInfo *listInfo = [DeviceSceneConditionListInfo new];
                                    [listInfo setValuesForKeysWithDictionary:listDict];
                                    [mutaListArr addObject:listInfo];
                                }
                            }
                            info.conditionList = [mutaListArr copy];

//                            NSDictionary *condDict = sceneDict[@"conditions"];
//                            DeviceSceneConditionsInfo *conditions = [DeviceSceneConditionsInfo new];
//                            if (condDict) {
//                                conditions.conditionsRelation = condDict[@"conditionsRelation"];
//                                NSArray *listArr = condDict[@"conditionList"];
//                                NSMutableArray *mutaListArr = [NSMutableArray array];
//                                if (listArr) {
//                                    for (NSDictionary *listDict in listArr) {
//                                        DeviceSceneConditionListInfo *listInfo = [DeviceSceneConditionListInfo new];
//                                        [listInfo setValuesForKeysWithDictionary:listDict];
//                                        [mutaListArr addObject:listInfo];
//                                    }
//                                }
//                                conditions.conditionList = [mutaListArr copy];
//                            }
//                            info.conditions = conditions;
                            
                        }
                        [mutaArr addObject:info];
                    }
                    
                }
                self.sceneBlock([mutaArr copy]);
            }
        }
    }else if (requestTool == self.sceneDeleteRequest){
        if (self.sceneDeleteBlock) {
            self.sceneDeleteBlock(dict);
        }
    }else if (requestTool == self.sceneControlRequest){
        if (self.sceneControlRequest) {
            self.sceneControlBlock(dict);
        }
    }
}
-(WN_YL_RequestTool *)sceneGetListRequest{
    if (!_sceneGetListRequest) {
        _sceneGetListRequest = [[WN_YL_RequestTool alloc]init];
        _sceneGetListRequest.delegate = self;
    }
    return _sceneGetListRequest;
}
-(WN_YL_RequestTool*)sceneRegisterRequest{
    if (!_sceneRegisterRequest) {
        _sceneRegisterRequest = [[WN_YL_RequestTool alloc]init];
        _sceneRegisterRequest.delegate = self;
    }
    return _sceneRegisterRequest;
}
-(WN_YL_RequestTool *)sceneDeleteRequest{
    if (!_sceneDeleteRequest) {
        _sceneDeleteRequest = [WN_YL_RequestTool new];
        _sceneDeleteRequest.delegate = self;
    }
    return _sceneDeleteRequest;
}
-(WN_YL_RequestTool *)sceneControlRequest{
    if (!_sceneControlRequest) {
        _sceneControlRequest = [WN_YL_RequestTool new];
        _sceneControlRequest.delegate = self;
    }
    return _sceneControlRequest;
}
-(DeviceSceneCooperationCellInfo *)lastCellInfo{
    if (!_lastCellInfo) {
        _lastCellInfo = [DeviceSceneCooperationCellInfo new];
    }
    return _lastCellInfo;
}
-(DeviceSceneCooperationService *)lastService{
    if (!_lastService) {
        _lastService = [DeviceSceneCooperationService new];
    }
    return _lastService;
}
@end
