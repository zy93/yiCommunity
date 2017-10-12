//
//  DASHomeFurnishController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DASHomeFurnishController.h"

@interface DASHomeFurnishController ()
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailTypeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *delaySegment;

@property(nonatomic,strong) NSArray *delayTimeArr;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UITableViewCell *lightTypeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sceneTypeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *windMachineTypeCell;
@property(nonatomic,strong) NSArray *cellArr;

//风机
@property (weak, nonatomic) IBOutlet UISwitch *windMachineSwitch;

//灯
@property (weak, nonatomic) IBOutlet UISegmentedControl *lightChoiceSegment;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;


//场景
@property (weak, nonatomic) IBOutlet UISegmentedControl *sceneSegment;

@end

@implementation DASHomeFurnishController

-(NSArray *)delayTimeArr{
    if (!_delayTimeArr) {
        _delayTimeArr = @[@"0",@"2",@"5",@"10"];
    }
    return _delayTimeArr;
}

- (IBAction)segmentChange:(UISegmentedControl*)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        //风机
        [self.windMachineTypeCell setHidden:NO];
        [self.lightTypeCell setHidden:YES];
        [self.sceneTypeCell setHidden:YES];
        
        self.service.serviceId = @"fan_switch";
        self.service.serviceParam = [self dictionaryToJson:@{@"line":[NSNumber numberWithInteger:1],@"fan":[NSNumber numberWithInteger:self.windMachineSwitch.on?1:0]}];
        self.cooperationTitle = [NSString stringWithFormat:@"%@ %@ %@",[sender titleForSegmentAtIndex:sender.selectedSegmentIndex],self.windMachineSwitch.on?@"打开":@"关闭",[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
        
    }else if (sender.selectedSegmentIndex == 1){
        //灯光
        [self.windMachineTypeCell setHidden:YES];
        [self.lightTypeCell setHidden:NO];
        [self.sceneTypeCell setHidden:YES];
        
        self.service.serviceId = @"light_dim_switch";
        self.service.serviceParam = [self dictionaryToJson:@{@"line":[NSNumber numberWithInteger:self.lightChoiceSegment.selectedSegmentIndex+1],@"dim":[NSNumber numberWithInteger:((NSInteger)self.lightSlider.value)]}];
        
        self.cooperationTitle = [NSString stringWithFormat:@"%@ 亮度%@ %@",[self.lightChoiceSegment titleForSegmentAtIndex:self.lightChoiceSegment.selectedSegmentIndex],[NSNumber numberWithInteger:((NSInteger)self.lightSlider.value)],[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
    }else if (sender.selectedSegmentIndex == 2){
        //场景
        [self.windMachineTypeCell setHidden:YES];
        [self.lightTypeCell setHidden:YES];
        [self.sceneTypeCell setHidden:NO];
        
        self.service.serviceId = @"scene";
        self.service.serviceParam = [self dictionaryToJson:@{@"scene":[NSNumber numberWithInteger:self.sceneSegment.selectedSegmentIndex+1]}];
        self.cooperationTitle = [NSString stringWithFormat:@"%@ %@ %@",[sender titleForSegmentAtIndex:sender.selectedSegmentIndex],[self.sceneSegment titleForSegmentAtIndex:self.sceneSegment.selectedSegmentIndex],[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self segmentChange:self.typeSegment];
    DeviceDetailInfo *detailInfo = self.detailInfo;
    [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.infoImageUrlStr]];
    self.infoNameLabel.text = detailInfo.infoName;
    self.infoDetailLabel.text = detailInfo.infoDetailName;
    self.infoDetailTypeLabel.text = detailInfo.infoDetailTypeName;
    
    // Do any additional setup after loading the view.
}
-(void)rightBarItemClicked{
    self.service.delayTime = [NSNumber numberWithInteger:[self.delayTimeArr[self.delaySegment.selectedSegmentIndex] integerValue]];
    [self segmentChange:self.typeSegment];
    [super rightBarItemClicked];
}
//隐藏cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.hidden)
        
        return 0;
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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
