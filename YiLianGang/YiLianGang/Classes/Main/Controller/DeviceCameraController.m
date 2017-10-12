//
//  DeviceCameraController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceCameraController.h"

@interface DeviceCameraController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *smallButton;
@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property(nonatomic,strong) NSArray *controlStrArr;
@end

@implementation DeviceCameraController

-(NSArray *)controlStrArr{
    if (!_controlStrArr) {
        _controlStrArr = @[@"up",@"down",@"left",@"right",@"zoomOut",@"zoomIn"];
    }
    return _controlStrArr;
}
- (IBAction)clickButton:(UIButton *)sender {
    if(sender == self.leftButton){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"param":@{@"command":self.controlStrArr[2]}}];
    }else if (sender == self.rightButton){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"param":@{@"command":self.controlStrArr[3]}}];
    }else if (sender == self.upButton){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"param":@{@"command":self.controlStrArr[0]}}];
    }else if (sender == self.downButton){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"param":@{@"command":self.controlStrArr[1]}}];
    }else if (sender == self.smallButton){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"param":@{@"command":self.controlStrArr[5]}}];
    }else if (sender == self.bigButton){
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"param":@{@"command":self.controlStrArr[4]}}];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController) {
        self.navigationItem.title = @"摄像头";
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
