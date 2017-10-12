//
//  DeviceRuienkejiHomeController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/23.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DeviceRuienkejiHomeController.h"

@interface DeviceRuienkejiHomeController ()
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch1;
@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch2;
@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch3;

@end

@implementation DeviceRuienkejiHomeController
- (IBAction)clickOpenButton:(id)sender {
    NSString *thingId = self.deviceInfo.thingId;
    [self sendWebSocketStringWithParam:
     @{@"param":@{@"line":[NSNumber numberWithInteger:1],@"switch":[NSNumber numberWithInteger:1]},
       @"serviceId":@"curtain_switch",
       @"thingId":thingId}];
}
- (IBAction)clickStopButton:(id)sender {
    NSString *thingId = self.deviceInfo.thingId;
    [self sendWebSocketStringWithParam:
     @{@"param":@{@"line":[NSNumber numberWithInteger:1],@"switch":[NSNumber numberWithInteger:2]},
       @"serviceId":@"curtain_switch",
       @"thingId":thingId}];
}
- (IBAction)clickCloseButton:(id)sender {
    NSString *thingId = self.deviceInfo.thingId;
    [self sendWebSocketStringWithParam:
     @{@"param":@{@"line":[NSNumber numberWithInteger:1],@"switch":[NSNumber numberWithInteger:0]},
       @"serviceId":@"curtain_switch",
       @"thingId":thingId}];
}
- (IBAction)lightSwitchChanged:(UISwitch *)sender {
    NSInteger index = sender.tag-100;
    NSNumber *indexNum = [NSNumber numberWithInteger:index];
    NSString *thingId = self.deviceInfo.thingId;
    [self sendWebSocketStringWithParam:
     @{@"param":@{@"line":indexNum,@"switch":[NSNumber numberWithInteger:sender.on]},
       @"serviceId":@"light_switch",
       @"thingId":thingId}];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    CornerView(self.openButton, 4);
    CornerView(self.stopButton, 4);
    CornerView(self.closeButton, 4);
    self.lightSwitch1.tag = 101;
    self.lightSwitch2.tag = 102;
    self.lightSwitch3.tag = 103;
    
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
