//
//  HomePageController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "HomePageController.h"
#import "HomePageView.h"
#import "WOTShortcutView.h"
#import "PayMentViewController.h"

#import "MaintenanceViewController.h"
#import "ShopController.h"
#import "H5CloudPrintController.h"
#import "H5DingDingParkController.h"


@interface HomePageController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottonImageView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet WOTShortcutView *shortcutScrollView;
@property (nonatomic, strong)PayMentViewController *h5View;

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPrettyView];
    self.h5View = [[PayMentViewController alloc] init];
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   // [self setNaVationBar];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    // Do any additional setup after loading the view.
    
    //解决布局顶部空白问题
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.shortcutScrollView.frame.size.height+self.topImageView.frame.size.height+self.view1.frame.size.height+self.view2.frame.size.height+self.view3.frame.size.height+self.view4.frame.size.height);
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];//隐藏
    
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


-(void)dealloc{
    NSLog(@"HomePageController dealloc");
}
-(void)doPrettyView{
    //self.navigationItem.title = @"首页";
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 北菜园

- (IBAction)gardenButton:(id)sender {
    self.h5View.url = @"https://shop13299823.wxrrd.com/feature/10257418";
    [self.navigationController pushViewController:self.h5View animated:YES];
}

#pragma mark - 多利农庄

- (IBAction)farmButton:(id)sender {
    self.h5View.url = @"https://wx.tonysfarm.com/public/index/index_shop_app.html?customerId=7e144bf108b94505a890ec3a7820db8d&applicationId=899A6191575A4E46AF62BA3D7096387E&rid=99749";
    [self.navigationController pushViewController:self.h5View animated:YES];
}

#pragma mark - 报修
- (IBAction)repairsButton:(id)sender {
    
    MaintenanceViewController *root = [[MaintenanceViewController alloc] init];
    [self.navigationController pushViewController:root animated:YES];
}
#pragma mark - 直饮水
- (IBAction)waterButton:(id)sender {
    
}
#pragma mark - 停车
- (IBAction)parkButton:(id)sender {
    H5DingDingParkController *cpc = [H5DingDingParkController new];
    [self.navigationController pushViewController:cpc animated:YES];
}
#pragma mark - 物业缴费
- (IBAction)propertyButton:(id)sender {
    
    
}
#pragma mark - 云打印
- (IBAction)cloudPrint:(id)sender {
    H5CloudPrintController *cpc = [H5CloudPrintController new];
    [self.navigationController pushViewController:cpc animated:YES];
}
#pragma mark - 轻松到家
- (IBAction)getHomeButton:(id)sender {
    
}

#pragma mark - 按摩椅
- (IBAction)massageChairButton:(id)sender {
    
}

#pragma mark - 门禁
- (IBAction)RKEButton:(id)sender {
    
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
