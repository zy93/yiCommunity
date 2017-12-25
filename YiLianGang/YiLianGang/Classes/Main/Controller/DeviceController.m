//
//  DeviceController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceController.h"
#import "DeviceHeaderView.h"
#import "WNPageView.h"
#import "StyleTool.h"
#import "DeviceTool.h"
#import "DeviceSubTableController.h"
#import "DevicePopoverController.h"
#import "HCScanQRViewController.h"
#import "DeviceAddInfoController.h"

#import "DeviceGroupController.h"
#import "DeviceSceneController.h"
#import "DeviceOKAListController.h"
#import "DringkingDetailViewController.h"
#import "MJRefresh.h"

@interface DeviceController ()<WNPageViewDelegate,UIPopoverPresentationControllerDelegate,DeviceToolDelegate,DeviceHeaderViewDelegate,DeviceAddDelegate,DevicePopoverControllerDelegate>
@property(nonatomic,strong) WNPageView *pageView;
@property(nonatomic,assign) CGFloat deviceHeaderHeight;
@property(nonatomic,assign) CGFloat devicePageViewHeight;
@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;
@property(nonatomic,strong) UIBarButtonItem *leftItem;
@property(nonatomic,strong) UIBarButtonItem *rightItem;
@property(nonatomic,strong) DevicePopoverController *popoverController;
@property(nonatomic,strong) DringkingDetailViewController *dringKing;
//@property(nonatomic,strong) DeviceSubTableController *deviceSubTable;

@end

@implementation DeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPrettyView];
    //[self addNaviButton];
    self.tableView.scrollEnabled = NO;
    self.tableView.pagingEnabled = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    [self.tableView.mj_header beginRefreshing];
    //self.deviceSubTable = [[DeviceSubTableController alloc] init];
    //self.deviceSubTable.delegate = self;
    //self.tableView.delegate = self;
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpGoBackinterface:) name:@"JumpNotification" object:nil];
}
-(void)dealloc{
    NSLog(@"DeviceController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JumpNotification" object:nil];
}
-(void)addNaviButton{
    //左边
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    /*
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"device_leftButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickTopLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton = leftButton;
    [leftView addSubview:leftButton];
     */
    leftView.backgroundColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1];
    self.leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    //右边
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"device_rightButton"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickTopRightButton:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton = rightButton;
    //这里先隐藏搜索功能
    self.rightButton.hidden = YES;
    [rightView addSubview:rightButton];
    rightView.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}

-(void)clickTopLeftButton:(UIButton*)button{
    
    self.popoverController.preferredContentSize = CGSizeMake(100, 100);
    self.popoverController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popVc = self.popoverController.popoverPresentationController;
    popVc.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
//    popVc.sourceView = self.leftButton;
//    popVc.sourceRect = self.leftButton.bounds;
    popVc.barButtonItem = self.leftItem;
    popVc.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popVc.delegate = self;
    self.popoverController.controller = self;
   // [self presentViewController:self.popoverController animated:YES completion:nil];
    [self.navigationController pushViewController:self.popoverController animated:YES];
    
}
-(void)clickTopRightButton:(UIButton*)button{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//扫描二维码
-(void)deviceHeaderViewDidClickQRCodeScanButton{
    HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
    //调用此方法来获取二维码信息
    __weak typeof(self) safe = self;
    [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
        __strong typeof(safe) strongSelf = safe;
        NSLog(@"%@",QRCodeInfo);
        [strongSelf dismissViewControllerAnimated:NO completion:nil];
        if (QRCodeInfo.length>0) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[QRCodeInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            if(dict){
                NSLog(@"%@",dict);
                DeviceSendInfo *info = [DeviceTool sharedDeviceTool].deviceSendInfo;
                info.ProduceTime = dict[@"ProduceTime"];
                info.localID = dict[@"localID"];
                info.model = dict[@"model"];
                info.producer = dict[@"producer"];
                info.type = dict[@"type"];
                if (dict[@"ip"]){
                    info.ip = dict[@"ip"];
                }
                if (dict[@"userName"]) {
                    info.userName = dict[@"userName"];
                }
                if (dict[@"password"]) {
                    info.password = dict[@"password"];
                }
                //进入设备编辑界面
                UINavigationController *dvc = [UIStoryboard storyboardWithName:@"DeviceAddInfoController" bundle:nil].instantiateInitialViewController;
                DeviceAddInfoController *daic = dvc.viewControllers[0];
                daic.delegate = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    dvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [strongSelf presentViewController:dvc animated:YES completion:nil];
                });
            }
        }

        
    }];
    [self presentViewController:scan animated:YES completion:nil];
