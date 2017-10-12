//
//  DASCameraController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DASCameraController.h"
#import "UIColor+RCColor.h"
@interface DASCameraController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *delaySegment;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoDetailTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;

@property(nonatomic,strong) UIView *rectView;

@property(nonatomic,strong) NSString *controlConmand;
@property(nonatomic,assign) NSInteger controlIndex;
@property(nonatomic,strong) NSArray *delayTimeArr;
@property(nonatomic,strong) NSArray *controlTpyeArr;

@end

@implementation DASCameraController
-(NSArray *)controlTpyeArr{
    if (!_controlTpyeArr) {
        _controlTpyeArr = @[@"向左",@"向右",@"向上",@"向下",@"放大",@"缩小"];
    }
    return _controlTpyeArr;
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
    
    
    
    self.controlIndex = 0;
    
    [self clickButton:self.leftButton];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.rectView) {
        self.rectView = [[UIView alloc]initWithFrame:self.leftButton.frame];
        self.rectView.backgroundColor = [UIColor colorWithHexString:@"0B937B" alpha:1];
        UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(2, 2, self.rectView.frame.size.width-4, self.rectView.frame.size.height-4)];
        tempView.backgroundColor = [UIColor whiteColor];
        
        [self.rectView addSubview:tempView];
        
        [self.leftButton.superview.superview insertSubview:self.rectView atIndex:0];        
    }
}
- (IBAction)clickButton:(UIButton *)sender {
    self.rectView.frame = sender.frame;
    if (sender == self.leftButton) {
        self.controlIndex = 0;
        self.controlConmand = [self dictionaryToJson:@{@"command":@"left"}];
    }else if (sender == self.rightButton){
        self.controlIndex = 1;
        self.controlConmand = [self dictionaryToJson:@{@"command":@"right"}];
    }else if (sender == self.upButton){
        self.controlIndex = 2;
        self.controlConmand = [self dictionaryToJson:@{@"command":@"up"}];
    }else if (sender == self.downButton){
        self.controlIndex = 3;
        self.controlConmand = [self dictionaryToJson:@{@"command":@"down"}];
    }else if (sender == self.zoomInButton){
        self.controlIndex = 4;
        self.controlConmand = [self dictionaryToJson:@{@"command":@"zoomIn"}];
    }else if (sender == self.zoomOutButton){
        self.controlIndex = 5;
        self.controlConmand = [self dictionaryToJson:@{@"command":@"zoomOut"}];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightBarItemClicked{
    self.service.serviceId = @"control";
    self.service.serviceParam = self.controlConmand;
    NSString *delayTimeStr = self.delayTimeArr[self.delaySegment.selectedSegmentIndex];
    self.service.delayTime = [NSNumber numberWithInteger:delayTimeStr.integerValue];
    
    self.cooperationTitle = [NSString stringWithFormat:@"%@ %@",self.controlTpyeArr[self.controlIndex],[self.delaySegment titleForSegmentAtIndex:self.delaySegment.selectedSegmentIndex]];
    
    
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
