//
//  DeviceAddServiceBaseController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceAddServiceBaseController.h"

@interface DeviceAddServiceBaseController ()
@property(nonatomic,strong) DeviceInfo *deviceInfo;
@property(nonatomic,copy) BLOCK block;
@property(nonatomic,strong) DeviceDetailInfo *detailInfo;
@end

@implementation DeviceAddServiceBaseController
-(DeviceDetailInfo *)detailInfo{
    if (!_detailInfo) {
        _detailInfo = [[DeviceDetailInfo alloc]initWithDeviceInfo:self.deviceInfo];
    }
    return _detailInfo;
}

-(DeviceSceneCooperationService *)service{
    if (!_service) {
        _service = [DeviceSceneCooperationService new];
        [DeviceSceneTool sharedDeviceSceneTool].lastService = [DeviceSceneCooperationService new];
    }
    return _service;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    return self;
}
-(instancetype)initWithDeviceInfo:(DeviceInfo *)info complete:(BLOCK)block{
    if (self = [super init]) {
        self.deviceInfo = info;
        self.block = block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.serviceDelegate respondsToSelector:@selector(deviceAddServiceBaseDeviceInfo:)]) {
        self.deviceInfo = [self.serviceDelegate deviceAddServiceBaseDeviceInfo:self];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarItemClicked)];
    
    self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)rightBarItemClicked{
    //设置返回的场景的cell上的信息。
    [DeviceSceneTool sharedDeviceSceneTool].lastCellInfo = [DeviceSceneCooperationCellInfo new];
    DeviceSceneCooperationCellInfo *info = [DeviceSceneTool sharedDeviceSceneTool].lastCellInfo;
    
    info.cooperationTitle = self.cooperationTitle;
    info.imageUrlStr = self.detailInfo.infoImageUrlStr;
    info.groupName = self.detailInfo.infoName;
    info.detailTitle = self.detailInfo.infoDetailName;
    info.typeTitle = self.detailInfo.infoDetailTypeName;
    
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.serviceDelegate respondsToSelector:@selector(device:didCompleteWithService:)]) {
        [self.serviceDelegate device:self didCompleteWithService:self.service];
    }
}
/**字典转json*/
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
