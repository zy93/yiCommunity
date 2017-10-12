//
//  DeviceFromGroupTool.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/22.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DeviceFromGroupTool.h"
#import "WN_YL_RequestTool.h"
#import "LoginTool.h"

@interface DeviceFromGroupTool()<WN_YL_RequestToolDelegate>
@property(nonatomic,copy) DeviceBlock deviceBlock;
@property(nonatomic,strong) WN_YL_RequestTool *allDeviceRequest;
@end
@implementation DeviceFromGroupTool
-(void)sendRequestToGetAllDeviceWithGroupId:(NSNumber *)groupId Response:(DeviceBlock)deviceBlock{
    self.deviceBlock = deviceBlock;
    self.allDeviceRequest = [WN_YL_RequestTool new];
    [self.allDeviceRequest sendGetRequestWithExStr:@"Service_Platform/group/deviceList.do" andParam:@{@"userId":[LoginTool sharedLoginTool].userID,@"groupId":groupId}];
    self.allDeviceRequest.delegate = self;
}
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.allDeviceRequest) {
        NSArray *arr = dict[@"data"];
        NSMutableArray *mutaArr;
        if (arr) {
            mutaArr = [NSMutableArray array];
            for (NSDictionary *dicIn in arr) {
                DeviceInfo *info = [DeviceInfo new];
                [info setValuesForKeysWithDictionary:dicIn];
#pragma mark域名替换
                //图片url
                if ([info.picUrl containsString:@"123.56.197.113"]) {
                    info.picUrl = [[info.picUrl stringByReplacingOccurrencesOfString:@"http:/123.56.197.113/" withString:HTTP_HOST]stringByReplacingOccurrencesOfString:@"http://123.56.197.113/" withString:HTTP_HOST];
                }
                //港ip
                if ([info.harborIp containsString:@"101.201.30.234"]) {
                    info.harborIp = [[info.harborIp stringByReplacingOccurrencesOfString:@"101.201.30.234:8080" withString:SOCKET_HOST]stringByReplacingOccurrencesOfString:@"101.201.30.234" withString:SOCKET_HOST];
                    
                }
                [mutaArr addObject:info];
            }
        }
        if (self.deviceBlock) {
            self.deviceBlock([mutaArr copy]);
        }

    }
}
@end
