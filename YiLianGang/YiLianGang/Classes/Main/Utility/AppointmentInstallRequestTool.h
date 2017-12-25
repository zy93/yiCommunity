//
//  AppointmentInstallRequestTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/11.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^InstallFinishBlock) (NSDictionary *dict);

@interface AppointmentInstallRequestTool : NSObject

@property (nonatomic, strong) NSDictionary *parameterDict;
@property (nonatomic, strong) NSString *urlString;

+(instancetype)sharedInstallTool;

-(void)sendInstallRequestWithResponse:(InstallFinishBlock)block;

@end
