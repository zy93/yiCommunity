//
//  WN_YL_BaseTabController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/7/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WN_YL_BaseTabController.h"
#import "WN_YL_BaseModelTool.h"

@interface WN_YL_BaseTabController ()
@property(nonatomic,weak) NSArray *controllerArray;//这里必须为weak，才不会内存泄露
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSArray *imageArray;
@property(nonatomic,strong) NSArray *selectedImageArray;

@end

@implementation WN_YL_BaseTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabBarControllers];
    
        
    [self setUpTabBar];
    
    // Do any additional setup after loading the view.
}

-(void)setUpTabBarControllers{
    self.viewControllers = [WN_YL_BaseModelTool sharedBaseModelTool].baseControllerArray;
    
    self.titleArray = [WN_YL_BaseModelTool sharedBaseModelTool].tabTitleArray;
    self.imageArray = [WN_YL_BaseModelTool sharedBaseModelTool].tabImageArray;
    self.selectedImageArray = [WN_YL_BaseModelTool sharedBaseModelTool].tabSelectedImageArray;
    for (int i = 0; i<self.viewControllers.count;i++) {
        UIViewController *vc = self.viewControllers[i];
        vc.tabBarItem.title = self.titleArray[i];
        vc.tabBarItem.image = self.imageArray[i];
        vc.tabBarItem.selectedImage = self.selectedImageArray[i];
        if ([WN_YL_BaseModelTool sharedBaseModelTool].isOnlyImage) {
            vc.tabBarItem.title = @"";
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        }
    }
    
    self.selectedIndex = [WN_YL_BaseModelTool sharedBaseModelTool].selectIndex;
    
}

-(void)setUpTabBar{
    
    if ([WN_YL_BaseModelTool sharedBaseModelTool].tabBarBackGroundColor) {
        
        self.tabBar.barTintColor = [WN_YL_BaseModelTool sharedBaseModelTool].tabBarBackGroundColor;
//        self.tabBar.backgroundImage = [UIImage new];
    }
    if ([WN_YL_BaseModelTool sharedBaseModelTool].tabTintColor) {
        self.tabBar.tintColor = [WN_YL_BaseModelTool sharedBaseModelTool].tabTintColor;
    }
    if ([WN_YL_BaseModelTool sharedBaseModelTool].tabSelectTintColor) {
        self.tabBar.selectedImageTintColor = [WN_YL_BaseModelTool sharedBaseModelTool].tabSelectTintColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
