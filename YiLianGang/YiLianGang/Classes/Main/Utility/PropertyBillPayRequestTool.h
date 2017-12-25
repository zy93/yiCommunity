//
//  PropertyBillPayRequestTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/29.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PropertyBillPayFinishBlock) (NSDictionary *dict);

@interface PropertyBillPayRequestTool : NSObject

@property (nonatomic, strong) NSDictionary *parameterDict;
@property (nonatomic, strong) NSString *urlString;

+(instancetype)sharedPropertyBillPayTool;

-(void)sendPropertyBillPayRequestWithResponse:(PropertyBillPayFinishBlock)block;

@end
