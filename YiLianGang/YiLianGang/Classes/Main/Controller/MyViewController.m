//
//  MyViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/10/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutBtn:(id)sender {
    [self goToLoginView];
}

-(void)goToLoginView{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userPwd"];
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginTableStoryboard" bundle:nil];
    
    
    UIViewController *vc = [[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]] ;
    
    [UIView transitionFromView:self.tabBarController.view
                        toView:vc.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
//         [[TabBarSetTool sharedTabBarSetTool]resetTabBar];
         [self dismissViewControllerAnimated:NO completion:nil];
         [UIApplication sharedApplication].keyWindow.rootViewController = vc;
         
     }];
    
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
