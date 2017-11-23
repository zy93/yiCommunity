//
//  OrderInquiryRequestTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/15.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OrderInquiryFinishBlock) (NSDictionary *dict);

@interface OrderInquiryRequestTool : NSObject

@property (nonatomic, strong) NSDictionary *parameterDict;
@property (nonatomic, strong) NSString *urlString;

+(instancetype)sharedOrderInquiryTool;

-(void)sendOrderInquiryRequestWithResponse:(OrderInquiryFinishBlock)block;

@end
