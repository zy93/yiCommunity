//
//  PropertyBillListRequestTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/18.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PropertyBillListRequestTool.h"
#import "WN_YL_RequestTool.h"

static PropertyBillListRequestTool *propertyBillListRequestTool;

@interface PropertyBillListRequestTool()<WN_YL_RequestToolDelegate>

@property (nonatomic, copy)PropertyBillListFinishBlock block;
@property (nonatomic, strong) WN_YL_RequestTool *propertyBillListRequest;

@end

@implementation PropertyBillListRequestTool

+(instancetype)sharedPropertyBillListTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyBillListRequestTool = [PropertyBillListRequestTool new];
    });
    return propertyBillListRequestTool;
}

-(void)sendPropertyBillListRequestWithResponse:(PropertyBillListFinishBlock)block
{
    self.block = block;
    self.propertyBillListRequest = [WN_YL_RequestTool new];
    self.propertyBillListRequest.delegate = self;
    [self.propertyBillListRequest sendPostJsonRequestWithExStr:self.urlString andParam:self.parameterDict];
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.propertyBillListRequest) {
        if (self.block) {
            self.block(dict);
        }
    }
}
@end
