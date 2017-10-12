//
//  DeviceSceneDeviceTypeView.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceSceneTool.h"
#import "DeviceTool.h"

typedef void(^BLOCK)();

@interface DeviceSceneDeviceTypeView : UIView
-(instancetype)initWithFrame:(CGRect)frame groupArray:(NSArray<DeviceGroupInfo*>*)groupArray didGetRelationDevice:(BLOCK)block;
@property(nonatomic,strong) NSString *conditionsRelation;

@property(nonatomic,assign,readonly) CGFloat viewHeight;

@property(nonatomic,strong) NSDictionary *conditions;
@property(nonatomic,strong) NSMutableArray<NSDictionary*> *conditionList;
@end
