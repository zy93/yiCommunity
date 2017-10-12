//
//  ServiceTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "ServiceTool.h"
#import "WN_YL_RequestTool.h"
static ServiceTool *serviceTool;
@interface ServiceTool()<WN_YL_RequestToolDelegate>
@property(nonatomic,strong) WN_YL_RequestTool *serviceRequestTool;
@property(nonatomic,copy) LocationsBlock response;
@end
@implementation ServiceTool
+(instancetype)sharedServiceTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceTool = [ServiceTool new];
    });
    return serviceTool;
}
-(WN_YL_RequestTool *)serviceRequestTool{
    if (!_serviceRequestTool) {
        _serviceRequestTool = [WN_YL_RequestTool new];
        _serviceRequestTool.delegate = self;
    }
    return _serviceRequestTool;
}
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.serviceRequestTool) {
        if (dict && [dict[@"error_code"]integerValue]==0) {
            
        }
    }
}
-(NSArray *)getAllService{
    NSMutableArray *mutaArr = [NSMutableArray array];
    ServiceInfo *info = [ServiceInfo new];
    info.serviceName = @"洗衣";
    info.serviceImage = [UIImage imageNamed:@"service洗衣机"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"云打印";
    info.serviceImage = [UIImage imageNamed:@"service云文印"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"自动售卖";
    info.serviceImage = [UIImage imageNamed:@"service自动售卖"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"丁丁停车";
    info.serviceImage = [UIImage imageNamed:@"service充电洗车"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"家政";
    info.serviceImage = [UIImage imageNamed:@"service家政"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"外卖";
    info.serviceImage = [UIImage imageNamed:@"service外卖"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"物业";
    info.serviceImage = [UIImage imageNamed:@"service物业"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"更多服务";
    info.serviceImage = [UIImage imageNamed:@"service其它"];
    info.presentController = nil;
    [mutaArr addObject:info];
    return [mutaArr copy];
}

-(NSArray *)getALLProperty
{
    NSMutableArray *mutaArr = [NSMutableArray array];
    ServiceInfo *info = [ServiceInfo new];
    info.serviceName = @"报事报修";
    info.serviceImage = [UIImage imageNamed:@"报事报修-彩色"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"服务监督";
    info.serviceImage = [UIImage imageNamed:@"考勤管理-彩"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"访客邀请";
    info.serviceImage = [UIImage imageNamed:@"访客邀请-彩"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    info = [ServiceInfo new];
    info.serviceName = @"生活缴费";
    info.serviceImage = [UIImage imageNamed:@"缴费-彩"];
    info.presentController = nil;
    [mutaArr addObject:info];
    
    return [mutaArr copy];
}


-(void)getAllServicePositionWithResponse:(LocationsBlock)response{
    self.response = response;
    [self.serviceRequestTool sendGetRequestWithExStr:@"Service_Platform/thing/public.do" andParam:nil];
}
@end
