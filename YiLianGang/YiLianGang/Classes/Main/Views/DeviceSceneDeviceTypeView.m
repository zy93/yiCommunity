//
//  DeviceSceneDeviceTypeView.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceSceneDeviceTypeView.h"

#import "UIColor+RCColor.h"
#import "WNListView.h"
#import "WN_YL_RequestTool.h"
#import "LoginTool.h"

//设备
#import "DeviceCarBoxRelationView.h"
#define DeviceRelationHeight 82

@interface DeviceSceneDeviceTypeView()<WN_YL_RequestToolDelegate>
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UIButton *groupSelectButton;
@property(nonatomic,strong) UIButton *relationSelectButton;

@property(nonatomic,copy) BLOCK block;
@property(nonatomic,strong) WNListView *listView;
@property(nonatomic,strong) NSArray *groupArray;
@property(nonatomic,strong) WN_YL_RequestTool *requestTool;
@property(nonatomic,strong) NSNumber *groupId;
@property(nonatomic,strong) NSArray *deviceArray;
@property(nonatomic,strong) NSArray *relationType;

//当前view的高度
@property(nonatomic,assign) CGFloat viewHeight;

@property(nonatomic,assign) CGFloat originY;

@end

@implementation DeviceSceneDeviceTypeView
-(instancetype)initWithFrame:(CGRect)frame groupArray:(NSArray<DeviceGroupInfo*>*)groupArray didGetRelationDevice:(BLOCK)block{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        self.groupArray = groupArray;
        self.relationType = @[@"AND",@"OR"];
        [self awakeFromNib];
        
    }
    return self;
}
-(WN_YL_RequestTool *)requestTool{
    if (!_requestTool) {
        _requestTool = [WN_YL_RequestTool new];
        _requestTool.delegate = self;

    }
    return _requestTool;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    //容器
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 50)];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
    self.label.text = @"设备";
    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(100, 40)];
    self.label.frame = CGRectMake(20, 0, labelSize.width, 40);
    self.label.textColor = [UIColor colorWithHexString:@"2E2E2E" alpha:1];
    [self.lineView addSubview:self.label];
    //分组按钮
    self.groupSelectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat buttonX = self.label.frame.origin.x+self.label.frame.size.width+10;
    self.groupSelectButton.frame = CGRectMake(buttonX, 0, (self.frame.size.width-buttonX-30)/2, 40);
    if (self.groupArray.count>0) {
        DeviceGroupInfo *info = self.groupArray[0];
        [self.groupSelectButton setTitle:info.groupName forState:UIControlStateNormal];
    }else{
        [self.groupSelectButton setTitle:@"分组" forState:UIControlStateNormal];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"equip_sj_down"]];
    imageView.frame = CGRectMake(self.groupSelectButton.frame.size.width-15, 0, 15, 40);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.groupSelectButton addSubview:imageView];
    
    [self.groupSelectButton addTarget:self action:@selector(clickGroupSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.lineView addSubview:self.groupSelectButton];
    //关系按钮
    buttonX = self.groupSelectButton.frame.origin.x +self.groupSelectButton.frame.size.width+10;
    self.relationSelectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.relationSelectButton.frame = CGRectMake(buttonX, 0, self.groupSelectButton.frame.size.width, 40);
    [self.relationSelectButton setTitle:self.relationType[0] forState:UIControlStateNormal];
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"equip_sj_down"]];
    imageView.frame = CGRectMake(self.relationSelectButton.frame.size.width-15, 0, 15, 40);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.relationSelectButton addSubview:imageView];
    [self.relationSelectButton addTarget:self action:@selector(clickRelationSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.lineView addSubview:self.relationSelectButton];
    //获取设备
    if (self.groupArray.count>0) {
        [self sendRequestWithIndex:0];
    }
    [self addSubview:self.lineView];
    self.viewHeight = 10+self.lineView.frame.origin.y+self.lineView.frame.size.height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.viewHeight);
    self.originY = self.viewHeight;
    
}

