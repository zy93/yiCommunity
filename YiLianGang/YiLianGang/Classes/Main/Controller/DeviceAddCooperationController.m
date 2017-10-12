//
//  DeviceAddCooperationController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceAddCooperationController.h"
#import "DeviceTool.h"
#import "WN_YL_RequestTool.h"
#import "UIImageView+WebCache.h"
#import "LoginTool.h"
#import "DeviceSceneTool.h"
#import "DeviceCooperationCell.h"
#import "DASCameraController.h"
#import "DASCarBoxController.h"
#import "DASBreathHouseController.h"
#import "DASHomeFurnishController.h"
#import "DeviceGroupSelectHeaderView.h"
#import "WNListView.h"

@interface DeviceAddCooperationController ()<WN_YL_RequestToolDelegate,DeviceAddServiceBaseControllerDelegate>
@property(nonatomic,copy) CompleteBlock block;
@property(nonatomic,strong) NSArray *deviceArray;
@property(nonatomic,strong) WN_YL_RequestTool *requestTool;
@property(nonatomic,strong) NSNumber *groupId;
@property(nonatomic,strong) NSArray *groupArray;

@property(nonatomic,weak) DASCameraController *cameraController;
@property(nonatomic,weak) DASCarBoxController *carBoxController;
@property(nonatomic,weak) DASBreathHouseController *breathHouseController;
@property(nonatomic,weak) DASHomeFurnishController *homeFurnishController;
@property(nonatomic,assign) NSInteger number;
@property(nonatomic,strong) DeviceInfo *selectedInfo;
@property(nonatomic,strong) DeviceGroupSelectHeaderView *groupSelectView;
@property(nonatomic,strong) WNListView *listView;
@end

@implementation DeviceAddCooperationController
-(WNListView*)listView{
    if (!_listView) {
        NSMutableArray *mutaArr = [NSMutableArray array];
        for (DeviceGroupInfo *info in self.groupArray) {
            [mutaArr addObject:info.groupName];
        }
        _listView = [WNListView listViewWithArrayStr:mutaArr acordingFrameInScreen:[self.groupSelectView.selectButton convertRect:self.groupSelectView.selectButton.bounds toView:[UIApplication sharedApplication].keyWindow] superView:nil clickResponse:^(NSUInteger index) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DeviceGroupInfo *info = self.groupArray[index];
                self.groupSelectView.groupTextField.text = info.groupName;
                [self sendRequestWithIndex:index];
            });
            
        }];
        
    }
    return _listView;
}
-(NSArray *)groupArray{
    if (!_groupArray) {
        _groupArray = [DeviceTool sharedDeviceTool].allGroup;
    }
    return _groupArray;
}
-(instancetype)initWithNumber:(NSInteger)number completeBlock:(CompleteBlock)block{
    if (self = [super init]) {
        self.block = block;
        self.number = number;
    }
    return self;
}
-(void)sendRequestWithIndex:(NSInteger)index{
    self.requestTool = [WN_YL_RequestTool new];
    self.requestTool.delegate = self;
    DeviceGroupInfo *groupInfo = self.groupArray[index];
    self.groupSelectView.groupTextField.text = groupInfo.groupName;
    
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
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    [self.tableView reloadData];
                });
            }
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self addGroupSelectView];
    [self sendRequestWithIndex:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//已弃用
-(void)addGroupSelectView{
    
    self.groupSelectView = [[NSBundle mainBundle]loadNibNamed:@"DeviceGroupSelectHeaderView" owner:nil options:nil].lastObject;
    self.groupSelectView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 66);
    [self.groupSelectView.selectButton addTarget:self action:@selector(clickGroupSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = self.groupSelectView;
}
-(DeviceGroupSelectHeaderView *)groupSelectView{
    if (!_groupSelectView) {
        _groupSelectView = [[NSBundle mainBundle]loadNibNamed:@"DeviceGroupSelectHeaderView" owner:nil options:nil].lastObject;
        _groupSelectView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 66);
        [_groupSelectView.selectButton addTarget:self action:@selector(clickGroupSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupSelectView;
}
-(void)clickGroupSelectButton:(UIButton*)button{
    [[UIApplication sharedApplication].keyWindow addSubview:self.listView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.deviceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceCooperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cooperationCell"];
    if(!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"DeviceCooperationCell" owner:nil options:nil].lastObject;
    }
    
    DeviceInfo *info = self.deviceArray[indexPath.row];
    DeviceDetailInfo *detailInfo = [[DeviceDetailInfo alloc]initWithDeviceInfo:info];
    
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:detailInfo.infoImageUrlStr]];
    cell.cellNameLabel.text = detailInfo.infoName;
    cell.cellDetailLabel.text = detailInfo.infoDetailName;
    cell.cellDetailTypeLabel.text = detailInfo.infoDetailTypeName;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 66;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.groupSelectView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceInfo *info = self.deviceArray[indexPath.row];
    self.selectedInfo = info;
    //判断是否为海康威视
    if ([info.templateId containsString:@"海康威视"]) {
        self.cameraController = [UIStoryboard storyboardWithName:@"DASCameraController" bundle:nil].instantiateInitialViewController;
        self.cameraController.serviceDelegate = self;
        self.cameraController.service.number = [NSNumber numberWithInteger:self.number];
        self.cameraController.service.thingId = info.thingId;
        self.cameraController.service.harborIp = info.harborIp;
        
        [self.navigationController pushViewController:self.cameraController animated:YES];
    }
    //判断是否为车载盒子
    else if([info.templateId containsString:@"四海万联"]){
        
        self.carBoxController = [UIStoryboard storyboardWithName:@"DASCarBoxController" bundle:nil].instantiateInitialViewController;
        self.carBoxController.serviceDelegate = self;
        self.carBoxController.service.number = [NSNumber numberWithInteger:self.number];
        self.carBoxController.service.thingId = info.thingId;
        self.carBoxController.service.harborIp = info.harborIp;
        
        [self.navigationController pushViewController:self.carBoxController animated:YES];
        
    }
    //判断是否为会呼吸的家
    else if([info.templateId containsString:@"领耀东方"]){
        self.breathHouseController = [UIStoryboard storyboardWithName:@"DASBreathHouseController" bundle:nil].instantiateInitialViewController;
        self.breathHouseController.serviceDelegate = self;
        self.breathHouseController.service.number = [NSNumber numberWithInteger:self.number];
        self.breathHouseController.service.thingId = info.thingId;
        self.breathHouseController.service.harborIp = info.harborIp;
        [self.navigationController pushViewController:self.breathHouseController animated:YES];

        
    }
    //判断是否为智能家居
    else if([info.templateId containsString:@"睿恩科技"]){
        
        self.homeFurnishController = [UIStoryboard storyboardWithName:@"DASHomeFurnishController" bundle:nil].instantiateInitialViewController;
        self.homeFurnishController.serviceDelegate = self;
        self.homeFurnishController.service.number = [NSNumber numberWithInteger:self.number];
        self.homeFurnishController.service.thingId = info.thingId;
        self.homeFurnishController.service.harborIp = info.harborIp;
        [self.navigationController pushViewController:self.homeFurnishController animated:YES];
    }
}

-(DeviceInfo *)deviceAddServiceBaseDeviceInfo:(id)controller{
    
    return self.selectedInfo;
}
-(void)device:(id)controller didCompleteWithService:(DeviceSceneCooperationService *)service{
    NSLog(@"%@",controller);
    [self.navigationController popViewControllerAnimated:YES];
    [DeviceSceneTool sharedDeviceSceneTool].lastService = service;
    self.block();
}
@end
