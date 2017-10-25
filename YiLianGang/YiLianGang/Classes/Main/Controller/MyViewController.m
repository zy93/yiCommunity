//
//  MyViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/10/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MyViewController.h"
#import "TabBarSetTool.h"
#import "LoginTool.h"
#import "DeviceTool.h"
#import "AboutViewController.h"
#import "HCScanQRViewController.h"
#import "DeviceAddInfoController.h"
#import "DeviceController.h"


@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UILabel *moneyNum;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    //self.userName.text = [LoginTool sharedLoginTool].userName;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.tabBar setHidden:NO];
    self.userTel.text = [LoginTool sharedLoginTool].userTel;
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //[self.tabBarController.tabBar setHidden:NO];
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setType:@"fade"];
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}
- (IBAction)aboutButton:(id)sender {
//    AboutViewController *aboutViewC = [[AboutViewController alloc] init];
//    [self.navigationController pushViewController:aboutViewC animated:YES];
//
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    /* 获取storyboard的InitialViewController 即根控制器*/
    AboutViewController *aboutViewC = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    [self.navigationController pushViewController:aboutViewC animated:YES];
}

- (IBAction)informationButton:(id)sender {
    [ToastUtil showToast:@"敬请期待！"];
}

- (IBAction)deviceButton:(id)sender {
    //[ToastUtil showToast:@"敬请期待！"];
    DeviceController *deviceController = [[DeviceController alloc] init];
    [self.navigationController pushViewController:deviceController animated:YES];
}

- (IBAction)addDevice:(id)sender {
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
