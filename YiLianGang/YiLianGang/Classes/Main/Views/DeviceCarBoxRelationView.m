//
//  DeviceCarBoxRelationView.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/19.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceCarBoxRelationView.h"
@interface DeviceCarBoxRelationView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
@implementation DeviceCarBoxRelationView
- (IBAction)changeSwitch:(UISwitch *)sender {
    self.on = sender.on;
    
    [self didSetParam];
}
- (IBAction)segmentChange:(UISegmentedControl*)sender {
    
    if (!self.on) {
        self.on = YES;
        [self.relationSwitch setOn:self.on animated:YES];
    }
    [self didSetParam];
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.nameLabel.text = [[self.deviceInfo.templateId stringByReplacingOccurrencesOfString:@"//" withString:@" "]stringByReplacingOccurrencesOfString:@"model" withString:@""];
    
    self.relationSwitch.on = self.on;
    
    
    [self changeSwitch:self.relationSwitch];
    [self didSetParam];
}
-(void)didSetParam{
    self.param = @{@"serviceId":@"button_click",
                   @"param":@"id",
                   @"paramComment":@"按钮的标识",
                   @"paramType":@"enum int",
                   @"relation":@"=",
                   @"value":[NSNumber numberWithInteger:self.typeButton.selectedSegmentIndex+1],
                   @"harborIp":self.deviceInfo.harborIp,
                   @"thingId":self.deviceInfo.thingId
                   };
    self.carBoxBlock(self.typeButton.selectedSegmentIndex);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
