//
//  HomePageController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "HomePageController.h"
#import "HomePageView.h"

#import "MaintenanceViewController.h"
#import "ShopController.h"
#import "H5CloudPrintController.h"
#import "H5DingDingParkController.h"


@interface HomePageController ()
@property(nonatomic,weak) HomePageView *homeView;
@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPrettyView];
    
    
    [self.view addSubview:self.homeView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.homeView refreshWeather];
    [self.homeView refreshService];
    [self.navigationController setNavigationBarHidden:YES];
    //[self.tabBarController.tabBar setHidden:YES];隐藏
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setType:@"fade"];
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}

-(void)goToMaintenanceViewController
{
    MaintenanceViewController *root = [[MaintenanceViewController alloc] init];
    [self.navigationController pushViewController:root animated:YES];
}

-(void)goToShopViewController
{
    ShopController *root = [ShopController new];
    [self.navigationController pushViewController:root animated:YES];
}

-(void)goToDDController
{
    H5DingDingParkController *cpc = [H5DingDingParkController new];
    //        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:cpc];
    //        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //        [self presentViewController:navi animated:YES completion:nil];
    [self.navigationController pushViewController:cpc animated:YES];
}

-(void)goToPrintViewController
{
    H5CloudPrintController *cpc = [H5CloudPrintController new];
    //        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:cpc];
    //        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //        [self presentViewController:navi animated:YES completion:nil];
    [self.navigationController pushViewController:cpc animated:YES];
}


-(void)dealloc{
    NSLog(@"HomePageController dealloc");
}
-(void)doPrettyView{
    self.navigationItem.title = @"首页";
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
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

- (HomePageView *)homeView {
	if(_homeView == nil) {
        
		_homeView = [[NSBundle mainBundle]loadNibNamed:@"HomePageView" owner:nil options:nil].lastObject;;
        _homeView.frame = self.view.bounds;
	}
	return _homeView;
}

@end
