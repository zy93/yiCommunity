//
//  DeviceTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceTool.h"
#import "WN_YL_RequestTool.h"
#import "LoginTool.h"
static DeviceTool *deviceTool;
@interface DeviceTool()<WN_YL_RequestToolDelegate>
@property(nonatomic,strong) NSArray *allDevice;
@property(nonatomic,strong) NSArray<DeviceGroupInfo*> *allGroup;

@property(nonatomic,strong) WN_YL_RequestTool *allDeviceGroupRequest;
@property(nonatomic,strong) WN_YL_RequestTool *modifyRequest;
@property(nonatomic,strong) WN_YL_RequestTool *addRequst;
@property(nonatomic,strong) WN_YL_RequestTool *deleteRequest;
@property(nonatomic,strong) WN_YL_RequestTool *addDeviceRequest;
@property(nonatomic,strong) WN_YL_RequestTool *deleteDeviceRequest;
@property(nonatomic,strong) WN_YL_RequestTool *permissionDeviceRequest;


@property(nonatomic,copy) AddDeviceBlock addDeviceBlock;
@property(nonatomic,copy) DeleteDeviceBlock deleteDeviceBlock;
@property(nonatomic,copy) DeviceGroupBlock groupBlock;
@property(nonatomic,copy) PermissionDeviceBlock permissionBlock;
@end
@implementation DeviceTool
+(instancetype)sharedDeviceTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceTool = [DeviceTool new];
    });
    return deviceTool;
}
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.allDeviceGroupRequest) {
        NSMutableArray *mutaArr = [NSMutableArray array];
        NSArray *arr = dict[@"data"];
        for (NSDictionary *dict in arr) {
            DeviceGroupInfo *info = [DeviceGroupInfo new];
            info.groupId = dict[@"groupId"];
            info.groupName = dict[@"groupName"];
            [mutaArr addObject:info];
            
        }
        self.allGroup = mutaArr;
        if (self.groupBlock) {
            self.groupBlock(self.allGroup);
        }
        [self.delegate deviceToolDidReceiveGroupList:isSuccess dict:dict];
        NSLog(@"%@",dict);
    }else if(requestTool == self.modifyRequest){
        NSLog(@"%@",dict);
    }else if(requestTool == self.addRequst){
        NSLog(@"%@",dict);
        self.allGroup = nil;
        [self getDeviceSegmentTitles];
    }else if(requestTool == self.deleteRequest){
        NSLog(@"%@",dict);
    }else if(requestTool == self.addDeviceRequest){
        NSLog(@"%@",dict);
        if (self.addDeviceBlock) {
            self.addDeviceBlock(dict);
        }
    }else if (requestTool == self.deleteDeviceRequest){
        if (self.deleteDeviceBlock) {
            self.deleteDeviceBlock(dict);
        }
    }
    else if (requestTool == self.permissionDeviceRequest) {
        if (self.permissionBlock) {
            self.permissionBlock(dict);
        }
    }
    
}
-(NSString *)imageAddExStr:(NSString *)imageStr{
    NSString *exStr = [imageStr pathExtension];
    NSString *temp = [imageStr stringByDeletingPathExtension];
    temp = [temp stringByAppendingString:@"1"];
    temp = [temp stringByAppendingPathExtension:exStr];
    if (![temp containsString:@"http://"]&&[temp containsString:@"http:/"]) {
        temp = [temp stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
    }
    if (![temp containsString:@"https://"]&&[temp containsString:@"https:/"]) {
        temp = [temp stringByReplacingOccurrencesOfString:@"https:/" withString:@"https://"];
    }
    return temp;
}

#pragma mark - 获取组的信息
-(NSArray*)getDeviceSegmentTitles{
    if(self.allGroup){
        return self.allGroup;
    }
    [self sendRequestToGetAllGroupResponse:nil];

    NSMutableArray *mutaArr = [NSMutableArray array];
    DeviceGroupInfo *info = [DeviceGroupInfo new];
    info.groupId = @"1";
    info.groupName = @"我的家";
    [mutaArr addObject:info];
    
    self.allGroup = mutaArr;
    return self.allGroup;
}

#pragma mark  - 获取所有组的网络请求
-(void)sendRequestToGetAllGroupResponse:(DeviceGroupBlock)groupBlock{
    [self.allDeviceGroupRequest sendGetRequestWithExStr:@"Service_Platform/group/all.do"
                                               andParam:@{@"userId":[LoginTool sharedLoginTool].userID}];
    self.allDeviceGroupRequest.delegate = self;

    self.groupBlock = groupBlock;
    
}

-(NSArray*)deviceSegmentTitlesDeleteWithIndex:(NSUInteger)index{
    if (!self.allGroup) {
        return nil;
    }
    if (index>self.allGroup.count-1) {
        return self.allGroup;
    }
    DeviceGroupInfo *info = self.allGroup[index];
    self.deleteRequest = [[WN_YL_RequestTool alloc] init];
    [self.deleteRequest sendPostRequestWithExStr:@"Service_Platform/group/delete.do" andParam:@{@"groupId":info.groupId}];
    self.deleteRequest.delegate = self;
    NSMutableArray *mutaArr = [NSMutableArray arrayWithArray:self.allGroup];
    [mutaArr removeObjectAtIndex:index];
    self.allGroup = mutaArr;
    return self.allGroup;
}
-(NSArray *)deviceSegmentTitlesModifyWithIndex:(NSUInteger)index withStr:(NSString *)str{
    if (!self.allGroup) {
        return nil;
    }
    if (index>self.allGroup.count-1) {
        return self.allGroup;
    }
    DeviceGroupInfo *info = self.allGroup[index];
    self.modifyRequest = [[WN_YL_RequestTool alloc] init];
    [self.modifyRequest sendPostRequestWithExStr:@"Service_Platform/group/update.do" andParam:@{@"groupId":info.groupId,@"groupName":str}];
    self.modifyRequest.delegate = self;
    NSMutableArray *mutaArr = [NSMutableArray arrayWithArray:self.allGroup];
    DeviceGroupInfo *newInfo = [DeviceGroupInfo new];
    newInfo.groupName = str;
    [mutaArr replaceObjectAtIndex:index withObject:newInfo];
    self.allGroup = mutaArr;
    return self.allGroup;
}
-(NSArray*)deviceSegmentTitlesAddWithStr:(NSString*)str{
    self.addRequst = [[WN_YL_RequestTool alloc] init];
    [self.addRequst sendPostRequestWithExStr:@"Service_Platform/group/add.do" andParam:@{@"userId":[NSNumber numberWithInt:[LoginTool sharedLoginTool].userID.intValue],@"groupName":str}];
    self.addRequst.delegate = self;
    NSMutableArray *mutaArr = [NSMutableArray arrayWithArray:self.allGroup];
    DeviceGroupInfo *info = [DeviceGroupInfo new];
    info.groupId = 0;
    info.groupName = str;
    [mutaArr addObject:info];
    self.allGroup = mutaArr;
    return self.allGroup;
}
-(void)sendInfoWithSendInfo:(DeviceSendInfo *)deviceSendInfo response:(void (^)(NSDictionary *))block{
    self.addDeviceBlock = block;
    NSMutableDictionary *sendDict = [@{@"userId":deviceSendInfo.userId,
                                       @"groupId":deviceSendInfo.groupId,
                                       @"country":deviceSendInfo.country,
                                       @"province":deviceSendInfo.province,
                                       @"city":deviceSendInfo.city,
                                       @"county":deviceSendInfo.county,
                                       @"community":deviceSendInfo.community,
                                       @"detailLocation":deviceSendInfo.detailLocation,
                                       @"thingName":deviceSendInfo.thingName,
                                       @"localID":deviceSendInfo.localID,
                                       @"producer":deviceSendInfo.producer,
                                       @"type":deviceSendInfo.type,
                                       @"model":deviceSendInfo.model,
                                       @"produceTime":deviceSendInfo.ProduceTime} mutableCopy];
    if (deviceSendInfo.ip && deviceSendInfo.userName && deviceSendInfo.password) {
        [sendDict setValuesForKeysWithDictionary:@{@"ip":deviceSendInfo.ip,@"userName":deviceSendInfo.userName,@"password":deviceSendInfo.password}];
    }
    
    [self.addDeviceRequest sendPostJsonRequestWithExStr:@"Service_Platform/pe/appregister.do" andParam:sendDict];
    
    self.addDeviceRequest.delegate = self;
}

-(void)sendInfoWithThingId:(NSString *)thingId response:(DeleteDeviceBlock)block{
    self.deleteDeviceBlock = block;
    self.deleteDeviceRequest = [WN_YL_RequestTool new];
    [self.deleteDeviceRequest sendPostJsonRequestWithExStr:@"Service_Platform/pe/delete.do" andParam:@{@"thingId":thingId,@"userId":[LoginTool sharedLoginTool].userID}];
    self.deleteDeviceRequest.delegate = self;
}

-(void)sendPermissionWithThingId:(NSString *)thingId userTel:(NSString *)tel state:(BOOL)isPermission response:(PermissionDeviceBlock)block
{
    self.permissionBlock = block;
    self.permissionDeviceRequest = [WN_YL_RequestTool new];
    int state = isPermission ? 1 : 0;//授权 : 取消授权
    tel = strIsEmpty(tel) ? @"" : tel;
    thingId = strIsEmpty(thingId)? @"" : thingId;
    [self.permissionDeviceRequest sendPostRequestWithExStr:@"Service_Platform/thing/thingPermission.do" andParam:@{@"userId":[LoginTool sharedLoginTool].userID, @"state":@(state), @"permissionUser":tel, @"thingId":thingId}];
    self.permissionDeviceRequest.delegate = self;
}

-(void)clearGroupAndDeviceInfo{
    //清除分组和设备信息
    self.allGroup = nil;
    self.allDevice = nil;
    
}
- (WN_YL_RequestTool *)allDeviceGroupRequest {
	if(_allDeviceGroupRequest == nil) {
		_allDeviceGroupRequest = [[WN_YL_RequestTool alloc] init];
	}
	return _allDeviceGroupRequest;
}
-(WN_YL_RequestTool *)addDeviceRequest{
    if (_addDeviceRequest == nil) {
        _addDeviceRequest = [[WN_YL_RequestTool alloc]init];
    }
    return _addDeviceRequest;
}
-(DeviceSendInfo *)deviceSendInfo{
    if (!_deviceSendInfo) {
        _deviceSendInfo = [DeviceSendInfo new];
    }
    return _deviceSendInfo;
}
@end
