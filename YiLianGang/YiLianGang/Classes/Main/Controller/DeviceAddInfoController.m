//
//  DeviceAddInfoController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/9/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceAddInfoController.h"
#import "DeviceTool.h"
#import "WNListView.h"
#import "LoginTool.h"
#import "RegisterInfoTool.h"
#import "MBProgressHUD+KR.h"
#import "BRPlaceholderTextView.h"
#import "ServiceReturnInformation.h"
#import "PromptMessageViewController.h"

@interface DeviceAddInfoController ()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTexFld;
@property (weak, nonatomic) IBOutlet UITextField *deviceGroupSelectTexFld;
@property (weak, nonatomic) IBOutlet UITextField *deviceCountrySelectTexFld;
@property (weak, nonatomic) IBOutlet UITextField *deviceProvinceSelectTexFld;
@property (weak, nonatomic) IBOutlet UITextField *deviceCitySelectTexFld;
@property (weak, nonatomic) IBOutlet UITextField *deviceRegionSelectTexFld;
@property (weak, nonatomic) IBOutlet UITextField *deviceCommunityTexFld;
@property(nonatomic,strong) IBOutlet BRPlaceholderTextView *deviceDetailAddressTexView;

@property(nonatomic,strong) NSArray *deviceGroupNameArr;
@property(nonatomic,strong) NSArray *deviceGroupIdArr;

@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *groupId;
@property(nonatomic,strong) YLCountry *country;
@property(nonatomic,strong) YLProvince *province;
@property(nonatomic,strong) YLCity *city;
@property(nonatomic,strong) YLRegion *region;
@property(nonatomic,strong) NSString *community;
@property(nonatomic,strong) NSString *detailLocation;
@property(nonatomic,strong) NSString *thingname;

@property(nonatomic,strong) NSArray *errorMsgArr;

@end

