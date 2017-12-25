//
//  GetDeviceInfoRequestTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/16.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GetDeviceInfoFinishBlock) (NSDictionary *dict);

@interface GetDeviceInfoRequestTool : NSObject

@property (nonatomic, strong) NSDictionary *parameterDict;
@property (nonatomic, strong) NSString *urlString;

+(instancetype)sharedGetDeviceInfoTool;

-(void)sendGetDeviceInfoRequestWithResponse:(GetDeviceInfoFinishBlock)block;


@end
