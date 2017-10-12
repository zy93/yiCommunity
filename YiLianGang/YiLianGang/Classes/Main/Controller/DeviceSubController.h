//
//  DeviceSubController.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//
#warning 已弃用
#import <UIKit/UIKit.h>

@interface DeviceSubController : UIViewController
-(instancetype)initWithGroupId:(NSNumber *)groupId;
@property(nonatomic,weak) UIViewController *mainController;
@end
