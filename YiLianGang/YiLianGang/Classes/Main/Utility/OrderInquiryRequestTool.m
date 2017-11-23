//
//  OrderInquiryRequestTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/15.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "OrderInquiryRequestTool.h"
#import "WN_YL_RequestTool.h"

static OrderInquiryRequestTool *orderInquiryRequestTool;

@interface  OrderInquiryRequestTool()<WN_YL_RequestToolDelegate>

@property (nonatomic, copy)OrderInquiryFinishBlock block;
@property (nonatomic, strong) WN_YL_RequestTool *orderInquiryRequest;

@end

@implementation OrderInquiryRequestTool

+(instancetype)sharedOrderInquiryTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderInquiryRequestTool = [OrderInquiryRequestTool new];
    });
    return orderInquiryRequestTool;
}

-(void)sendOrderInquiryRequestWithResponse:(OrderInquiryFinishBlock)block
{
    self.block = block;
    self.orderInquiryRequest = [WN_YL_RequestTool new];
    self.orderInquiryRequest.delegate = self;
    [self.orderInquiryRequest sendPostRequestWithUri:self.urlString andParam:self.parameterDict];
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.orderInquiryRequest) {
        if (self.block) {
            self.block(dict);
        }
    }
}

@end
