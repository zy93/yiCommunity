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
#import "PayBillViewController.h"
#import "DeviceTool.h"
#import "JudgmentTime.h"
#import "DeviceDescribeViewController.h"
#import "NoticeRequestTool.h"
#import "NoticeDetailsViewController.h"
#import "DoorLockDescribeViewController.h"
#import "MBProgressHUDUtil.h"
#import "DoorLockListViewController.h"


@interface HomePageController () <SDCycleScrollViewDelegate,WOTShortcutViewDelegate>
{
    NSArray *imageArr;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet WOTShortcutView *shortcutScrollView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *autoScrollView;
@property (weak, nonatomic) IBOutlet UIButton *parkingBtn;

@property (nonatomic, strong)DeviceFromGroupTool *deviceTool;
@property (nonatomic, strong)NSMutableArray *deviceArray;
@property (nonatomic, strong)NSArray *groupArray;
@property (nonatomic, assign)NSNumber *groupId;
@property (nonatomic, strong)DeviceInfo *info;
@property (nonatomic, strong)DeviceTool *deviceT;
@property (nonatomic, assign)BOOL isPayView;
@property (nonatomic, strong)JudgmentTime *jumdgmentTime;
@property (nonatomic, strong) NSMutableArray *imageUrlStrings;
@property (nonatomic, strong) NSArray *noticeInfoArray;


@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPrettyView];
    self.noticeInfoArray = [[NSArray alloc] init];
    self.imageUrlStrings = [[NSMutableArray alloc] init];
    
    self.jumdgmentTime = [[JudgmentTime alloc] init];
    self.mainController = self;
    self.shortcutScrollView.shortcutViewDelegate = self;
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   // [self setNaVationBar];
   // [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    // Do any additional setup after loading the view.
    //解决布局顶部空白问题
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    imageArr = @[[UIImage imageNamed:@"banner"],[UIImage imageNamed:@"banner1"]];
   
    [self getData];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,CGRectGetMaxY(self.parkingBtn.frame)+5);
    [self sendRequest];
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

#pragma mark - action
-(void)selfPushVCWithUrl:(NSString *)url
{
    PayMentViewController *h5 = [[PayMentViewController alloc] init];
    h5.url = [NSURL URLWithString:url];
    [self.navigationController pushViewController:h5 animated:YES];
}


#pragma mark - 轮播图
-(void)loadAutoScrollView{
    //
//    self.autoScrollView.localizationImageNamesGroup = imageArr;
//    self.autoScrollView.imageURLStringsGroup = _imageUrlStrings;
    
    [self.autoScrollView setLocAndURL:imageArr urlArr:_imageUrlStrings];
    
    self.autoScrollView.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    self.autoScrollView.pageDotColor = [[UIColor alloc] initWithRed:13.0/255.0f green:13.0/255.0f blue:13.0/255.0f alpha:0.2];
}

