//
//  MaintenanceHistoryViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/31.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MaintenanceHistoryViewController.h"
#import "MaintenanceHistoryView.h"
#import "HistoryContentViewController.h"
#import "WN_YL_RequestTool.h"
#import "LoginTool.h"

@interface MaintenanceHistoryViewController ()<WN_YL_RequestToolDelegate>
{
    MaintenanceHistoryView *mView;
    WN_YL_RequestTool *request;
}
@end

@implementation MaintenanceHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史记录";
    self.view.backgroundColor = [UIColor whiteColor];
    request = [WN_YL_RequestTool new];
    request.delegate = self;
    [self createSubview];
    [self createRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSubview
{
    mView = [[MaintenanceHistoryView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mView];
}

-(void)refreshData
{
    [self createRequest];
}

-(void)createRequest
{
    NSDictionary *dic = @{@"phone":[LoginTool sharedLoginTool].userTel};
    [request sendPostRequestWithUri:@"WY/info/info_queryByPhone" andParam:dic];
}

-(void)goToHistoryContentViewControllerWith:(NSDictionary *)dic
{
    HistoryContentViewController *vc = [HistoryContentViewController new];
    vc.mContent = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request delegate
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    __weak MaintenanceHistoryView *weak_view = mView;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dict[@"code"] integerValue]==200) {
            [weak_view setData:dict[@"msg"]];
        }
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
