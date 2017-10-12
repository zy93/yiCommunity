//
//  DeviceAirConditionerController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/8.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceAirConditionerController.h"

@interface DeviceAirConditionerController ()
@property (weak, nonatomic) IBOutlet UIImageView *modeImageView;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *windSpeedButton;
@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (weak, nonatomic) IBOutlet UIButton *temperRiseButton;
@property (weak, nonatomic) IBOutlet UIButton *temperFallButton;
@property (weak, nonatomic) IBOutlet UILabel *temperControlLabel;

@end

@implementation DeviceAirConditionerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)doPrettyView{
    self.temperControlLabel.layer.cornerRadius = self.temperControlLabel.frame.size.width/2;
    self.temperControlLabel.layer.masksToBounds = YES;
    
    self.windSpeedButton.layer.cornerRadius = self.windSpeedButton.frame.size.width/2;
    self.windSpeedButton.layer.masksToBounds = YES;
    
    self.modeLabel.layer.cornerRadius = self.modeLabel.frame.size.width/2;
    self.modeLabel.layer.masksToBounds = YES;
    
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
