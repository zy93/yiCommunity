//
//  DeviceHomeFurnishController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceHomeFurnishController.h"

@interface DeviceHomeFurnishController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *windMachineSwitch;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider1;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider2;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider3;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider4;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sceneSegment;

@end

@implementation DeviceHomeFurnishController
- (IBAction)switchChange:(UISwitch *)sender {
    [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"fan_switch",@"param":@{@"line":[NSNumber numberWithInteger:1],@"fan":[NSNumber numberWithInteger:sender.on?1:0]}}];
}

- (IBAction)sliderTouchUp:(UISlider *)sender {
    if (sender == _lightSlider1) {
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"light_dim_switch",@"param":@{@"line":[NSNumber numberWithInteger:1],@"dim":[NSNumber numberWithInteger:(NSInteger)sender.value]}}];
    }else if (sender == _lightSlider2){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"light_dim_switch",@"param":@{@"line":[NSNumber numberWithInteger:2],@"dim":[NSNumber numberWithInteger:(NSInteger)sender.value]}}];
    }else if (sender == _lightSlider3){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"light_dim_switch",@"param":@{@"line":[NSNumber numberWithInteger:3],@"dim":[NSNumber numberWithInteger:(NSInteger)sender.value]}}];
    }else if (sender == _lightSlider4) {
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"light_dim_switch",@"param":@{@"line":[NSNumber numberWithInteger:4],@"dim":[NSNumber numberWithInteger:(NSInteger)sender.value]}}];
    }
}


- (IBAction)segmentChange:(UISegmentedControl *)sender {
    [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"scene",@"param":@{@"scene":[NSNumber numberWithInteger:sender.selectedSegmentIndex+1]}}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController) {
        self.navigationItem.title = @"智能家居";
    }
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
