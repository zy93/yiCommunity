//
//  GetDeviceInfoRequestTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/16.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "GetDeviceInfoRequestTool.h"
#import "WN_YL_RequestTool.h"

static GetDeviceInfoRequestTool *getDeviceInfoRequestTool;
@interface GetDeviceInfoRequestTool()<WN_YL_RequestToolDelegate>
@property (nonatomic, copy)GetDeviceInfoFinishBlock block;
@property (nonatomic, strong) WN_YL_RequestTool *getDeviceInfoRequest;
@end

@implementation GetDeviceInfoRequestTool

+(instancetype)sharedGetDeviceInfoTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getDeviceInfoRequestTool = [GetDeviceInfoRequestTool new];
    });
    return getDeviceInfoRequestTool;
}

-(void)sendGetDeviceInfoRequestWithResponse:(GetDeviceInfoFinishBlock)block
{
    self.block = block;
    self.getDeviceInfoRequest = [WN_YL_RequestTool new];
    self.getDeviceInfoRequest.delegate = self;
    [self.getDeviceInfoRequest sendPostJsonRequestWithExStr:self.urlString andParam:self.parameterDict];
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.getDeviceInfoRequest) {
        if (self.block) {
            self.block(dict);
        }
    }
}

@end
