//
//  PromptMessageViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/20.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PromptMessageViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SendWIFIInfoViewController.h"

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
@interface PromptMessageViewController ()

@property (nonatomic, strong)NSString *wifiName;

@end

@implementation PromptMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeNetwork) name:@"wifiNotification" object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchingNetworkButton:(id)sender {
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
}


#pragma mark - 获取当前网络名称
-(void)getwifiNameFromsystem
{
    id info = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        self.wifiName = info[@"SSID"];
        if ([self.wifiName isEqualToString:@"USR-C215"]) {
            SendWIFIInfoViewController *vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SendWIFIInfoViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        NSString *str2 = info[@"BSSID"];
//        NSString *str3 = [[ NSString alloc] initWithData:info[@"SSIDDATA"] encoding:NSUTF8StringEncoding];
        
    }
}

#pragma mark -判断网络
-(void)judgeNetwork
{
    [self getwifiNameFromsystem];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wifiNotification" object:nil];
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
