//
//  PropertyBillListRequestTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/18.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PropertyBillListFinishBlock) (NSDictionary *dict);

@interface PropertyBillListRequestTool : NSObject

@property (nonatomic, strong) NSDictionary *parameterDict;
@property (nonatomic, strong) NSString *urlString;

+(instancetype)sharedPropertyBillListTool;

-(void)sendPropertyBillListRequestWithResponse:(PropertyBillListFinishBlock)block;

@end
