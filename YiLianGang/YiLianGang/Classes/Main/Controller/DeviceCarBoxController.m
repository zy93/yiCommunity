//
//  DeviceCarBoxController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceCarBoxController.h"

@interface DeviceCarBoxController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *engineSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *airConditionerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *carDoorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lightAndWhistleSwitch;

@end

@implementation DeviceCarBoxController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        self.navigationItem.title = @"车载盒子";
    }
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)switchChanged:(UISwitch *)sender {
    if (sender == self.engineSwitch) {
        NSString *switchStr = self.engineSwitch.on?@"on":@"off";
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"led_control",@"param":@{@"id":[NSNumber numberWithInteger:1],@"command":switchStr}}];
    }else if (sender == self.airConditionerSwitch){
        NSString *switchStr = self.engineSwitch.on?@"on":@"off";
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"led_control",@"param":@{@"id":[NSNumber numberWithInteger:3],@"command":switchStr}}];
    }else if (sender == self.carDoorSwitch){
        NSString *switchStr = self.engineSwitch.on?@"on":@"off";
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"led_control",@"param":@{@"id":[NSNumber numberWithInteger:4],@"command":switchStr}}];
    }else if (sender == self.lightAndWhistleSwitch){
        NSString *switchStr = self.engineSwitch.on?@"on":@"off";
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"led_control",@"param":@{@"id":[NSNumber numberWithInteger:2],@"command":switchStr}}];
    }
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
