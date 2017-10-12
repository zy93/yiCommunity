//
//  BleOper.h
//  DdtcBleSDK
//
//  Created by majianjie on 16/1/20.
//  Copyright © 2016年 ddtc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleConst.h"
#import "CommandResult.h"

typedef enum {
    
    NotLearn,
    Learn
    
} UserOperType;


@protocol BleOperDelegate <NSObject>

/** 操作结果  信号值  地锁电量 
    
     升降地锁
     开关手动解锁
     开关扬声器
     开关警报
     开关射频遥控器
     开关自动升降

 */
- (void)operResult:(NSString *)reason rssi:(NSString *)rssi battery:(NSString *)battery;


/**学习的回调   学习的结果  学习的这个指令的名字  */
- (void)learnResult:(NSString *)learnResult  index:(NSString *)index value:(NSString *)value;

- (NSString *)getDeletekeyIndex;

@end

@interface BleOper : NSObject



- (instancetype)initWithDelegate:(id<BleOperDelegate>)delegate;

/** 代理*/
@property (nonatomic,assign)id<BleOperDelegate> delegate;
/** 电量*/
@property(nonatomic,strong) NSString* battery;

/**  userOperType 为 learn 和 非 learn*/
@property (nonatomic,assign)UserOperType userOperType;

/**
    升降地锁
    开关手动解锁
    开关扬声器
    开关警报
    开关射频遥控器
    开关自动升降
 
 */
- (NSString *) operBleWithType:(OPERTYPE)operType lockId:(NSString *)lockId andPreFix:(NSString *)preFix andScanTimeOut:(int)scanTimeout andConnectTimeOut:(float)connectTimeout andOperTimeOut:(CGFloat)operTimeout;

/**
    自动学习功能
 */
- (NSString *) learnBleWithType:(OPERTYPE)operType lockId:(NSString *)lockId andPreFix:(NSString *)preFix andScanTimeOut:(int)scanTimeout andConnectTimeOut:(float)connectTimeout andOperTimeOut:(CGFloat)operTimeout;


- (NSString *) learnBleWithType:(OPERTYPE)operType lockId:(NSString *)lockId andPreFix:(NSString *)preFix andScanTimeOut:(int)scanTimeout andConnectTimeOut:(float)connectTimeout andOperTimeOut:(CGFloat)operTimeout andKeyIndex:(NSString*) keyIndex;



@end
