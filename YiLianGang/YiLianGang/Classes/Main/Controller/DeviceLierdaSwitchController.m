//
//  DeviceLierdaSwitchController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/23.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DeviceLierdaSwitchController.h"

@interface DeviceLierdaSwitchController ()
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;

@end

@implementation DeviceLierdaSwitchController
- (IBAction)openSwitchChanged:(UISwitch*)sender {
    NSString *thingId = self.deviceInfo.thingId;
    [self sendWebSocketStringWithParam:@{
                                         @"param":@{@"value":(sender.on?@"ON":@"OFF")},
                                         @"serviceId":@"switch",
                                         @"thingId":thingId}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
