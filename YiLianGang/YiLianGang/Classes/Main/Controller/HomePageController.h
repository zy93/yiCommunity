//
//  HomePageController.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

//test test

#import "WN_YL_BaseViewController.h"

@interface HomePageController : UIViewController
@property (nonatomic, strong)UIViewController *mainController;

-(void)goToMaintenanceViewController;
-(void)goToShopViewController;
-(void)goToDDController;
-(void)goToPrintViewController;

@end
