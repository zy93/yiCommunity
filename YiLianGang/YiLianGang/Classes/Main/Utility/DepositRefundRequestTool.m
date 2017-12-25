//
//  DepositRefundRequestTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/15.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DepositRefundRequestTool.h"
#import "WN_YL_RequestTool.h"

static DepositRefundRequestTool *depositRefundRequestTool;

@interface DepositRefundRequestTool()<WN_YL_RequestToolDelegate>
@property (nonatomic, copy)DepositRefundFinishBlock block;
@property (nonatomic, strong) WN_YL_RequestTool *depositRefundRequest;
@end

@implementation DepositRefundRequestTool

+(instancetype)sharedDepositRefundTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        depositRefundRequestTool = [DepositRefundRequestTool new];
    });
    return depositRefundRequestTool;
}

-(void)sendDepositRefundRequestWithResponse:(DepositRefundFinishBlock)block
{
    self.block = block;
    self.depositRefundRequest = [WN_YL_RequestTool new];
    self.depositRefundRequest.delegate = self;
    [self.depositRefundRequest sendPostRequestWithUri:self.urlString andParam:self.parameterDict];
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.depositRefundRequest) {
        if (self.block) {
            self.block(dict);
        }
    }
}


@end
