//
//  CommandResult.h
//  DdtcBleSDK
//
//  Created by majianjie on 16/1/15.
//  Copyright © 2016年 ddtc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleConst.h"

@interface CommandResult : NSObject


@property(nonatomic) OPERRESULT result;
@property(nonatomic) BLESTATE state;
@property(nonatomic) BLECOMMAND command;

- (instancetype)init:(OPERRESULT)result state:(BLESTATE)state  command:(BLECOMMAND)command;

@end
