//
//  MaintenanceViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/16.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MaintenanceViewController.h"
#import "MaintenanceView.h"
#import "MaintenanceHistoryViewController.h"

@interface MaintenanceViewController ()
{
    MaintenanceView *mMaintenanceView;
    UIButton *back;
}

@end

@implementation MaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报事报修";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SkipNotificationAction:)
                                                 name:@"skipNotification"
                                               object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    mMaintenanceView = [[MaintenanceView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, CGRectGetHeight(self.view.frame))];
    [self.view addSubview:mMaintenanceView];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    back = [UIButton buttonWithType:UIButtonTypeCustom];
    //替换图标
    [back setImage:[UIImage imageNamed:@"listwwhite"] forState:UIControlStateNormal];
    [back setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-50,  0, 40, 45)];
    [back addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:back];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [back removeFromSuperview];
}

-(void)history:(UIButton *)sender
{
    //
    MaintenanceHistoryViewController *vc = [MaintenanceHistoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showSelectImageVC
{
    [self preferredStatusBarStyle];
    __weak typeof(self)weakVc = self;
    if (weakVc != nil) {
        [weakVc presentViewController:self animated:YES completion:nil];
    }
}

-(void)SkipNotificationAction:(NSNotification *)notification
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"skipNotification" object:nil];

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
