//
//  DeviceTywgCurtainController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/23.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DeviceTywgCurtainController.h"

@interface DeviceTywgCurtainController ()

@end

@implementation DeviceTywgCurtainController
- (IBAction)switchChange:(UISwitch*)sender {
    NSString *thingId = self.deviceInfo.thingId;
    [self sendWebSocketStringWithParam:@{
                                         @"param":@{@"value":(sender.on?@"1":@"0")},
                                         @"serviceId":@"curtain_switch",
                                         @"thingId":thingId}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
