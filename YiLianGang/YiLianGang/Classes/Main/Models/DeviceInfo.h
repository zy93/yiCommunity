//
//  DeviceInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DeviceInfo : NSObject

@property(nonatomic,strong) NSString *thingId;
@property(nonatomic,strong) NSString *templateId;
@property(nonatomic,strong) NSString *thingName;
@property(nonatomic,strong) NSString *harborIp;
@property(nonatomic,strong) NSString *picUrl;
@property(nonatomic,strong) NSNumber *state;
@property(nonatomic,strong) NSNumber *permission;

@end
