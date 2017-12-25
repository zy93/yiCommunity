//
//  OrderTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/10/25.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^OrderFinishBlock)(NSDictionary *dict);

@protocol OrderToolDelegate<NSObject>
-(void)OrderToolDidmake:(BOOL)isSuccess withDict:(NSDictionary*)dict;
@end

@interface OrderTool : NSObject
@property(nonatomic, strong)NSDictionary *paramDictionary;
@property(nonatomic, weak)id <OrderToolDelegate> delegate;

+(instancetype)sharedOrderTool;

//-(void)sendOrderRequestWithResponse:(OrderFinishBlock)block;
-(void)sendOrderRequest;

@end