//MARK:SDCycleScrollView   Delegate  点击轮播图显示详情
#pragma mark -点击轮播图显示详情--显示公告详情
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    NSLog(@"%@+%ld",cycleScrollView.titlesGroup[index],index);
    if (index == 0) {
        DeviceDescribeViewController *detailvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceDescribeViewController"];
        [self.navigationController pushViewController:detailvc animated:YES];
    }else if(index == 1)
    {
        DoorLockListViewController *doorList = [[UIStoryboard storyboardWithName:@"DoorLockListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"DoorLockListViewController"];
        [self.navigationController pushViewController:doorList animated:YES];
        
    }else
    {
        if (self.noticeInfoArray.count == 0 || [[self.noticeInfoArray[index-2] objectForKey:@"title"]isEqualToString:@""] || [self.noticeInfoArray[index-2] objectForKey:@"title"] == NULL) {
            [MBProgressHUDUtil showMessage:@"没有公告！" toView:self.view];
            return;
        }
        NSLog(@"信息%@",self.noticeInfoArray);
        NoticeDetailsViewController *noticeDetailsVC = [[NoticeDetailsViewController alloc] init];
        noticeDetailsVC.titleStr = [self.noticeInfoArray[index-2] objectForKey:@"title"];
        noticeDetailsVC.contentStr = [self.noticeInfoArray[index-2] objectForKey:@"content"];
        noticeDetailsVC.releaseTimeStr = [self cutOutString:[self.noticeInfoArray[index-2] objectForKey:@"releaseTime"]];
        [self.navigationController pushViewController:noticeDetailsVC animated:YES];
    }
}

#pragma mark - 北菜园

- (IBAction)gardenButton:(id)sender {
    [self gardenMethod];
}

#pragma mark - 多利农庄

- (IBAction)farmButton:(id)sender {
     NSString *urlString = @"https://wx.tonysfarm.com/public/index/index_shop_app.html?customerId=7e144bf108b94505a890ec3a7820db8d&applicationId=899A6191575A4E46AF62BA3D7096387E&rid=99749";
    [self selfPushVCWithUrl:urlString];
   
}

#pragma mark - 报修
- (IBAction)repairsButton:(id)sender {
    [self repairsMethod];
//    MaintenanceViewController *root = [[MaintenanceViewController alloc] init];
//    [self.navigationController pushViewController:root animated:YES];
}
#pragma mark - 直饮水
- (IBAction)waterButton:(id)sender {

     
    if (self.deviceArray.count == 0) {
        [ToastUtil showToast:@"未绑定设备"];
        return;
    }else
    {
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
    }
    
}
#pragma mark - 停车
- (IBAction)parkButton:(id)sender {
    H5DingDingParkController *cpc = [H5DingDingParkController new];
    [self.navigationController pushViewController:cpc animated:YES];
}

#pragma mark - 智水小荷
- (IBAction)capacityWater:(id)sender {

    NSString *urlString = @"http://www.yiliangang.net:8012/page/ManDun/box.html";
    //NSString *urlString = @"http://www.apple.com";
    [self selfPushVCWithUrl:urlString];
    //[ToastUtil showToast:@"敬请期待！"];
}

#pragma mark - 更多
- (IBAction)moreButton:(id)sender {
    [ToastUtil showToast:@"敬请期待！"];
}

#pragma mark - 物业缴费
- (IBAction)propertyButton:(id)sender {
    [self judgmentTime];
    if (!_isPayView) {
        [self propertyMethod];
    }else
    {
        [ToastUtil showToast:@"敬请期待！"];
    }
    
}
#pragma mark - 云打印
- (IBAction)cloudPrint:(id)sender {
    H5CloudPrintController *cpc = [H5CloudPrintController new];
    [self.navigationController pushViewController:cpc animated:YES];
}
#pragma mark - 轻松到家
- (IBAction)getHomeButton:(id)sender {
    NSString *urlString = @"https://api.uyess.com/gzh/index.php?uyes_qd_no=uyes_hz_ylg";
    [self selfPushVCWithUrl:urlString];
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
    //获取groupId -- start
    //NSArray *groupArr;
    //dispatch_async(dispatch_get_main_queue()
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.groupArray = [[DeviceTool sharedDeviceTool] getDeviceSegmentTitles];
//    });
    
    [[DeviceTool sharedDeviceTool] sendRequestToGetAllGroupResponse:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.groupArray = [arr mutableCopy];
            if (self.groupArray.count > 0) {
                DeviceGroupInfo *groupInfo = self.groupArray[0];//要修改为0
                self.groupId = [NSNumber numberWithInteger:groupInfo.groupId.integerValue];
            }else
            {
                return;
            }
            [self.deviceTool sendRequestToGetAllDeviceWithGroupId:self.groupId Response:^(NSArray *arr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (arr) {
                        weakSelf.deviceArray = [arr mutableCopy];
                    }else
                    {
                        weakSelf.deviceArray = nil;
                    }
                    
                });
            }];
            
        });
    }];
   // NSLog(@"groupId:%@",self.groupId);
    //获取groupId -- end
    //self.groupId = @344;
    
}

