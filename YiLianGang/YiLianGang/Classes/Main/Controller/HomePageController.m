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
#import "DeviceFromGroupTool.h"
#import "DeviceInfo.h"
#import "DringkingDetailViewController.h"
#import "SDCycleScrollView.h"

@interface HomePageController () <SDCycleScrollViewDelegate>
{
    NSArray *imageArr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet WOTShortcutView *shortcutScrollView;
@property (nonatomic, strong)PayMentViewController *h5View;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *autoScrollView;
@property (weak, nonatomic) IBOutlet UIButton *parkingBtn;

@property (nonatomic, strong)DeviceFromGroupTool *deviceTool;
@property (nonatomic, strong)NSMutableArray *deviceArray;
@property (nonatomic, assign)NSNumber *groupId;
@property (nonatomic, strong)DeviceInfo *info;

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPrettyView];
    [self sendRequest];
    self.h5View = [[PayMentViewController alloc] init];
    self.mainController = self;
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   // [self setNaVationBar];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    // Do any additional setup after loading the view.
    
    //解决布局顶部空白问题
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    imageArr = @[[UIImage imageNamed:@"banner1"],[UIImage imageNamed:@"banner1"]];
    [self loadAutoScrollView];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,CGRectGetMaxY(self.parkingBtn.frame)+5);
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
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 轮播图
-(void)loadAutoScrollView{
    self.autoScrollView.localizationImageNamesGroup = imageArr;
    self.autoScrollView.delegate = self;
    self.autoScrollView.pageDotColor = [[UIColor alloc] initWithRed:13.0/255.0f green:13.0/255.0f blue:13.0/255.0f alpha:0.2];
}

//MARK:SDCycleScrollView   Delegate  点击轮播图显示详情
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
//    WOTH5VC *detailvc = [[UIStoryboard storyboardWithName:@"spaceMain" bundle:nil] instantiateViewControllerWithIdentifier:@"WOTworkSpaceDetailVC"];
//    detailvc.url = _sliderUrlStrings[index];
//    [self.navigationController pushViewController:detailvc animated:YES];
    
    NSLog(@"%@+%ld",cycleScrollView.titlesGroup[index],index);
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
    if (self.deviceArray.count > 0) {
        self.info = self.deviceArray[0];
        if (self.info.state.integerValue==0) {
            [ToastUtil showToast:@"设备已离线"];
            return;
        }
    }
    
    if ([self.info.templateId containsString:@"沃特德"])
    {
        DringkingDetailViewController *dringKingView = [[DringkingDetailViewController alloc] init];
        dringKingView.deviceInfo = self.info;
        [self.navigationController pushViewController:dringKingView animated:YES];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dringKingView];
//        if (self.mainController) {
//            [self.mainController presentViewController:navi animated:YES completion:nil];
//        }
    }
    
    
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
    self.h5View.url = @"https://api.uyess.com/score-mall/?#!/weixin/home";
    [self.navigationController pushViewController:self.h5View animated:YES];
}

#pragma mark - 按摩椅
- (IBAction)massageChairButton:(id)sender {
    [ToastUtil showToast:@"敬请期待！"];
}

#pragma mark - 门禁
- (IBAction)RKEButton:(id)sender {
    
    [ToastUtil showToast:@"敬请期待！"];
}

#pragma mark - 获取直饮水设备
-(void)sendRequest{
    WS(weakSelf);
    self.deviceTool = [DeviceFromGroupTool new];
    self.groupId = @355;
    [self.deviceTool sendRequestToGetAllDeviceWithGroupId:self.groupId Response:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (arr) {
                
                weakSelf.deviceArray = [arr mutableCopy];
            }
            
        });
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
