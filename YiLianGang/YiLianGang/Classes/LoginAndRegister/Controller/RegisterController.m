//
//  RegisterController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/21.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//
#warning 该类已禁用

#import "RegisterController.h"
#import "RegisterInfoTool.h"
#import "SelectUtil.h"
#import "ProtocolViewController.h"
#import "AppDelegate.h"
#import "UIImage+ImageColorChange.h"
@interface RegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *provinceField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *regionField;
@property (weak, nonatomic) IBOutlet UITextField *communityField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconLogo;


@property(nonatomic,strong) RegisterInfoTool *registerTool;
@property(nonatomic,strong) YLCountry *selectCountry;
@property(nonatomic,strong) YLProvince *selectProvince;
@property(nonatomic,strong) YLCity *selectCity;
@property(nonatomic,strong) YLRegion *selectRegion;

@property(nonatomic,assign) BOOL isCheck;

@end

@implementation RegisterController

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCheck = YES;
    self.nameField.delegate = self;
    self.pwdField.delegate = self;
    self.pwdAgainField.delegate = self;
    self.communityField.delegate = self;
    self.detailAddressField.delegate = self;
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.masksToBounds = YES;
    
    self.registerTool = [RegisterInfoTool sharedRegisterInfoTool];
    [self sendRequestToSelectCountryHandler:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//- (IBAction)clickCheckButton:(id)sender {
//    //点击勾
//    self.isCheck = !self.isCheck;
//    if (self.isCheck) {
//        //如果划勾了
//        self.checkImageView.image = [UIImage imageNamed:@"reg_gou"];
//    }else{
//        //没划勾
//        self.checkImageView.image = [UIImage new];
//    }
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.iconLogo.image = [self.iconLogo.image imageChangeColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1]];
}
- (IBAction)clickYlgProtocolButton:(id)sender {
    //点击协议
    ProtocolViewController *pvc = [[ProtocolViewController alloc]initWithNibName:@"ProtocolViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
    
}
- (IBAction)clickRegisterButton:(id)sender {
    BOOL isConditionAlready = [self isConditionAlready];
    if (isConditionAlready) {
        
        NSDictionary *dict = @{@"username":self.nameField.text,
                               @"password":self.pwdField.text,
                               @"tel":self.phoneField.text,
                               @"countryId":self.selectCountry.countryId,
                               @"provinceId":self.selectProvince.provinceId,
                               @"cityId":self.selectCity.cityId,
                               @"countyId":self.selectRegion.countyId,
                               @"communityId":self.communityField.text,
                               @"otherInfo":self.detailAddressField.text
                               };
        if ([AppDelegate isNeedHidden]) {
            dict =  @{@"username":self.nameField.text,
                      @"password":self.pwdField.text,
                      @"tel":self.phoneField.text,
                      @"countryId":@"1",
                      @"provinceId":@"110000",
                      @"cityId":@"110100",
                      @"countyId":@"110108",
                      @"communityId":@"test",
                      @"otherInfo":@"test"
                      };
            
        }
        NSLog(@"%@",dict);
        NSDictionary *dic = @{@"nameValuePairs":dict};
        [[RegisterInfoTool sharedRegisterInfoTool]sendRegisterRequestWithDict:dic response:^(NSDictionary *dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dict) {
                    
                    if ([dict[@"error_code"]integerValue]==0) {
                        [self.navigationController popViewControllerAnimated:YES];
                        NSString *msg = dict[@"error_msg"];
                        [ToastUtil showToast:msg];
                    }else if([dict[@"error_code"] integerValue]>0){
                        NSString *msg = dict[@"error_msg"];
                        [ToastUtil showToast:msg];
                    }else{
                        [ToastUtil showToast:@"网络错误"];
                    }
                }
                else{
                    [ToastUtil showToast:@"网络错误"];
                }
            });
        }];
    }
}

- (IBAction)clickCountrySelectButton:(id)sender {
    //选择国家
    WS(weakSelf);
    [self sendRequestToSelectCountryHandler:^(NSArray *strArr, NSArray *objArr) {
        [[SelectUtil sharedSelectUtil]showSelectArray:strArr selectBlock:^(NSInteger index, NSString *str) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.selectCountry = objArr[index];
                weakSelf.countryField.text = str;
                [weakSelf sendRequestToSelectProvinceHandler:nil];
            });
        }];
        
    }];
}
- (IBAction)clickProvinceSelectButton:(id)sender {
    //选择省
    WS(weakSelf);
    [self sendRequestToSelectProvinceHandler:^(NSArray *strArr, NSArray *objArr) {
        [[SelectUtil sharedSelectUtil]showSelectArray:strArr selectBlock:^(NSInteger index, NSString *str) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.selectProvince = objArr[index];
                weakSelf.provinceField.text = str;
                [weakSelf sendRequestToSelectCityHandler:nil];
            });
        }];
        
    }];
}
- (IBAction)clickCitySelectButton:(id)sender {
    //选择城市
    WS(weakSelf);
    [self sendRequestToSelectCityHandler:^(NSArray *strArr, NSArray *objArr) {
        [[SelectUtil sharedSelectUtil]showSelectArray:strArr selectBlock:^(NSInteger index, NSString *str) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.selectCity = objArr[index];
                weakSelf.cityField.text = str;
                [weakSelf sendRequestToSelectRegionHandler:nil];
            });
        }];
    }];
}
- (IBAction)clickRegionSelectButton:(id)sender {
    //选择区
    WS(weakSelf);
    [self sendRequestToSelectRegionHandler:^(NSArray *strArr, NSArray *objArr) {
        [[SelectUtil sharedSelectUtil]showSelectArray:strArr selectBlock:^(NSInteger index, NSString *str) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.selectRegion = objArr[index];
                weakSelf.regionField.text = str;
            });
        }];
    }];
}