#pragma mark - WOTShortcutViewDelegate
-(void)JumpinterfaceWithButtonMessage:(NSString *)buttonMessage
{
    if ([buttonMessage isEqualToString:@"门禁"]) {
        [ToastUtil showToast:@"敬请期待！"];
    }
    
    if ([buttonMessage isEqualToString:@"物业缴费"]) {
        [self judgmentTime];
        if (!_isPayView) {
            [self propertyMethod];
        }else
        {
            [ToastUtil showToast:@"敬请期待！"];
        }
    }
    
    if ([buttonMessage isEqualToString:@"维修"]) {
        [self repairsMethod];
    }
    
    if ([buttonMessage isEqualToString:@"北菜园"]) {
        [self gardenMethod];
    }
    
    
}

-(void)propertyMethod
{
    PayBillViewController *vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayBillViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)repairsMethod
{
    MaintenanceViewController *root = [[MaintenanceViewController alloc] init];
    [self.navigationController pushViewController:root animated:YES];
}

-(void)gardenMethod
{
    NSString *urlString = @"https://shop13299823.wxrrd.com/feature/10257418";
    [self selfPushVCWithUrl:urlString];
}


-(void)judgmentTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
   // NSString *aDataTime =@"2017/11/02";
    _isPayView = [self.jumdgmentTime compareDate:DateTime withDate:@"2017/11/3"];
    
    
}

-(void)getData
{
    [self requestNoticePictureUrl:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAutoScrollView];
        });
    }];
}


-(void)requestNoticePictureUrl:(void(^)())complete
{
    NSString *pictureHttp = @"http://www.yiliangang.net:8012/ylgPlatform";
    [[NoticeRequestTool sharedNoticeTool] sendNoticeRequestWithResponse:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"code"] intValue] == 200) {
            self.noticeInfoArray = [dict objectForKey:@"msg"];
            if (self.noticeInfoArray != nil && ![self.noticeInfoArray isKindOfClass:[NSNull class]] && self.noticeInfoArray.count != 0) {
                for (NSDictionary *ok in [dict objectForKey:@"msg"]) {
                    NSLog(@"字段：%@",[ok objectForKey:@"picture"]);
                    NSString *pictureStr = [pictureHttp stringByAppendingString:[ok objectForKey:@"picture"]];
                    [self.imageUrlStrings addObject:pictureStr];
                }
                NSLog(@"图片array：%@",self.imageUrlStrings);
            }
            
            complete();
        }else
        {
            NSLog(@"失败！！");
            complete();
        }
    }];
}

#pragma mark - 截取字符串--保留年、月、日
-(NSString *)cutOutString:(NSString *)timeString
{
    NSString *str = [timeString substringToIndex:11];
    NSLog(@"截取的值为：%@",str);
    return str;
}


//-(void)requestNoticePictureUrl
//{
//    NSString *pictureHttp = @"http://www.yiliangang.net:8012/ylgPlatform";
//    [[NoticeRequestTool sharedNoticeTool] sendNoticeRequestWithResponse:^(NSDictionary *dict) {
//
//        if (dict) {
//            NSLog(@"公告信息：%@",[dict objectForKey:@"msg"] );
//            for (NSDictionary *ok in [dict objectForKey:@"msg"]) {
//                NSLog(@"字段：%@",[ok objectForKey:@"picture"]);
//                NSString *pictureStr = [pictureHttp stringByAppendingString:[ok objectForKey:@"picture"]];
//                [self.imageUrlStrings addObject:pictureStr];
//
//            }
//            NSLog(@"图片array：%@",self.imageUrlStrings);
//
//        }else
//        {
//
//        }
//
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
