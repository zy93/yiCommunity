//
//  OrderTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/10/25.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^OrderFinishBlock)(NSDictionary *dict);

@interface OrderTool : NSObject
@property(nonatomic, strong)NSDictionary *paramDictionary;

+(instancetype)sharedOrderTool;

//-(void)sendOrderRequestWithResponse:(OrderFinishBlock)block;
-(void)sendOrderRequest;

@end
