//
//  DeviceSubController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceSubTableController.h"
#import "DeviceTableCell.h"
#import "DeviceTool.h"
#import "UIImageView+WebCache.h"
#import "LoginTool.h"
#import "DeviceCarBoxController.h"
#import "DeviceBreathHouseController.h"
#import "DeviceCameraController.h"
#import "DeviceRuienkejiHomeController.h"
#import "DeviceFromGroupTool.h"
#import "WN_YL_RequestTool.h"
#import "DeviceLightController.h"
#import "DeviceLierdaSwitchController.h"
#import "DeviceTywgCurtainController.h"
#import "SDWebImageManager.h"
#import "DringkingDetailViewController.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define Margin 1
@interface DeviceSubTableController ()

@property(nonatomic,assign) CGFloat cellWidth;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) NSMutableArray *deviceArray;
@property(nonatomic,strong) NSNumber *groupId;
@property(nonatomic,strong) DeviceFromGroupTool *deviceTool;
@end

@implementation DeviceSubTableController
-(instancetype)initWithGroupId:(NSNumber *)groupId{
    if (self = [super init]) {
        self.groupId = groupId;
    }
    return self;
}
-(void)sendRequest{
    WS(weakSelf);
    self.deviceTool = [DeviceFromGroupTool new];
    [self.deviceTool sendRequestToGetAllDeviceWithGroupId:self.groupId Response:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (arr) {
                weakSelf.deviceArray = [arr mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
            
        });
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequest];
    self.tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"DeviceSubController dealloc");
    
}
#pragma mark -- tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DeviceTableCell" owner:nil options:nil].lastObject;
    }
    DeviceInfo *info = self.deviceArray[indexPath.row];
    NSString *imageStr = info.picUrl;
    
    NSString *imageFixedStr = [[DeviceTool sharedDeviceTool]imageAddExStr:imageStr];
    [cell.deviceImageView sd_setImageWithURL:[NSURL URLWithString:imageFixedStr] placeholderImage:[UIImage imageNamed:@""]];
    if (info.state.integerValue == 0) {
        cell.deviceNameLabel.text = [NSString stringWithFormat:@"%@ (%@)",info.thingName,@"离线"];
    }else{
        cell.deviceNameLabel.text = info.thingName;
    }
    NSString *model = [info.templateId lastPathComponent];
    NSString *temp = [info.templateId stringByDeletingLastPathComponent];
    NSString *name = [temp lastPathComponent];
    NSString *temp2 = [temp stringByDeletingLastPathComponent];
    NSString *factory = [temp2 lastPathComponent];
    cell.deviceModelLabel.text = [NSString stringWithFormat:@"%@ %@",name,model];
    cell.deviceFactoryLabel.text = factory;
    [cell.deviceImageView sd_setImageWithURL:[NSURL URLWithString:info.picUrl] placeholderImage:nil];;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceInfo *info = self.deviceArray[indexPath.row];
    if (info.state.integerValue==0 && ![info.templateId containsString:@"海康威视"]) {
        [ToastUtil showToast:@"设备已离线"];
        return;
    }
    //判断是否为海康威视
    if ([info.templateId containsString:@"海康威视"]) {
        DeviceCameraController *dcc = [UIStoryboard storyboardWithName:@"DeviceCameraController" bundle:nil].instantiateInitialViewController;
        dcc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为大华
    if ([info.templateId containsString:@"大华"]) {
        DeviceCameraController *dcc = [UIStoryboard storyboardWithName:@"DeviceCameraController" bundle:nil].instantiateInitialViewController;
        dcc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为车载盒子
    else if([info.templateId containsString:@"四海万联"]&&[info.templateId containsString:@"车载盒子"]){
        
        DeviceCarBoxController *dcbc = [UIStoryboard storyboardWithName:@"DeviceCarBoxController" bundle:nil].instantiateInitialViewController;
        dcbc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcbc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为会呼吸的家
    else if([info.templateId containsString:@"领耀东方"]){
        DeviceBreathHouseController *dcbc = [UIStoryboard storyboardWithName:@"DeviceBreathHouseController" bundle:nil].instantiateInitialViewController;
        dcbc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcbc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为智能家居
    else if([info.templateId containsString:@"睿恩科技"]&&[info.templateId containsString:@"智能家居"]){
        DeviceRuienkejiHomeController *dcbc = [UIStoryboard storyboardWithName:@"DeviceRuienkejiHomeController" bundle:nil].instantiateInitialViewController;
        dcbc.deviceInfo = info;
      
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcbc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为利尔达智能灯
    else if([info.templateId containsString:@"利尔达"]&&[info.templateId containsString:@"智能灯"]){
        DeviceLightController *dlc = [UIStoryboard storyboardWithName:@"DeviceLightController" bundle:nil].instantiateInitialViewController;
        dlc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dlc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为通用网关的灯
    else if([info.templateId containsString:@"通用网关"]&&[info.templateId containsString:@"智能灯"]){
        DeviceLightController *dlc = [UIStoryboard storyboardWithName:@"DeviceLightController" bundle:nil].instantiateInitialViewController;
        dlc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dlc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为通用网关的窗帘
    else if([info.templateId containsString:@"通用网关"]&&[info.templateId containsString:@"窗帘"]){
        DeviceTywgCurtainController *dlc = [UIStoryboard storyboardWithName:@"DeviceTywgCurtainController" bundle:nil].instantiateInitialViewController;
        dlc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dlc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为利尔达开关
    else if([info.templateId containsString:@"利尔达"]&&[info.templateId containsString:@"开关"]){
        DeviceLierdaSwitchController *dlc = [UIStoryboard storyboardWithName:@"DeviceLierdaSwitchController" bundle:nil].instantiateInitialViewController;
        dlc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dlc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为利尔达智能门锁
    else if([info.templateId containsString:@"利尔达"]&&[info.templateId containsString:@"智能门锁"]){
        DeviceLierdaSwitchController *dlc = [UIStoryboard storyboardWithName:@"DeviceLierdaSwitchController" bundle:nil].instantiateInitialViewController;
        dlc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dlc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    else if ([info.templateId containsString:@"沃特德"])
    {
        DringkingDetailViewController *dringKingView = [[DringkingDetailViewController alloc] init];
        dringKingView.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:dringKingView];
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DeviceSubTableController *vc = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [vc removeDeviceByIndexRow:indexPath];

        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"共享设备" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [vc shareDeviceByIndexRow:indexPath];
        
    }];
    shareAction.backgroundColor = HEXCOLOR(0x30efd1);
    
    NSArray *arr = @[shareAction,deleteAction];
    return arr;
}

#pragma mark 删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeDeviceByIndexRow:indexPath];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)removeDeviceByIndexRow:(NSIndexPath *)indexPath
{
    DeviceInfo *info = self.deviceArray[indexPath.row];
    NSString *thingId = info.thingId;
    [ToastUtil showLoadingToast:@"正在删除"];
    [[DeviceTool sharedDeviceTool]sendInfoWithThingId:thingId response:^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastUtil unShowLoading];
            
            NSString *errStr = dict[@"error_msg"];
            if(dict){
                if([dict[@"error_code"]integerValue]==0){
                    [ToastUtil showToast:@"删除成功"];
                    [self.deviceArray removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else if([dict[@"error_code"]integerValue]==1){
                    [ToastUtil showToast:@"您没有删除该物体的权限"];
                }else{
                    [ToastUtil showToast:errStr];
                }
            }else{
                [ToastUtil showToast:errStr];
            }
        });
    }];
}

-(void)shareDeviceByIndexRow:(NSIndexPath *)indexPath
{
    DeviceInfo *info = self.deviceArray[indexPath.row];
    NSString *thingId = info.thingId;
    
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"设备授权" message:@"您可以通过该操作将设备共享或取消共享到某一个用户名下,请谨慎操作!" preferredStyle:UIAlertControllerStyleAlert];
    [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"对方手机号";
    }];
    
    UIAlertAction *permissionAction = [UIAlertAction actionWithTitle:@"共享设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *filed =  aler.textFields.firstObject;
        if (strIsEmpty(filed.text)) {
            [MBProgressHUD showError:@"请输入对方手机号"];
            return ;
        }
        [[DeviceTool sharedDeviceTool] sendPermissionWithThingId:thingId userTel:filed.text state:YES response:^(NSDictionary *dict) {
            NSLog(@"------------------** 共享设备回复:%@",dict);
        }];
    }];
    UIAlertAction *prohibitionAction = [UIAlertAction actionWithTitle:@"取消共享" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UITextField *filed =  aler.textFields.firstObject;
        if (strIsEmpty(filed.text)) {
            [MBProgressHUD showError:@"请输入对方手机号"];
            return ;
        }
        [[DeviceTool sharedDeviceTool] sendPermissionWithThingId:thingId userTel:filed.text state:YES response:^(NSDictionary *dict) {
            NSLog(@"------------------** 取消共享设备回复:%@",dict);
        }];
    }];
    
    [aler addAction:permissionAction];
    [aler addAction:prohibitionAction];
    
    [self presentViewController:aler animated:YES completion:nil];
    
}

- (NSMutableArray *)deviceArray {
    if(_deviceArray == nil) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}



@end
