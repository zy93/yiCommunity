//
//  TabBarSetTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "TabBarSetTool.h"
#import "WN_YL_BaseModelTool.h"

#import "HomePageController.h"
#import "PropertyViewController.h"
#import "ServiceController.h"
#import "DeviceController.h"
#import "PersonalInfoController.h"

#import "StyleTool.h"
#import "WeatherTool.h"
static TabBarSetTool *tabBarSetTool;
@interface TabBarSetTool()
@property(nonatomic,strong) WN_YL_BaseTabController *btc;

@end
@implementation TabBarSetTool
+(instancetype)sharedTabBarSetTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarSetTool = [TabBarSetTool new];
    });
    return tabBarSetTool;
}
-(void)resetTabBar{
    self.btc = nil;
    [[WN_YL_BaseModelTool sharedBaseModelTool]resetArr];
}
-(WN_YL_BaseTabController*)getTabBarController{
    if (self.btc) {
        return self.btc;
    }
    [[WeatherTool sharedWeatherTool]sendWeatherRequest];
    
    WN_YL_BaseTabControllerInfo *info = [[WN_YL_BaseTabControllerInfo alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[HomePageController new]];
    info.viewController = navi;
    info.title = @"首页";
    info.image = [UIImage imageNamed:@"main_tab00"];
    info.selectedImage = [UIImage imageNamed:@"main_tab00_ok"];
    
    WN_YL_BaseTabControllerInfo *info1 = [[WN_YL_BaseTabControllerInfo alloc]init];
    navi = [[UINavigationController alloc]initWithRootViewController:[PropertyViewController new]];
    info1.viewController = navi;
    info1.title = @"物业";
    info1.image = [UIImage imageNamed:@"tab_pro_w"];
    info1.selectedImage = [UIImage imageNamed:@"tab_pro"];
    
    WN_YL_BaseTabControllerInfo *info2 = [[WN_YL_BaseTabControllerInfo alloc]init];
    navi = [[UINavigationController alloc]initWithRootViewController:[DeviceController new]];
    info2.viewController = navi;
    info2.title = @"设备";
    info2.image = [UIImage imageNamed:@"main_tab22"];
    info2.selectedImage = [UIImage imageNamed:@"main_tab22_ok"];
    
    WN_YL_BaseTabControllerInfo *info3 = [[WN_YL_BaseTabControllerInfo alloc]init];
    navi = [[UINavigationController alloc]initWithRootViewController:[ServiceController new]];

    info3.viewController = navi;
    info3.title = @"服务";
    info3.image = [UIImage imageNamed:@"main_tab33"];
    info3.selectedImage = [UIImage imageNamed:@"main_tab33_ok"];
    
    WN_YL_BaseTabControllerInfo *info4 = [[WN_YL_BaseTabControllerInfo alloc]init];
    navi = [[UINavigationController alloc]initWithRootViewController:[UIStoryboard storyboardWithName:@"PersonalInfoController" bundle:nil].instantiateInitialViewController];

    info4.viewController = navi;
    info4.title = @"管理";
    info4.image = [UIImage imageNamed:@"main_tab44"];
    info4.selectedImage = [UIImage imageNamed:@"main_tab44_ok"];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isNeedHidden"]) {
        NSArray *arr = @[info2];
        
        [WN_YL_BaseModelTool sharedBaseModelTool].tabBarBackGroundColor = [[StyleTool sharedStyleTool]sessionSyle].tabBarColor;
        [WN_YL_BaseModelTool sharedBaseModelTool].tabTintColor = [[StyleTool sharedStyleTool]sessionSyle].tabBarTintColor;
        [WN_YL_BaseModelTool sharedBaseModelTool].tabSelectTintColor = [[StyleTool sharedStyleTool]sessionSyle].tabBarSelectTintColor;
        [WN_YL_BaseModelTool sharedBaseModelTool].isOnlyImage = YES;
        WN_YL_BaseTabController *btc = [[WN_YL_BaseModelTool sharedBaseModelTool]creatTabBarControllerWithArray:arr];
        self.btc = btc;
        return self.btc;
    }else{
        NSArray *arr = @[info,info1,info2,info3,info4];
        
        [WN_YL_BaseModelTool sharedBaseModelTool].tabBarBackGroundColor = [[StyleTool sharedStyleTool]sessionSyle].tabBarColor;
        [WN_YL_BaseModelTool sharedBaseModelTool].tabTintColor = [[StyleTool sharedStyleTool]sessionSyle].tabBarTintColor;
        [WN_YL_BaseModelTool sharedBaseModelTool].tabSelectTintColor = [[StyleTool sharedStyleTool]sessionSyle].tabBarSelectTintColor;
        [WN_YL_BaseModelTool sharedBaseModelTool].isOnlyImage = YES;
        WN_YL_BaseTabController *btc = [[WN_YL_BaseModelTool sharedBaseModelTool]creatTabBarControllerWithArray:arr];
        
        self.btc = btc;
        return self.btc;
    }
}
@end
