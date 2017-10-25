//
//  ServiceReturnInformation.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/20.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "ServiceReturnInformation.h"
static ServiceReturnInformation *returnInfo;
@implementation ServiceReturnInformation

+(instancetype)sharedReturnInfo{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        returnInfo = [ServiceReturnInformation new];
    });
    return returnInfo;
}

@end
