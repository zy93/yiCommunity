//
//  DeviceAddServiceBaseController.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTool.h"
#import "DeviceSceneTool.h"
#import "MyActivityIndicatorView.h"
#import "MBProgressHUD+KR.h"
#import "UIImageView+WebCache.h"
@protocol DeviceAddServiceBaseControllerDelegate<NSObject>
-(DeviceInfo*)deviceAddServiceBaseDeviceInfo:(id)controller;

-(void)device:(id)controller didCompleteWithService:(DeviceSceneCooperationService*)service;

@end
typedef void(^BLOCK) (DeviceSceneCooperationService* service);
@interface DeviceAddServiceBaseController : UITableViewController
-(instancetype)initWithDeviceInfo:(DeviceInfo*)info complete:(BLOCK)block;
@property(nonatomic,copy,readonly) BLOCK block;
@property(nonatomic,strong,readonly) DeviceInfo *deviceInfo;


@property(nonatomic,weak) id<DeviceAddServiceBaseControllerDelegate> serviceDelegate;
@property(nonatomic,strong,readonly) DeviceDetailInfo *detailInfo;

@property(nonatomic,strong) NSString *cooperationTitle;
/**
 点击右边按钮
 */
-(void)rightBarItemClicked;
/**
 子类需要根据操作设置一些参数
 */
@property(nonatomic,strong) DeviceSceneCooperationService *service;

/**
 字典转jason
 */
-(NSString*)dictionaryToJson:(NSDictionary *)dic;
@end
