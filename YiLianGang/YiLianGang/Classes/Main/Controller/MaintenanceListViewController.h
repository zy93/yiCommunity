//
//  MaintenanceListViewController.h
//  YiLianGang
//
//  Created by 张雨 on 2017/3/17.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintenanceListViewController : UIViewController

-(void)refreshData;

-(void)gotoContentControllerWith:(NSDictionary *)dic;
-(void)gotoLoginVC;

@end