#pragma mark 选择城市
-(void)sendRequestToSelectCountryHandler:(void(^)(NSArray* strArr,NSArray* objArr))block {
    WS(weakSelf);
    [self.registerTool sendRequestToGetAllCountryResponse:^(NSArray *arr) {
        NSMutableArray *strArr = [NSMutableArray array];
        for(YLCountry *country in arr){
            [strArr addObject:country.countryName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count>0) {
                weakSelf.selectCountry = arr[0];
                weakSelf.countryField.text = weakSelf.selectCountry.countryName;
                [weakSelf sendRequestToSelectProvinceHandler:nil];
            }
            if (block) {
                block([strArr copy],arr);
            }
        });
    }];
}
#pragma mark 选择省
-(void)sendRequestToSelectProvinceHandler:(void(^)(NSArray* strArr,NSArray* objArr))block {
    WS(weakSelf);
    [self.registerTool sendRequestToGetAllProvinceInCountry:self.selectCountry response:^(NSArray *arr) {
        NSMutableArray *strArr = [NSMutableArray array];
        for(YLProvince *province in arr){
            [strArr addObject:province.provinceName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count>0) {
                weakSelf.selectProvince = arr[0];
                weakSelf.provinceField.text = weakSelf.selectProvince.provinceName;
                [weakSelf sendRequestToSelectCityHandler:nil];
                if (block) {
                    block([strArr copy],arr);
                }
            }
            
        });
    }];
}
#pragma mark 选择市
-(void)sendRequestToSelectCityHandler:(void(^)(NSArray* strArr,NSArray* objArr))block {
    WS(weakSelf);
    [self.registerTool sendRequestToGetAllCity:self.selectProvince response:^(NSArray *arr) {
        NSMutableArray *strArr = [NSMutableArray array];
        for(YLCity *city in arr){
            [strArr addObject:city.cityName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count>0) {
                weakSelf.selectCity = arr[0];
                weakSelf.cityField.text = weakSelf.selectCity.cityName;
                [weakSelf sendRequestToSelectRegionHandler:nil];
                if (block) {
                    block([strArr copy],arr);
                }
            }
            
        });
    }];
}
#pragma mark 选择区
-(void)sendRequestToSelectRegionHandler:(void(^)(NSArray* strArr,NSArray* objArr))block {
    WS(weakSelf);
    [self.registerTool sendRequestToGetAllRegion:self.selectCity response:^(NSArray *arr) {
        NSMutableArray *strArr = [NSMutableArray array];
        for(YLRegion *region in arr){
            [strArr addObject:region.countyName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count>0) {
                weakSelf.selectRegion = arr[0];
                weakSelf.regionField.text = weakSelf.selectRegion.countyName;
                if (block) {
                    block([strArr copy],arr);
                }
            }
        });
    }];
}
#pragma mark 注册条件判断
//判断注册条件
-(BOOL)isConditionAlready{
    if (self.phoneField.text.length!=11) {
        [ToastUtil showToast:@"手机号输入位数错误"];
        return NO;
    }
    if (![self isAllNum:self.phoneField.text]) {
        [ToastUtil showToast:@"手机号输入错误"];
        return NO;
    }
    if (self.nameField.text.length<2||self.nameField.text.length>6) {
        [ToastUtil showToast:@"名字长度要求2-6"];
        return NO;
    }
    if ([self getToInt:self.pwdField.text]<6 || [self getToInt:self.pwdField.text]>12) {
        [ToastUtil showToast:@"密码长度要求6-12"];
        return NO;
    }
    if(self.communityField.text.length==0){
        [ToastUtil showToast:@"请填写社区"];
        return NO;
    }
    if (self.detailAddressField.text.length == 0) {
        [ToastUtil showToast:@"请填写详细地址"];
        return NO;
    }
    if ([self getToInt:self.detailAddressField.text]>60) {
        [ToastUtil showToast:@"详细地址请保持30个汉字之内"];
        return NO;
    }
    if ([self getToInt:self.communityField.text]>60) {
        [ToastUtil showToast:@"社区请保持30个汉字之内"];
        return NO;
    }
    if (![self.pwdField.text isEqualToString:self.pwdAgainField.text]) {
        [ToastUtil showToast:@"两次密码不相同"];
        return NO;
    }
    if (!self.isCheck) {
        [ToastUtil showToast:@"请同意协议"];
        return NO;
    }
    return YES;
}

//得到中英文混合字符串长度 方法2
- (NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}
//判断字符串中是否全部是数字
- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self.view endEditing:YES];
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
