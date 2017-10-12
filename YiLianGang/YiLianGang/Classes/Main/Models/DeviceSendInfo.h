//
//  DeviceSendInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/9/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceSendInfo : NSObject
/**生产时间*/
@property(nonatomic,strong) NSString *ProduceTime;
/**设备唯一标识*/
@property(nonatomic,strong) NSString *localID;
/**型号*/
@property(nonatomic,strong) NSString *model;
/**设备生产厂商*/
@property(nonatomic,strong) NSString *producer;
/**类型*/
@property(nonatomic,strong) NSString *type;
/**用户id*/
@property(nonatomic,strong) NSNumber *userId;
#pragma 以下是本地输入设置的
/**设备名称*/
@property(nonatomic,strong) NSString *thingName;
/**分组*/
@property(nonatomic,strong) NSNumber *groupId;
/**国家*/
@property(nonatomic,strong) NSString *country;
/**省份*/
@property(nonatomic,strong) NSString *province;
/**城市*/
@property(nonatomic,strong) NSString *city;
/**区县*/
@property(nonatomic,strong) NSString *county;
/**社区*/
@property(nonatomic,strong) NSString *community;
/**详细地址*/
@property(nonatomic,strong) NSString *detailLocation;
#pragma 以下是摄像头专用
@property(nonatomic,strong) NSString *ip;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *password;
@end
