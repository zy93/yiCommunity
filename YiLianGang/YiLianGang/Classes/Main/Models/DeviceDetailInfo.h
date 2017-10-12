//
//  DeviceDetailInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
@interface DeviceDetailInfo : NSObject
-(instancetype)initWithDeviceInfo:(DeviceInfo*)deviceInfo;

@property(nonatomic,strong) NSString *infoName;
@property(nonatomic,strong) NSString *infoImageUrlStr;
@property(nonatomic,strong) NSString *infoDetailName;
@property(nonatomic,strong) NSString *infoDetailTypeName;

@end
