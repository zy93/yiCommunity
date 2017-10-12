//
//  DeviceBreathHouseController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceBreathHouseController.h"


@interface DeviceBreathHouseController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *temperatureSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *humiditySegment;

@property (weak, nonatomic) IBOutlet UILabel *condTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *condHumiLabel;
@property (weak, nonatomic) IBOutlet UILabel *condPmLabel;
@property (weak, nonatomic) IBOutlet UILabel *condCo2Label;
@property (weak, nonatomic) IBOutlet UILabel *condHchoLabel;

@property(nonatomic,strong) NSArray *modeStrArr;
@property(nonatomic,strong) NSArray *tempStrArr;
@property(nonatomic,strong) NSArray *humiStrArr;

@end

@implementation DeviceBreathHouseController
-(NSArray *)modeStrArr{
    if (!_modeStrArr) {
        _modeStrArr = @[@"energySaving",@"normal",@"efficient",@"beOut"];
    }
    return _modeStrArr;
}
-(NSArray *)tempStrArr{
    if (!_tempStrArr) {
        _tempStrArr = @[@"2",@"1",@"0",@"-1",@"-2"];
    }
    return _tempStrArr;
}
-(NSArray *)humiStrArr{
    if (!_humiStrArr) {
        _humiStrArr = @[@"2",@"1",@"0",@"-1",@"-2"];
    }
    return _humiStrArr;
}
- (IBAction)refreshCond:(id)sender {
    [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"getStatus",@"param":@{}}];
    
}
- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender == self.modeSegment) {
        NSString *modeStr = self.modeStrArr[sender.selectedSegmentIndex];
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"setMode",@"param":@{@"setMode":modeStr}}];
    }else if(sender == self.temperatureSegment){
        NSString *tempStr = self.tempStrArr[sender.selectedSegmentIndex];
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"setTemp",@"param":@{@"temperature":tempStr}}];
    }else if(sender == self.humiditySegment){
        NSString *humiStr = self.humiStrArr[sender.selectedSegmentIndex];
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"setHumi",@"param":@{@"humidity":humiStr}}];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController) {
        self.navigationItem.title = @"会呼吸的家";
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