//    //进入设备编辑界面
//    UIViewController *dvc = [UIStoryboard storyboardWithName:@"DeviceAddInfoController" bundle:nil].instantiateInitialViewController;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        dvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:dvc animated:YES completion:nil];
//    });
}
#pragma mark DeviceAddDelegate
-(void)deviceDidAdded{
    [self refreshView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setType:@"fade"];
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self refreshView];
}

-(void)refreshView{
    [self.pageView removeFromSuperview];
    
    self.pageView = nil;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}
#pragma mark DeviceToolDelegate
-(void)deviceToolDidReceiveGroupList:(BOOL)success dict:(NSDictionary *)dict{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self refreshView];
    });
}
-(void)doPrettyView{
    self.title = @"设备列表";
    //self.navigationItem.rightBarButtonItem = nil;
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    /*
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    */
    self.view.backgroundColor = [UIColor whiteColor];
    
//    DeviceHeaderView *deviceHeaderView = [[NSBundle mainBundle]loadNibNamed:@"DeviceHeaderView" owner:nil options:nil].lastObject;
//    deviceHeaderView.backgroundColor = [[StyleTool sharedStyleTool]sessionSyle].headerColor;
//    self.deviceHeaderHeight = self.view.frame.size.width*0.5933;
//    self.devicePageViewHeight =self.view.frame.size.height-self.deviceHeaderHeight-48;
//    deviceHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.deviceHeaderHeight);
//    self.tableView.tableHeaderView = deviceHeaderView;
//    deviceHeaderView.delegate =self;
    self.devicePageViewHeight =self.view.frame.size.height-self.deviceHeaderHeight-48;
   // [self.tableView.tableHeaderView removeFromSuperview];
    //self.tableView.bounces = NO;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //cell.selectionStyle = uitableviewcellselect
        cell.backgroundColor = [UIColor clearColor];
        
    }
    for (UIView *view in cell.subviews) {
        if (view.tag ==20) {
            [view removeFromSuperview];
        }
    }
    [cell addSubview:self.pageView];
    self.pageView.tag = 20;
    self.pageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.devicePageViewHeight);
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.devicePageViewHeight;
}
#pragma mark WNPageViewDelegate
-(void)settingsOfStyleWithPageView:(WNPageView *)pageView{
    StyleInfo *info = [[StyleTool sharedStyleTool]sessionSyle];
    pageView.segementLineColor = info.segmentLineColor;
    pageView.segementBackgroundColor = [UIColor colorWithRed:0.9214 green:0.9206 blue:0.9458 alpha:1.0];
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
#pragma mark UIPopoverPresentationControllerDelegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}


#pragma mark DevicePopoverControllerDelegate
-(void)devicePopoverContollerDidChooseIndex:(NSInteger)index{
    if (index == 0) {
        //分组管理
        DeviceGroupController *dgc = [[DeviceGroupController alloc]initWithNibName:@"DeviceGroupController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dgc];
        dgc.lastPresentController = self;
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navi animated:YES completion:nil];
    }else if (index ==1){
        //一键执行
        DeviceOKAListController *okac = [DeviceOKAListController new];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:okac];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navi animated:YES completion:nil];
        
    }else if(index == 2){
        //智能场景
        DeviceSceneController *dgc = [[DeviceSceneController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dgc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mark lazyLoad
- (WNPageView *)pageView {
	if(_pageView == nil) {
        NSArray *groupArr = [[DeviceTool sharedDeviceTool]getDeviceSegmentTitles];
        NSMutableArray *titleArr = [NSMutableArray array];
        for (DeviceGroupInfo *info in groupArr) {
            [titleArr addObject:info.groupName];
        }
        NSMutableArray *controllerArr = [NSMutableArray array];
        for (int i = 0;i<titleArr.count;i++) {
            DeviceGroupInfo *groupInfo = groupArr[i];
            NSNumber *groupId = [NSNumber numberWithInteger:groupInfo.groupId.integerValue];
            DeviceSubTableController *subController = [[DeviceSubTableController alloc]initWithGroupId:groupId];
            //DeviceSubController *subController = [[DeviceSubController alloc]initWithGroupId:groupId];
            subController.mainController = self;
            [controllerArr addObject:subController];
        }
        _pageView = [[WNPageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width*0.5933, self.view.frame.size.width,  self.view.frame.size.height-65) withNameArrayTitle:titleArr controllers:controllerArr delegate:self];
//        _pageView = [[WNPageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width*0.5933, self.view.frame.size.width,  self.view.frame.size.height) withNameArrayTitle:titleArr controllers:controllerArr delegate:self];
       // _pageView.backgroundColor = [UIColor blackColor];
        NSLog(@"测试高：%f",self.view.frame.size.height);
        [_pageView setPageEnable:NO];
        [DeviceTool sharedDeviceTool].delegate = self;
        
	}
	return _pageView;
    
}

- (DevicePopoverController *)popoverController {
	if(_popoverController == nil) {
		_popoverController = [[DevicePopoverController alloc] init];
        _popoverController.delegate = self;
    }
	return _popoverController;
    
}


#pragma mark -跳转通知
-(void)jumpGoBackinterface:(NSNotification *)notification
{
    if ([notification.userInfo objectForKey:@"deviceInfo"]) {
//        self.dringKing = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
//            if ([controller isKindOfClass:[DringkingDetailViewController class]]) { //这里判断是否为你想要跳转的页面
//                //controller.deviceInfo = info;
//
//            }
//        }
//        //dringKing.deviceInfo = [notification.userInfo objectForKey:@"deviceInfo"];
//        [self.dringKing setValue:[notification.userInfo objectForKey:@"deviceInfo"] forKey:@"deviceInfo"];
//        [self.navigationController popToViewController:self.dringKing animated:YES];
//
//
        
        //UIViewController *target = nil;
        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[DringkingDetailViewController class]]) { //这里判断是否为你想要跳转的页面
                //controller.deviceInfo = info;
                self.dringKing = controller;
                self.dringKing.deviceInfo = [notification.userInfo objectForKey:@"deviceInfo"];
                [self.navigationController popToViewController:self.dringKing animated:YES];
                return;
            }
            
        }
 
        self.dringKing = [[DringkingDetailViewController alloc] init];
        self.dringKing.deviceInfo = [notification.userInfo objectForKey:@"deviceInfo"];
        [self.navigationController pushViewController:self.dringKing animated:YES];
    

        
//        UIViewController *controll = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//        if ([controll isKindOfClass:[DringkingDetailViewController class]]) {
//            self.dringKing = (DringkingDetailViewController *)controll;
//            self.dringKing.deviceInfo = [notification.userInfo objectForKey:@"deviceInfo"];
//            [self.navigationController popToViewController:self.dringKing animated:YES];
//        }
//        else
//        {
//            self.dringKing = [[DringkingDetailViewController alloc] init];
//            self.dringKing.deviceInfo = [notification.userInfo objectForKey:@"deviceInfo"];
//            [self.navigationController pushViewController:self.dringKing animated:YES];
//        }
        
        

    }

}



@end
