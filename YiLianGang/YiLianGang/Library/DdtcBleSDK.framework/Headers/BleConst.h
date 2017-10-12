//
//  BleConst.h
//  DdtcBleSDK
//
//  Created by majianjie on 16/1/14.
//  Copyright © 2016年 ddtc. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef ble_Const
#define ble_Const

//@interface BleConst:NSObject


// 状态码 回调方法用于判断的
#define BLE_OPEN            @"OPEN" // 蓝牙开启状态
#define BLE_CLOSE           @"CLOSE" // 蓝牙未开启状态

//进入后台
#define CLEANBLE          @"CleanBLE"


#define enumValueString(enum) ([@[@"success",@"errState",@"errUserCancelConnect",@"errUserCancelOper",@"errUserCancelScan",@"errBleNotOpen",@"errBleConnectFailed",@"errBleConnectingFailed",@"errBleOperingFailed",@"errNeedScan",@"errHasConnected",@"errDisCoverService",@"errDidUpdateNotification",@"errDidDiscoverCharacter",@"errDidUpdateValueForCharacter",@"errDidWriteValueForCharacter",@"errBleNoRssi",@"errBleConnectUnknownFailed",@"errBleDisconnetUnexpeced",@"errBleRetryButFaild",@"errBleLearnAddOK",@"errBleLearnAdded",@"errBleLearnAddFaild",@"errBleLearnDelOK",@"errBleLearnDeled",@"errBleLearnDelFaild"] objectAtIndex:enum])

#define enumStateString(enum) ([@[@"initing",@"inited",@"scaning",@"connecting",@"connected",@"opering",@"disconnecting"] objectAtIndex:enum])

#define enumCommandString(enum) ([@[@"onBleServiceFailed",@"onBleServiceFinish",@"scan", @"onScanFinish", @"connectex",@"onConnectFinish",@"onConnectFail",@"oper",@"onOperFinish", @"disconnect", @"onDisconnected"] objectAtIndex:enum])

/**操作结果*/
typedef enum{
    success,
    errState,
    errUserCancelConnect, // connect timeout
    errUserCancelOper, // oper timeout
    errUserCancelScan, // scan timeout
    errBleNotOpen,
    errBleConnectFailed, // didConnectFailed invoked
    errBleConnectingFailed, // didDisconnect invoked in connecting
    errBleOperingFailed, // didDisconnect invoked in opering/
    errNeedScan,
    errHasConnected,
    errDisCoverService,
    errDidUpdateNotification,
    errDidDiscoverCharacter,
    errDidUpdateValueForCharacter,
    errDidWriteValueForCharacter,
    errBleNoRssi,
    errBleConnectUnknownFailed,
    errBleDisconnetUnexpeced,
    errBleRetryButFaild,
    errBleLearnAddOK,  //学习成功
    errBleLearnAdded,  //学习过
    errBleLearnAddFaild,//学习失败
    errBleLearnDelOK,//删除成功
    errBleLearnDeled,//已经删除过
    errBleLearnDelFaild,//删除失败
    
    
} OPERRESULT;

#define operTypeString(type) [@[@"rise",@"drop",@"unlock_enable",@"unlock_disable"] objectAtIndex:type]



/**
 
 #define Manual_BEEon @""
 #define Manual_BEEoff @""
 
 #define Manual_ALARMon @""
 #define Manual_ALARMoff @""
 
 #define Manual_RFon @""
 #define Manual_RFoff @""
 
 */

typedef enum {
    
    rise,//升起
    drop, //降下
    unlock_enable,
    unlock_disable,
    BEEon,
    BEEoff,
    ALARMon,
    ALARMoff,
    RFon,
    RFoff,
    UP_AUTO_on,
    UP_AUTO_off,
    Order_Learn,
    Order_Delete
    
    
} OPERTYPE;



/** enum state **/
typedef enum {
    initing = 0,
    inited,
    scaning,
    connecting,
    connected,
    opering,
    disconnecting
} BLESTATE;

typedef enum {
    onBleServiceFailed = 0,
    onBleServiceFinish,
    scan,
    onScanFinish,
    connectex,
    onConnectFinish,
    onConnectFail,
    oper,
    onOperFinish,
    disconnect,
    onDisconnected
} BLECOMMAND;

#endif
