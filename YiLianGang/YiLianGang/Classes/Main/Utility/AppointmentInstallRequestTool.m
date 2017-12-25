//
//  AppointmentInstallRequestTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/11.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "AppointmentInstallRequestTool.h"
#import "WN_YL_RequestTool.h"

static AppointmentInstallRequestTool *installRequestTool;
@interface AppointmentInstallRequestTool()<WN_YL_RequestToolDelegate>
@property (nonatomic, copy)InstallFinishBlock block;
@property (nonatomic, strong) WN_YL_RequestTool *installRequest;

@end

@implementation AppointmentInstallRequestTool


+(instancetype)sharedInstallTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        installRequestTool = [AppointmentInstallRequestTool new];
    });
    return installRequestTool;
}

-(void)sendInstallRequestWithResponse:(InstallFinishBlock)block
{
    self.block = block;
    self.installRequest = [WN_YL_RequestTool new];
    self.installRequest.delegate = self;
    [self.installRequest sendPostRequestWithUri:self.urlString andParam:self.parameterDict];
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.installRequest) {
        if (self.block) {
            self.block(dict);
        }
    }
}

@end
