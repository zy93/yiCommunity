//
//  DASCarBoxController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DASCarBoxController.h"

@interface DASCarBoxController ()
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailTypeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *delaySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *partChoiceSegment;
@property (weak, nonatomic) IBOutlet UISwitch *partSwitch;

@property(nonatomic,strong) NSArray *controlTypeIdArr;
@property(nonatomic,strong) NSArray *delayTimeArr;
@property(nonatomic,strong) NSArray *controlTypeNameArr;

@property(nonatomic,strong) NSNumber *typeId;
@property(nonatomic,strong) NSString *command;

@end

@implementation DASCarBoxController
-(NSArray *)controlTypeNameArr{
    if (!_controlTypeNameArr) {
        _controlTypeNameArr = @[@"引擎",@"空调",@"车门",@"闪灯鸣笛"];
    }
    return _controlTypeNameArr;
}
-(NSArray *)controlTypeIdArr{
    if (!_controlTypeIdArr) {
        _controlTypeIdArr = @[@"1",@"3",@"4",@"2"];
    }
    return _controlTypeIdArr;
}

-(NSArray *)delayTimeArr{
    if (!_delayTimeArr) {
        _delayTimeArr = @[@"0",@"2",@"5",@"10"];
    }
    return _delayTimeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DeviceDetailInfo *detailInfo = self.detailInfo;
    [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.infoImageUrlStr]];
    self.infoNameLabel.text = detailInfo.infoName;
    self.infoDetailLabel.text = detailInfo.infoDetailName;
    self.infoDetailTypeLabel.text = detailInfo.infoDetailTypeName;
    
    self.service.serviceId = @"led_control";
    [self segmentChange:self.partChoiceSegment];
    [self segmentChange:self.delaySegment];
    [self switchChange:self.partSwitch];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChange:(UISegmentedControl*)sender {
    if (sender == self.partChoiceSegment) {
        NSString *choiceStr = self.controlTypeIdArr[sender.selectedSegmentIndex];
        self.typeId = [NSNumber numberWithInteger:choiceStr.integerValue];
        
    }else if(sender == self.delaySegment) {
        NSString *delayTimeStr = self.delayTimeArr[sender.selectedSegmentIndex];
        self.service.delayTime = [NSNumber numberWithInteger:delayTimeStr.integerValue];
    }
}

- (IBAction)switchChange:(UISwitch *)sender {
    self.command = sender.on?@"on":@"off";
}

-(void)rightBarItemClicked{
    self.service.serviceParam = [self combineParamWithId:self.typeId command:self.command];
    self.cooperationTitle = [NSString stringWithFormat:@"%@ %@ %@",self.controlTypeNameArr[self.partChoiceSegment.selectedSegmentIndex],self.partSwitch.on?@"开":@"关",[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
    
    
    [super rightBarItemClicked];
}
-(NSString*)combineParamWithId:(NSNumber*)typeId command:(NSString*)command{
    NSDictionary *paramDic = @{@"id":typeId,@"command":command};
    NSString *paramJson = [self dictionaryToJson:paramDic];
    
    return paramJson;
}
/**字典转json*/
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



@end
