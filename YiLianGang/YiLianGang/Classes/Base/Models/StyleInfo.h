//
//  StyleInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/16.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface StyleInfo : NSObject
/**开机图*/
@property(nonatomic,strong) UIImage *welcomeImage;
/**整体色调*/
@property(nonatomic,strong) UIColor *welcomeColor;
/**导航条颜色*/
@property(nonatomic,strong) UIColor *naviColor;
/**logo图*/
@property(nonatomic,strong) UIImage *logoImage;
/**tabBar颜色*/
@property(nonatomic,strong) UIColor *tabBarColor;
/**tabBar控件着色*/
@property(nonatomic,strong) UIColor *tabBarTintColor;
/**tabBar选择的控件着色*/
@property(nonatomic,strong) UIColor *tabBarSelectTintColor;

/**设备界面的SegmentLine颜色*/
@property(nonatomic,strong) UIColor *segmentLineColor;
/**设备界面的头header颜色*/
@property(nonatomic,strong) UIColor *headerColor;
/**按钮按下颜色*/
@property(nonatomic,strong) UIColor *hightlightColor;
@end
