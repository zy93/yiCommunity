//
//  DeviceDetailBaseController.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTool.h"
#import "SRWebSocket.h"
#import "MyActivityIndicatorView.h"
#import "MBProgressHUD+KR.h"
@interface DeviceDetailBaseController : UITableViewController
@property(nonatomic,strong) DeviceInfo *deviceInfo;
@property(nonatomic,strong) MyActivityIndicatorView *myActivityIndicatorView;
@property(nonatomic,strong) SRWebSocket *webSocket;
@property(nonatomic,strong) NSDictionary *priceMessageDictionary;
@property(nonatomic,strong) NSDictionary *TDSMessageDictionary;
@property(nonatomic,strong) NSDictionary *fluxSumMessageDictionary;
@property(nonatomic,strong) NSDictionary *balanceMessageDictionary;
@property(nonatomic,strong) NSString *DeviceUrlStr;

-(void)sendWebSocketStringWithParam:(NSDictionary*)param;
-(NSString*)imageAddExStr:(NSString*)imageStr;
@end
