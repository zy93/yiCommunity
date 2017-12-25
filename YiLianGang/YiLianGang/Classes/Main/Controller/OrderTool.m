//
//  OrderTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/25.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "OrderTool.h"
#import "WN_YL_RequestTool.h"
#import "NSString+JSON.h"

static OrderTool *orderTool;
@interface OrderTool()<WN_YL_RequestToolDelegate>

@property (nonatomic, strong)WN_YL_RequestTool *orderRequest;
@property (nonatomic, copy)OrderFinishBlock block;
@end
@implementation OrderTool

+(instancetype)sharedOrderTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderTool = [OrderTool new];
    });
    return orderTool;
    
}

-(void)sendOrderRequest
{
    //self.block = block;
    self.orderRequest = [WN_YL_RequestTool new];
    self.orderRequest.delegate = self;
//    [self.orderRequest sendPostRequestWithExStr:@"ReserveSever/Watersubscribe/add" andParam:self.paramDictionary];
    //sendPostRequestWithUri
    [self.orderRequest sendPostRequestWithUri:@"ReserveSever/Watersubscribe/add" andParam:self.paramDictionary];
}

-(void)requestTool:(WN_YL_RequestTool*)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary*)dict
{
    NSLog(@"返回信息%@",dict);
    BOOL isSuccess1;
    if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
       //  [ToastUtil showToast:@"预约成功！"];
        isSuccess1 = YES;
    }
    else
    {
        isSuccess1 = NO;
       // [ToastUtil showToast:@"预约失败！"];
    }
    
    if ([_delegate respondsToSelector:@selector(OrderToolDidmake:withDict:)]) {
        [_delegate OrderToolDidmake:isSuccess1 withDict:dict];
    }
}
@end
