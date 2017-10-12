//
//  TabBarSetTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WN_YL_BaseModelTool.h"

@interface TabBarSetTool : NSObject
+(instancetype)sharedTabBarSetTool;
-(WN_YL_BaseTabController*)getTabBarController;
-(void)resetTabBar;
@end
