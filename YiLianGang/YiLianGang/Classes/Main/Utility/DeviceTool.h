//
//  DeviceTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
#import "DeviceGroupInfo.h"
#import "DeviceSendInfo.h"
#import "DeviceDetailInfo.h"
typedef void (^AddDeviceBlock)(NSDictionary *dict);
typedef void (^DeviceGroupBlock)(NSArray *arr);
typedef void (^DeleteDeviceBlock)(NSDictionary *dict);
typedef void (^PermissionDeviceBlock)(NSDictionary *dict);

@protocol DeviceToolDelegate<NSObject>
@optional
-(void)deviceToolDidReceiveGroupList:(BOOL)success dict:(NSDictionary*)dict;
@end
@interface DeviceTool : NSObject
+(instancetype)sharedDeviceTool;

-(NSArray*)getDeviceSegmentTitles;
-(NSArray*)deviceSegmentTitlesDeleteWithIndex:(NSUInteger)index;
-(NSArray*)deviceSegmentTitlesModifyWithIndex:(NSUInteger)index withStr:(NSString*)str;
-(NSArray*)deviceSegmentTitlesAddWithStr:(NSString*)str;
@property(nonatomic,strong,readonly) NSArray *allDevice;
@property(nonatomic,strong,readonly) NSArray<DeviceGroupInfo*> *allGroup;

@property(nonatomic,weak) id<DeviceToolDelegate> delegate;
//获取所有分组
-(void)sendRequestToGetAllGroupResponse:(DeviceGroupBlock)groupBlock;


//清除用户信息
-(void)clearGroupAndDeviceInfo;
//设备
@property(nonatomic,strong) DeviceSendInfo *deviceSendInfo;
//添加设备
-(void)sendInfoWithSendInfo:(DeviceSendInfo*)deviceSendInfo response:(AddDeviceBlock) block;
//删除设备
-(void)sendInfoWithThingId:(NSString *)thingId response:(DeleteDeviceBlock)block;

//授权设备给用户
-(void)sendPermissionWithThingId:(NSString *)thingId userTel:(NSString *)tel state:(BOOL)isPermission response:(PermissionDeviceBlock)block;

-(NSString *)imageAddExStr:(NSString *)imageStr;
@end