-(void)sendRequestWithIndex:(NSInteger)index{
    
    DeviceGroupInfo *groupInfo = self.groupArray[index];
    if (!groupInfo) {
        return;
    }
    self.groupId = [NSNumber numberWithInteger:groupInfo.groupId.integerValue];
    [self.requestTool sendGetRequestWithExStr:@"Service_Platform/group/deviceList.do" andParam:@{@"userId":[LoginTool sharedLoginTool].userID,@"groupId":self.groupId}];
}
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.requestTool) {
        NSLog(@"%@",dict);
        if (dict) {
            NSArray *arr = dict[@"data"];
            if (arr) {
                NSMutableArray *mutaArr = [NSMutableArray array];
                for (NSDictionary *dicIn in arr) {
                    DeviceInfo *info = [DeviceInfo new];
                    [info setValuesForKeysWithDictionary:dicIn];
                    [mutaArr addObject:info];
                }
                self.deviceArray = [mutaArr copy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (UIView *view in self.subviews) {
                        if ([view isKindOfClass:[DeviceRelationBaseView class]]) {
                            [view removeFromSuperview];
                        }
                        self.viewHeight = self.originY;
                    }
                    //加subview
                    [self deviceRelationSubViewWithDeviceArray:self.deviceArray];
                });
            }
        }
    }
}
-(void)deviceRelationSubViewWithDeviceArray:(NSArray<DeviceInfo*>*)array{
    CGFloat allSubViewHeight = 0;
    CGFloat margion = 10;
    for (DeviceInfo *info in array) {
        
        if([info.templateId containsString:@"四海万联"]){
            
            DeviceCarBoxRelationView *carBoxView = [[NSBundle mainBundle]loadNibNamed:@"DeviceCarBoxRelationView" owner:nil options:nil].lastObject;
            carBoxView.deviceInfo = info;
            carBoxView.frame = CGRectMake(0, self.originY+allSubViewHeight+margion, self.frame.size.width, DeviceRelationHeight);
            allSubViewHeight += carBoxView.frame.size.height;
            carBoxView.infoBlock = ^(){
                return info;
            };
            carBoxView.carBoxBlock = ^(NSInteger typeIndex){
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self updateState];
                });
            };
            [self addSubview:carBoxView];
            
        }
    }
    self.viewHeight = self.originY + allSubViewHeight+10;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.viewHeight);
}
-(void)updateState{
    self.conditionList = [NSMutableArray array];

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[DeviceRelationBaseView class]]) {
            DeviceRelationBaseView *dView = (DeviceRelationBaseView*)view;
            if (dView.on) {
                [self.conditionList addObject:dView.param];
                
            }
            
        }
    }
    [self updateConditions];
}
-(void)updateConditions{
    NSArray *arr = self.conditionList;
    if (arr ==nil) {
        arr = [NSArray array];
    }
    self.conditions = @{@"conditionsRelation":self.relationSelectButton.titleLabel.text,@"conditionList":arr};
    
    self.block();
}
-(void)clickGroupSelectButton:(UIButton*)sender{
    NSMutableArray *mutaArr = [NSMutableArray array];
    for (DeviceGroupInfo *info in self.groupArray) {
        [mutaArr addObject:info.groupName];
    }
    
    self.listView = [WNListView listViewWithArrayStr:mutaArr acordingFrameInScreen:[sender convertRect:sender.bounds toView:[UIApplication sharedApplication].keyWindow] superView:[UIApplication sharedApplication].keyWindow clickResponse:^(NSUInteger index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.groupSelectButton setTitle:mutaArr[index] forState:UIControlStateNormal];
            [self sendRequestWithIndex:index];
        });
    }];
    
}
-(void)clickRelationSelectButton:(UIButton*)sender{
    
    self.listView = [WNListView listViewWithArrayStr:self.relationType acordingFrameInScreen:[sender convertRect:sender.bounds toView:[UIApplication sharedApplication].keyWindow] superView:[UIApplication sharedApplication].keyWindow clickResponse:^(NSUInteger index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.relationSelectButton setTitle:self.relationType[index] forState:UIControlStateNormal];
            [self updateConditions];
        });
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
