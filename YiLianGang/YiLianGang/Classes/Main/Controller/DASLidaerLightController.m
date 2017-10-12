//
//  DASLidaerLightController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/3/8.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DASLidaerLightController.h"

@interface DASLidaerLightController ()
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailTypeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *delaySegment;
@property(nonatomic,strong) IBOutlet UISegmentedControl *switchSegment;
@property(nonatomic,strong) IBOutlet UISwitch *lSwitch;
@property(nonatomic,strong) NSArray *delayTimeArr;

@end

@implementation DASLidaerLightController

- (void)viewDidLoad {
    [super viewDidLoad];
    DeviceDetailInfo *detailInfo = self.detailInfo;
    [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.infoImageUrlStr]];
    self.infoNameLabel.text = detailInfo.infoName;
    self.infoDetailLabel.text = detailInfo.infoDetailName;
    self.infoDetailTypeLabel.text = detailInfo.infoDetailTypeName;
    
    
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
-(void)rightBarItemClicked{
    self.service.delayTime = [NSNumber numberWithInteger:[self.delayTimeArr[self.delaySegment.selectedSegmentIndex] integerValue]];
    
    self.service.serviceParam =  [self dictionaryToJson:@{}];
    
    [super rightBarItemClicked];
}
@end
