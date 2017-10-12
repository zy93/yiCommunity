//
//  DeviceSceneInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DeviceSceneConditionsInfo;

@class DeviceSceneCooperationService;


@interface DeviceSceneInfo : NSObject
@property(nonatomic,strong) NSNumber *cooperationId;
@property(nonatomic,strong) NSString *cooperationName;
@property(nonatomic,strong) NSString *state;
@property(nonatomic,strong) NSString *conditionType;
@property(nonatomic,strong) NSString *exeFrequency;
@property(nonatomic,strong) NSString *time;
//@property(nonatomic,strong) DeviceSceneConditionsInfo *conditions;
@property(nonatomic,strong) NSString *conditionsRelation;
@property(nonatomic,strong) NSArray *conditionList;

@end

@interface DeviceSceneConditionsInfo : NSObject
@property(nonatomic,strong) NSString *conditionsRelation;
@property(nonatomic,strong) NSArray *conditionList;
@end
@interface DeviceSceneConditionListInfo : NSObject
@property(nonatomic,strong) NSString *thingId;
@property(nonatomic,strong) NSString *serviceId;
@property(nonatomic,strong) NSString *harborIp;
@property(nonatomic,strong) NSString *param;
@property(nonatomic,strong) NSString *paramComment;
@property(nonatomic,strong) NSString *value;
@property(nonatomic,strong) NSString *relation;
@end

@interface DeviceSceneRegisterInfo : NSObject
@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,strong) NSString *cooperationName;
@property(nonatomic,strong) NSString *conditionType;
@property(nonatomic,strong) NSString *exeFrequency;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSDictionary *conditions;
@property(nonatomic,strong) NSArray *cooperationServices;

@end



@interface DeviceSceneCooperationService : NSObject
@property(nonatomic,strong) NSString *thingId;
@property(nonatomic,strong) NSString *serviceId;//设置获取
@property(nonatomic,strong) NSString *serviceParam;//设置获取
@property(nonatomic,strong) NSNumber *number;
@property(nonatomic,strong) NSString *harborIp;
@property(nonatomic,strong) NSNumber *delayTime;//设置获取

@end

@interface DeviceSceneCooperationCellInfo :NSObject
@property(nonatomic,strong) NSString *imageUrlStr;
@property(nonatomic,strong) NSString *cooperationTitle;
@property(nonatomic,strong) NSString *groupName;
@property(nonatomic,strong) NSString *detailTitle;
@property(nonatomic,strong) NSString *typeTitle;
@end

