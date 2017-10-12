//
//  MaintenanceListViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/17.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MaintenanceListViewController.h"
#import "MaintenanceContentController.h"
#import "MaintenanceListView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+KR.h"
#import "WN_YL_RequestTool.h"
#import "TabBarSetTool.h"


@interface MaintenanceListViewController ()<WN_YL_RequestToolDelegate>
{
    MaintenanceListView *mView;
    WN_YL_RequestTool *request;
    UIButton *mLogoutBtn;

}
@end

@implementation MaintenanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"维修列表";
    mView = [[MaintenanceListView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mView];
    [self createRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mLogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mLogoutBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-20-45, 5, 45, 30)];
    [mLogoutBtn setTitle:@"登出" forState:UIControlStateNormal];
    [mLogoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:mLogoutBtn];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mView StartRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [mLogoutBtn removeFromSuperview];
}

-(void)createRequest
{
    //
    request = [WN_YL_RequestTool new];
    request.delegate = self;
    [request sendPostRequestWithUri:@"WY/info/info_selectAll" andParam:nil];
}

-(void)logout:(UIButton *)sender
{
    [self gotoLoginVC];
}

-(void)refreshData
{
    [self createRequest];
}


-(void)gotoContentControllerWith:(NSDictionary *)dic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MaintenanceContentController *vc = [[MaintenanceContentController alloc] init];
        vc.mContent = dic;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

-(void)gotoLoginVC
{
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
         [self dismissViewControllerAnimated:NO completion:nil];
         [UIApplication sharedApplication].keyWindow.rootViewController = vc;
         
     }];
    
}


#pragma mark - request delegate
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    __weak MaintenanceListView *weak_view = mView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weak_view setData:dict[@"msg"]];
    });
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
