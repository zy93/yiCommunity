//
//  DeviceSceneAddController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceSceneAddController.h"
#import "DeviceSceneTimeTypeView.h"
#import "DeviceSceneDeviceTypeView.h"
#import "DayChoiceController.h"
#import "DeviceAddCooperationController.h"
#import "DeviceSceneTool.h"
#import "UIImageView+WebCache.h"
#import "DeviceCooperationDetailCell.h"
#import "LoginTool.h"
#import "MBProgressHUD+KR.h"
#define DynamicStartNumber 3


@interface DeviceSceneAddController ()
@property (weak, nonatomic) IBOutlet UITextField *sceneNameFld;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeChoiceSegment;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeSetCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *deviceServiceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *choiceCell;
@property (weak, nonatomic) IBOutlet UIButton *addCooperationButton;

@property(nonatomic,strong) DeviceSceneTimeTypeView *timeView;
@property(nonatomic,strong) DeviceSceneDeviceTypeView *deviceView;

@property(nonatomic,strong) UIAlertController *alert;
@property(nonatomic,strong) UIDatePicker *picker;


@property(nonatomic,strong) NSMutableArray *cooperationCellMutaArr;
@property(nonatomic,strong) NSMutableArray *sendServiceArr;

@property(nonatomic,strong) DeviceSceneRegisterInfo *registerInfo;

@property(nonatomic,strong) NSArray<DeviceGroupInfo*> *groupArray;
@property(nonatomic,strong) NSDictionary *conditions;
@end

@implementation DeviceSceneAddController
-(NSArray<DeviceGroupInfo *> *)groupArray{
    if (!_groupArray) {
        _groupArray = [DeviceTool sharedDeviceTool].allGroup;
    }
    return _groupArray;
}
- (IBAction)segmentChange:(UISegmentedControl*)sender {
    if (sender == self.typeChoiceSegment) {
        [self setUpTypeSetCell];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [self setUpTypeSetCell];
    [self setUpDeviceServiceCell];
    self.tableView.tableFooterView = [UIView new];
    self.addCooperationButton.layer.cornerRadius = 4;
    self.addCooperationButton.layer.masksToBounds = YES;
    self.registerInfo = [DeviceSceneRegisterInfo new];
    self.registerInfo.userId = [NSNumber numberWithInteger:[LoginTool sharedLoginTool].userID.integerValue];
    
    
}

-(void)setUpNavi{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveScene)];
}
- (IBAction)clickAddCooperationButton:(UIButton *)sender {
    DeviceAddCooperationController *dacc = [[DeviceAddCooperationController alloc]initWithNumber:self.sendServiceArr.count+1 completeBlock:^{
        DeviceSceneCooperationCellInfo *info = [DeviceSceneTool sharedDeviceSceneTool].lastCellInfo;
        if (info && [DeviceSceneTool sharedDeviceSceneTool].lastService) {
            [self.cooperationCellMutaArr addObject:info];
            [self.sendServiceArr addObject:[DeviceSceneTool sharedDeviceSceneTool].lastService];
            [self.tableView reloadData];
        }
    }];
    [self.navigationController pushViewController:dacc animated:YES];
}
/**字典转json*/
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
static BOOL isRegister = NO;
-(void)saveScene{
    NSMutableArray *mutaArr = [NSMutableArray array];
    for (DeviceSceneCooperationService *service in self.sendServiceArr) {
        if (service) {
            NSDictionary *dict = @{@"thingId":service.thingId,
                                   @"serviceId":service.serviceId,
                                   @"serviceParam":service.serviceParam,
                                   @"number":service.number,
                                   @"harborIp":service.harborIp,
                                   @"delayTime":service.delayTime
                                   };
            
            [mutaArr addObject:dict];
        }
    }
    if (mutaArr.count==0) {
        [MBProgressHUD showError:@"请添加操作"];
        return;
    }
    if (self.sceneNameFld.text.length == 0) {
        [MBProgressHUD showError:@"请输入场景名"];
        return;
    }
    self.registerInfo.cooperationName = self.sceneNameFld.text;
    self.registerInfo.conditionType = self.typeChoiceSegment.selectedSegmentIndex?@"device":@"time";
    self.registerInfo.cooperationServices = mutaArr;
    
    if (self.typeChoiceSegment.selectedSegmentIndex == 0) {
        //按时间类型注册场景
        //名称
        self.registerInfo.exeFrequency = self.timeView.dayChoiceButton.titleLabel.text;
        self.registerInfo.time = self.timeView.timeChoiceButton.titleLabel.text;
        
        
    }else{
        //按设备类型注册
        if(self.conditions && ((NSArray *)self.conditions[@"conditionList"]).count>0){
            self.registerInfo.conditions = self.conditions;
            
        }else{
            [MBProgressHUD showError:@"请至少打开一项设备"];
            return;
        }
    }
    //开始注册
    if (!isRegister) {
        isRegister = YES;
        [[DeviceSceneTool sharedDeviceSceneTool]sendRegisterWithInfo:self.registerInfo response:^(NSDictionary *dict) {
            isRegister = NO;
            if ([dict[@"error_code"]intValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"添加成功"];
                    if (self.delegate) {
                        [self.delegate deviceSceneAddControllerDidAddScene];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else if([dict[@"error_code"]intValue] == 1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"场景名重复"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"网络连接失败"];
                });
            }
        }];
        
    }
}

