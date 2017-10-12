//
//  DeviceOKATool.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/14.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceOKATool.h"
#import "WN_YL_RequestTool.h"
#import "LoginTool.h"
static DeviceOKATool *instance;
@interface DeviceOKATool()<WN_YL_RequestToolDelegate>

@property(nonatomic,copy) OKABlock getListBlock;
@property(nonatomic,copy) OKABlock deleteBlock;
@property(nonatomic,copy) OKABlock executeBlock;
@property(nonatomic,copy) OKABlock registerBlock;

@property(nonatomic,strong) WN_YL_RequestTool *getRequest;
@property(nonatomic,strong) WN_YL_RequestTool *deleteRequest;
@property(nonatomic,strong) WN_YL_RequestTool *executeRequest;
@property(nonatomic,strong) WN_YL_RequestTool *registerRequest;

@end
@implementation DeviceOKATool
+(instancetype)sharedDeviceOKATool{
    if (!instance) {
        instance = [DeviceOKATool new];
    }
    return instance;
}
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    
    if (self.getRequest == requestTool) {
        if (self.getListBlock) {
            
            self.getListBlock(dict);
        }
    }else if(self.deleteRequest == requestTool) {
        if (self.deleteBlock) {
            self.deleteBlock(dict);
        }
    }else if (self.executeRequest == requestTool) {
        if (self.executeBlock) {
            self.executeBlock(dict);
        }
    }else if (self.registerRequest == requestTool) {
        if (self.registerBlock) {
            self.registerBlock(dict);
        }
    }
}
-(void)sendRequestToGetOKAListWithResponse:(OKABlock)block{
    self.getListBlock = block;
    self.getRequest = [WN_YL_RequestTool new];
    self.getRequest.delegate = self;
    [self.getRequest sendGetRequestWithExStr:@"Service_Platform/scene/all.do" andParam:@{@"userId":[LoginTool sharedLoginTool].userID}];
    
}
-(void)sendRequestToDeleteOKAWithSceneId:(NSNumber *)number response:(OKABlock)block{
    self.deleteBlock = block;
    self.deleteRequest = [WN_YL_RequestTool new];
    self.deleteRequest.delegate = self;
    [self.deleteRequest sendPostRequestWithExStr:@"Service_Platform/scene/delete.do" andParam:@{@"sceneId":number}];
}

-(void)sendRequestToExecuteOKAWithSceneId:(NSNumber *)number response:(OKABlock)block{
    self.executeBlock = block;
    self.executeRequest = [WN_YL_RequestTool new];
    self.executeRequest.delegate = self;
    [self.executeRequest sendPostRequestWithExStr:@"Service_Platform/scene/execute.do" andParam:@{@"sceneId":number}];
    
}
-(void)sendRequestToRegisterOKAWithName:(NSString *)name services:(NSArray<DeviceSceneCooperationService*>*)serviceArr response:(OKABlock)block{
    self.registerBlock = block;
    self.registerRequest = [WN_YL_RequestTool new];
    self.registerRequest.delegate = self;
    NSNumber *userId = [NSNumber numberWithInteger:[LoginTool sharedLoginTool].userID.integerValue];
    NSMutableArray *mutaArr = [NSMutableArray array];
    for (DeviceSceneCooperationService *service in serviceArr) {
        NSDictionary *dict = @{@"thingId":service.thingId,
                               @"serviceId":service.serviceId,
                               @"serviceParam":service.serviceParam,
                               @"number":service.number,
                               @"harborIp":service.harborIp,
                               @"delayTime":service.delayTime,};
        [mutaArr addObject:dict];
    }
    
    [self.registerRequest sendPostJsonRequestWithExStr:@"Service_Platform/scene/add.do" andParam:@{@"userId":userId,@"sceneName":name,@"sceneServices":mutaArr}];
}
@end

@implementation DeviceOKAInfo

@end
