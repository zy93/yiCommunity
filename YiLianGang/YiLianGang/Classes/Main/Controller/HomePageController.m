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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottonImageView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewButton;

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPrettyView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   // [self setNaVationBar];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.scrollViewButton.frame.size.height+self.topImageView.frame.size.height+self.view1.frame.size.height+self.view2.frame.size.height+self.view3.frame.size.height+self.view4.frame.size.height);
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


-(void)dealloc{
    NSLog(@"HomePageController dealloc");
}
-(void)doPrettyView{
    //self.navigationItem.title = @"首页";
    
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

- (void)setNaVationBar {
    
    // 透明状态栏的延伸
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //可有可无
    
    [self.navigationController.navigationBar setBackgroundImage:nil
     
                                                 forBarPosition:UIBarPositionAny
     
                                                     barMetrics:UIBarMetricsDefault];
    
    //一条线
    
   // self.navigationController.navigationBar.shadowImage = [UIColor image:[UIColor colorWithRed:0.29f green:0.58f blue:0.92f alpha:1.00f]];//(等号后自定义方法)
    
}


@end
