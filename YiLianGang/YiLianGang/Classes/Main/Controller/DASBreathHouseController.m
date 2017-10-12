//
//  DASBreathHouseController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DASBreathHouseController.h"

@interface DASBreathHouseController ()
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailTypeLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *delaySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tempSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *humiSegment;

@property(nonatomic,strong) NSArray *modeStrArr;
@property(nonatomic,strong) NSArray *tempStrArr;
@property(nonatomic,strong) NSArray *humiStrArr;
@property(nonatomic,strong) NSArray *delayTimeArr;


@end

@implementation DASBreathHouseController
-(NSArray *)delayTimeArr{
    if (!_delayTimeArr) {
        _delayTimeArr = @[@"0",@"2",@"5",@"10"];
    }
    return _delayTimeArr;
}
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

- (IBAction)segmentChange:(UISegmentedControl *)sender {
    if (self.typeSegment==sender) {
        [self segmentSelectClear:self.humiSegment];
        [self segmentSelectClear:self.tempSegment];
        
        self.service.serviceId = @"setMode";
        self.service.serviceParam =  [self dictionaryToJson:@{@"setMode":self.modeStrArr[self.typeSegment.selectedSegmentIndex]}];
        self.cooperationTitle = [NSString stringWithFormat:@"模式:%@ %@",[sender titleForSegmentAtIndex:sender.selectedSegmentIndex],[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
    }else if (self.tempSegment == sender){
        [self segmentSelectClear:self.humiSegment];
        [self segmentSelectClear:self.typeSegment];
        
        self.service.serviceId = @"setTemp";
        self.service.serviceParam =  [self dictionaryToJson:@{@"temperature":self.tempStrArr[self.tempSegment.selectedSegmentIndex]}];
        self.cooperationTitle = [NSString stringWithFormat:@"温度:%@ %@",[sender titleForSegmentAtIndex:sender.selectedSegmentIndex],[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
    }else if (self.humiSegment == sender){
        [self segmentSelectClear:self.tempSegment];
        [self segmentSelectClear:self.typeSegment];
        
        self.service.serviceId = @"setHumi";
        self.service.serviceParam =  [self dictionaryToJson:@{@"humidity":self.humiStrArr[self.humiSegment.selectedSegmentIndex]}];
        self.cooperationTitle = [NSString stringWithFormat:@"湿度:%@ %@",[sender titleForSegmentAtIndex:sender.selectedSegmentIndex],[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
    }
}
-(void)segmentSelectClear:(UISegmentedControl*)segment{
    //
    segment.selectedSegmentIndex = -1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    DeviceDetailInfo *detailInfo = self.detailInfo;
    [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.infoImageUrlStr]];
    self.infoNameLabel.text = detailInfo.infoName;
    self.infoDetailLabel.text = detailInfo.infoDetailName;
    self.infoDetailTypeLabel.text = detailInfo.infoDetailTypeName;
    
    self.typeSegment.selectedSegmentIndex = 0;
    self.typeSegment.selected = YES;
    [self segmentChange:self.typeSegment];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightBarItemClicked{
    self.service.delayTime = [NSNumber numberWithInteger:[self.delayTimeArr[self.delaySegment.selectedSegmentIndex] integerValue]];
    
    
    
    [super rightBarItemClicked];
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
