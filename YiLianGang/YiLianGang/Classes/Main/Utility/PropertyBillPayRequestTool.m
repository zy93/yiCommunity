//
//  PropertyBillPayRequestTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/29.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PropertyBillPayRequestTool.h"
#import "WN_YL_RequestTool.h"

static PropertyBillPayRequestTool *propertyBillPayRequestTool;

@interface PropertyBillPayRequestTool()<WN_YL_RequestToolDelegate>

@property (nonatomic, copy)PropertyBillPayFinishBlock block;
@property (nonatomic, strong)WN_YL_RequestTool *propertyBillPayRequest;

@end

@implementation PropertyBillPayRequestTool

+(instancetype)sharedPropertyBillPayTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyBillPayRequestTool = [PropertyBillPayRequestTool new];
    });
    return propertyBillPayRequestTool;
}

-(void)sendPropertyBillPayRequestWithResponse:(PropertyBillPayFinishBlock)block
{
    self.block = block;
    self.propertyBillPayRequest = [WN_YL_RequestTool new];
    self.propertyBillPayRequest.delegate = self;
    //[self.propertyBillPayRequest sendPostJsonRequestWithExStr:self.urlString andParam:self.parameterDict];
    [self.propertyBillPayRequest sendPostRequestWithUri:self.urlString andParam:self.parameterDict];
    
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict
{
    if (requestTool == self.propertyBillPayRequest) {
        if (self.block) {
            self.block(dict);
        }
    }
}

@end