@implementation DeviceAddInfoController
-(NSArray *)errorMsgArr{
    if (!_errorMsgArr) {
        _errorMsgArr = @[@"物体注册成功",@"用户没有注册物体域名",@"物体描述不存在",@"主港信息不存在",@"物体描述中某些必要字段为空",@"用户不存在",@"主港信息错误",@"无法选择备用港",@"系统错误",@"该物体已经被注册",@"该物体名称已经被注册",@"连接到主港失败",@"注册物体到主港时出错",@"连接到备用港失败",@"注册物体到备用港时出错",@"连接不到服务器，请检查网络连接情况"];
        
    }
    return _errorMsgArr;
}
-(NSString *)userId{
    if (!_userId) {
        _userId = [LoginTool sharedLoginTool].userID;
    }
    return _userId;
}
-(void)tapView:(UITapGestureRecognizer*)gesture{
    [self.view endEditing:YES];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view.superview.superview.superview.superview class]) isEqualToString:@"WNListView"]) {
        
        return NO;
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    self.deviceNameTexFld.delegate = self;
    self.deviceGroupSelectTexFld.delegate = self;
    self.deviceCountrySelectTexFld.delegate = self;
    self.deviceProvinceSelectTexFld.delegate = self;
    self.deviceCitySelectTexFld.delegate = self;
    self.deviceRegionSelectTexFld.delegate = self;
    self.deviceCommunityTexFld.delegate = self;
    self.deviceDetailAddressTexView.delegate = self;
    
    self.deviceCommunityTexFld.placeholder = @"选填";
    self.deviceDetailAddressTexView.placeholder =@"选填";
    [self.deviceDetailAddressTexView setPlaceholderOpacity:0.4];
    if (self.navigationController) {
        //左边
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.frame = CGRectMake(0, 0, 60, 40);
        [leftButton setTitle:@"        " forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
        
        leftButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
        [leftButton addTarget:self action:@selector(clickTopLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [leftView addSubview:leftButton];
        leftView.backgroundColor = [UIColor clearColor];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
        
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)clickTopLeftButton:(UIButton*)button{
    //    if (self.navigationController) {
    //        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 保存信息
-(void)saveInfo{
    [DeviceTool sharedDeviceTool].deviceSendInfo.thingName = self.deviceNameTexFld.text;
    [DeviceTool sharedDeviceTool].deviceSendInfo.groupId = [NSNumber numberWithInteger:self.groupId.integerValue] ;
    [DeviceTool sharedDeviceTool].deviceSendInfo.country = self.country.countryName;
    [DeviceTool sharedDeviceTool].deviceSendInfo.province = self.province.provinceName;
    [DeviceTool sharedDeviceTool].deviceSendInfo.city = self.city.cityName;
    [DeviceTool sharedDeviceTool].deviceSendInfo.county = self.region.countyName;
    [DeviceTool sharedDeviceTool].deviceSendInfo.community = self.deviceCommunityTexFld.text;
    [DeviceTool sharedDeviceTool].deviceSendInfo.detailLocation = self.deviceDetailAddressTexView.text;
    DeviceSendInfo *info = [DeviceTool sharedDeviceTool].deviceSendInfo;
    //    info.ProduceTime = @"2014-01-01";
    //    info.localID = @"18975679901829";
    //    info.model = @"SOIW-T100F01V01";
    //    info.producer = @"四海万联";
    //    info.type = @"车载盒子";
    info.userId = [NSNumber numberWithInteger:[LoginTool sharedLoginTool].userID.integerValue];
    //NSLog(@"%ld,%ld,%ld,%ld,%ld,%ld",info.thingName.length,info.groupId.stringValue.length,info.country.length,info.province.length,info.city.length,info.county.length);
    if (info.thingName.length==0 || info.groupId.stringValue.length == 0 || info.country.length == 0 ||info.province.length == 0 ||info.city.length == 0 || info.county.length == 0 ) {
        [MBProgressHUD showError:@"请填写完整"];
        return;
    }
    
    [[DeviceTool sharedDeviceTool]sendInfoWithSendInfo:info response:^(NSDictionary *dict) {
        NSLog(@"返回的数据：%@",dict);
        if ([dict objectForKey:@"data"]) {
            ServiceReturnInformation *returnInfo = [ServiceReturnInformation sharedReturnInfo];
            returnInfo.returnInfoDictionary =[dict objectForKey:@"data"];
        }
        NSLog(@"返回的数据：%@",[dict objectForKey:@"data"]);
        if (dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"%ld",((NSNumber*)dict[@"error_code"]).longValue);
                NSInteger errorIndex =((NSNumber*)dict[@"error_code"]).integerValue;
                if (errorIndex == 0) {
                    //                    PromptMessageViewController *prompMessage = [[PromptMessageViewController alloc] init];
                    //                    [self.navigationController pushViewController:prompMessage animated:YES];
                    
                    PromptMessageViewController *vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PromptMessageViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    //                    [MBProgressHUD showSuccess:@"设备添加成功"];
                    //                    if ([self.delegate respondsToSelector:@selector(deviceDidAdded)]) {
                    //                        [self.delegate deviceDidAdded];//添加设备
                    //                    }
                    //[self clickTopLeftButton:nil];
                }else if (errorIndex > 0 && errorIndex < 15 &&errorIndex<self.errorMsgArr.count) {
                    
                    NSString *errorStr = [NSString stringWithFormat:@"%@",self.errorMsgArr[errorIndex]];
                    [ToastUtil showToast:errorStr];
                }else{
                    [ToastUtil showToast:@"请检查网络"];
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [ToastUtil showToast:@"请检查网络"];
            });
        }
        
    }];
    
    
}
-(void)closeKeyBoard{
    
    [self.view endEditing:YES];
}
- (IBAction)selectGroup:(UIButton*)sender {
    [self closeKeyBoard];
    NSMutableArray *mutaArr = [NSMutableArray array];
    NSMutableArray *mutaArr2 = [NSMutableArray array];
    for (DeviceGroupInfo *info in [DeviceTool sharedDeviceTool].allGroup) {
        [mutaArr addObject:info.groupName];
        [mutaArr2 addObject:info.groupId];
    }
    self.deviceGroupNameArr = [mutaArr copy];
    self.deviceGroupIdArr = [mutaArr2 copy];
    UIView *view = [UIApplication sharedApplication].keyWindow;
    WNListView *listView = [WNListView listViewWithArrayStr:self.deviceGroupNameArr acordingFrameInScreen:[sender convertRect:sender.bounds toView:view] superView:view clickResponse:^(NSUInteger index) {
        self.deviceGroupSelectTexFld.text = self.deviceGroupNameArr[index];
        self.groupId = self.deviceGroupIdArr[index];
    }];
    
    
}
- (IBAction)selectCountry:(UIButton*)sender {
    [self closeKeyBoard];
    [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllCountryResponse:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mutaArr = [NSMutableArray array];
            for (YLCountry *info in arr) {
                [mutaArr addObject:info.countryName];
                
            }
            UIView *view = [UIApplication sharedApplication].keyWindow;
            
            WNListView *listView = [WNListView listViewWithArrayStr:[mutaArr copy] acordingFrameInScreen:[sender convertRect:sender.bounds toView:view] superView:view clickResponse:^(NSUInteger index) {
                self.deviceCountrySelectTexFld.text = mutaArr[index];
                self.country = arr[index];
                self.province = nil;
                self.deviceProvinceSelectTexFld.text = nil;
                self.city = nil;
                self.deviceCitySelectTexFld.text = nil;
                self.region = nil;
                self.deviceRegionSelectTexFld.text = nil;
                
            }];
            
        });
    }];
    
    
}
- (IBAction)selectProvince:(UIButton*)sender {
    [self closeKeyBoard];
    if (!self.country) {
        return;
    }
    [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllProvinceInCountry:self.country response:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mutaArr = [NSMutableArray array];
            for (YLProvince *info in arr) {
                [mutaArr addObject:info.provinceName];
                
            }
            UIView *view = [UIApplication sharedApplication].keyWindow;
            
            WNListView *listView = [WNListView listViewWithArrayStr:[mutaArr copy] acordingFrameInScreen:[sender convertRect:sender.bounds toView:view] superView:view clickResponse:^(NSUInteger index) {
                self.deviceProvinceSelectTexFld.text = mutaArr[index];
                self.province = arr[index];
                self.city = nil;
                self.deviceCitySelectTexFld.text = nil;
                self.region = nil;
                self.deviceRegionSelectTexFld.text = nil;
            }];
            
        });
    }];
}
- (IBAction)selectCity:(UIButton*)sender {
    [self closeKeyBoard];
    if (!self.province) {
        return;
    }
    [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllCity:self.province response:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mutaArr = [NSMutableArray array];
            for (YLCity *info in arr) {
                [mutaArr addObject:info.cityName];
                
            }
            UIView *view = [UIApplication sharedApplication].keyWindow;
            
            WNListView *listView = [WNListView listViewWithArrayStr:[mutaArr copy] acordingFrameInScreen:[sender convertRect:sender.bounds toView:view] superView:view clickResponse:^(NSUInteger index) {
                self.deviceCitySelectTexFld.text = mutaArr[index];
                self.city = arr[index];
                self.region = nil;
                self.deviceRegionSelectTexFld.text = nil;
            }];
            
        });
    }];
}
- (IBAction)selectRegion:(UIButton*)sender {
    [self closeKeyBoard];
    if (!self.city) {
        return;
    }
    [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllRegion:self.city response:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mutaArr = [NSMutableArray array];
            for (YLRegion *info in arr) {
                [mutaArr addObject:info.countyName];
            }
            UIView *view = [UIApplication sharedApplication].keyWindow;
            
            WNListView *listView = [WNListView listViewWithArrayStr:[mutaArr copy] acordingFrameInScreen:[sender convertRect:sender.bounds toView:view] superView:view clickResponse:^(NSUInteger index) {
                self.deviceRegionSelectTexFld.text = mutaArr[index];
                self.region = arr[index];
                
            }];
            
        });
    }];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.deviceCommunityTexFld) {
        self.community = textField.text;
    }
    [textField resignFirstResponder];
    [self.view endEditing:YES];
}
-(BOOL)disablesAutomaticKeyboardDismissal{
    return NO;
}
#pragma mark UITextViewDelegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.deviceDetailAddressTexView) {
        self.detailLocation = self.deviceDetailAddressTexView.text;
    }
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end