-(void)setUpTypeSetCell{
    
    if (!self.timeView) {
        self.timeView = [[NSBundle mainBundle]loadNibNamed:@"DeviceSceneTimeTypeView" owner:nil options:nil].lastObject;
        [self.timeView.dayChoiceButton addTarget:self action:@selector(clickDayChoiceButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeView.timeChoiceButton addTarget:self action:@selector(clickTimeChoiceButton:) forControlEvents:UIControlEventTouchUpInside];
        self.timeView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 107);
        [self.typeSetCell addSubview:self.timeView];
    }
    
    if (!self.deviceView) {
        self.deviceView = [[DeviceSceneDeviceTypeView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200) groupArray:self.groupArray didGetRelationDevice:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.conditions = self.deviceView.conditions;
                [self.tableView reloadData];
            });
        }];
        self.deviceView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 200);
        [self.typeSetCell addSubview:self.deviceView];
    }
    
    if (self.typeChoiceSegment.selectedSegmentIndex==0) {
        self.timeView.hidden = NO;
        self.deviceView.hidden = YES;
        [self.tableView reloadData];
    }else{
        self.timeView.hidden = YES;
        self.deviceView.hidden = NO;
        [self.tableView reloadData];
    }
    
    
}
-(void)clickDayChoiceButton:(UIButton*)button{
    DayChoiceController *dcc = [[DayChoiceController alloc]initWithCompleteBlock:^(NSArray *choice) {
        NSString *str = @"周";
        
        if (((NSNumber*)choice[0]).boolValue == 1 && ((NSNumber*)choice[1]).boolValue == 1 && ((NSNumber*)choice[2]).boolValue == 1 && ((NSNumber*)choice[3]).boolValue == 1 && ((NSNumber*)choice[4]).boolValue == 1 && ((NSNumber*)choice[5]).boolValue == 1 && ((NSNumber*)choice[6]).boolValue == 1) {
            str = @"每天";
        }else if(((NSNumber*)choice[0]).boolValue == 0 && ((NSNumber*)choice[1]).boolValue == 1 && ((NSNumber*)choice[2]).boolValue == 1 && ((NSNumber*)choice[3]).boolValue == 1 && ((NSNumber*)choice[4]).boolValue == 1 && ((NSNumber*)choice[5]).boolValue == 1 && ((NSNumber*)choice[6]).boolValue == 0){
            str = @"工作日";
        }else if(((NSNumber*)choice[0]).boolValue == 1 && ((NSNumber*)choice[1]).boolValue == 0 && ((NSNumber*)choice[2]).boolValue == 0 && ((NSNumber*)choice[3]).boolValue == 0 && ((NSNumber*)choice[4]).boolValue == 0 && ((NSNumber*)choice[5]).boolValue == 0 && ((NSNumber*)choice[6]).boolValue == 1){
            str = @"双休日";
        }else{
            NSArray *arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
            int i = 0;
            BOOL temp = false;
            for (NSNumber *num in choice) {
                
                if (num.boolValue) {
                    if (temp) {
                        str = [str stringByAppendingString:@","];
                    }
                    str = [str stringByAppendingString:arr[i]];
                    temp = true;
                }
                i++;
            }
        }
        
        [self.timeView.dayChoiceButton setTitle:str forState:UIControlStateNormal];
        
    }];
    [self.navigationController pushViewController:dcc animated:YES];
}
-(void)clickTimeChoiceButton:(UIButton*)button{
    self.alert = [UIAlertController alertControllerWithTitle:@"选择时间" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //点击确定按钮的事件处理
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:self.picker.date];
        [self.timeView.timeChoiceButton setTitle:destDateString forState:UIControlStateNormal];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //点击取消按钮的事件处理
    }];
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];//初始化一个UIDatePicker
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.frame = CGRectMake(0, 25, _alert.view.frame.size.width, _alert.view.frame.size.height*0.33);
    self.picker = datePicker;
    [_alert.view addSubview:datePicker];//将datePicker添加到UIAlertController实例中
    [_alert addAction:cancel];//将取消按钮添加到UIAlertController实例中
    [_alert addAction:confirm];//将确定按钮添加到UIAlertController实例中
    
    [self presentViewController:_alert animated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cooperationCellMutaArr.count+1+DynamicStartNumber;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row-DynamicStartNumber;
    if (indexPath.row == 0) {
        return self.nameCell;
    }else if(indexPath.row == 1){
        return self.choiceCell;
    }else if (indexPath.row == 2){
        return self.typeSetCell;
    }else if (indexPath.row == DynamicStartNumber+self.cooperationCellMutaArr.count){
        return self.deviceServiceCell;
    }else if (index<self.cooperationCellMutaArr.count){
        DeviceCooperationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cooperationCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"DeviceCooperationDetailCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        DeviceSceneCooperationCellInfo *info = self.cooperationCellMutaArr[index];
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:info.imageUrlStr]];
        cell.cellLabel.text = info.cooperationTitle;
        cell.cellNameLabel.text = info.groupName;
        cell.cellDetailLabel.text = info.detailTitle;
        cell.cellDetailTypeLabel.text = info.typeTitle;
        
        return cell;
    }else{
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row == 1) {
        return 81;
    }else if (indexPath.row == 2) {
        if (self.typeChoiceSegment.selectedSegmentIndex == 0) {
            return 107;
            
        }else{
            CGFloat height = self.deviceView.viewHeight;
            return height;
        }
    }else if (indexPath.row == DynamicStartNumber+self.cooperationCellMutaArr.count){
        return 49;
    }else{
        if(self.cooperationCellMutaArr.count>0){
            return 80;
        }else {
            return 0;
        }
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < DynamicStartNumber+self.cooperationCellMutaArr.count && indexPath.row>DynamicStartNumber-1) {
        return YES;
    }
    return NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < DynamicStartNumber+self.cooperationCellMutaArr.count && indexPath.row>DynamicStartNumber-1) {
            [self.cooperationCellMutaArr removeObjectAtIndex:indexPath.row-DynamicStartNumber];
            [self.sendServiceArr removeObjectAtIndex:indexPath.row-DynamicStartNumber];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

-(void)setUpDeviceServiceCell{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)cooperationCellMutaArr{
    if (!_cooperationCellMutaArr) {
        _cooperationCellMutaArr = [NSMutableArray array];
    }
    return _cooperationCellMutaArr;
}
-(NSMutableArray *)sendServiceArr{
    if(!_sendServiceArr){
        _sendServiceArr = [NSMutableArray array];
    }
    return _sendServiceArr;
}


@end
