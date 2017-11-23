//
//  DepositRefundRequestTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/15.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^DepositRefundFinishBlock) (NSDictionary *dict);

@interface DepositRefundRequestTool : NSObject

@property (nonatomic, strong) NSDictionary *parameterDict;
@property (nonatomic, strong) NSString *urlString;

+(instancetype)sharedDepositRefundTool;

-(void)sendDepositRefundRequestWithResponse:(DepositRefundFinishBlock)block;

@end
