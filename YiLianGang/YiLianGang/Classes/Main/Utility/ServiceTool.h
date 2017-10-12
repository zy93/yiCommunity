//
//  ServiceTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceInfo.h"
@class ServiceLocationInfo;
typedef void(^LocationsBlock)(NSArray<ServiceLocationInfo*>* locations);

@interface ServiceTool : NSObject
+(instancetype)sharedServiceTool;

-(NSArray*)getAllService;
-(NSArray *)getALLProperty;
-(void)getAllServicePositionWithResponse:(LocationsBlock)response;
@end
@interface ServiceLocationInfo :NSObject
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *longitude;
@property(nonatomic,strong) NSString *latitude;
@end
