//
//  InstallInformationViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/24.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "InstallInformationViewController.h"
#import "WOTDatePickerView.h"
#import "JudgmentTime.h"
#import "OrderTool.h"



@interface InstallInformationViewController ()<UITextFieldDelegate>
{
    NSString *time;
}
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *productNameText;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *standbyTelText;

@property (weak, nonatomic) IBOutlet UITextField *timeText;
@property (weak, nonatomic) IBOutlet UITextField *adressText;
@property (weak, nonatomic) IBOutlet UITextField *remarkText;
@property (nonatomic, strong) WOTDatePickerView *datepickerview;
@property (nonatomic, strong) JudgmentTime *judgmentTime;
@property (nonatomic, assign) BOOL isValidTime;
@property (nonatomic, assign) BOOL isValidTel;
@end

@implementation InstallInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameText.delegate = self;
    self.productNameText.delegate = self;
    self.telText.delegate = self;
    self.standbyTelText.delegate = self;
    self.timeText.delegate = self;
    self.adressText.delegate = self;
    self.remarkText.delegate = self;
    
    self.nameText.placeholder = @"必填";
    self.productNameText.placeholder = @"必填";
    self.telText.placeholder = @"必填";
    self.standbyTelText.placeholder = @"选填";
    self.timeText.placeholder = @"必填";
    self.adressText.placeholder = @"必填";
    self.remarkText.placeholder = @"必填";
    [self setupView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.judgmentTime = [[JudgmentTime alloc] init];
}

-(void)setupView
{
    __weak typeof(self) weakSelf = self;
    _datepickerview = [[NSBundle mainBundle]loadNibNamed:@"WOTDatePickerView" owner:nil options:nil].lastObject;
    [_datepickerview setFrame:CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300)];
    _datepickerview.cancelBlokc = ^(){
        weakSelf.datepickerview.hidden = YES;
    };
    _datepickerview.okBlock = ^(NSInteger year,NSInteger month,NSInteger day,NSInteger hour,NSInteger min){
        weakSelf.datepickerview.hidden = YES;
        NSLog(@"%ld年%ld月%ld日",year,month,day);
        self.isValidTime = [self.judgmentTime judgementTimeWithYear:year month:month day:day];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isValidTime) {
                time = [NSString stringWithFormat:@"%02d/%02d/%02d%@%02d%@%02d%@%@ ",(int)year, (int)month, (int)day,@" ",(int)hour,@":",(int)min,@":",@"00"];
                self.timeText.text = time;
                _datepickerview.hidden  = YES;
            }else
            {
                //[MBProgressHUDUtil showMessage:@"请选择有效时间！" toView:self.view];
                [ToastUtil showToast:@"请选择有效时间！"];

                time = @"";
                _datepickerview.hidden  = NO;
            }
            //[weakSelf.table reloadData];
        });
    };
    [self.view addSubview:_datepickerview];
    _datepickerview.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    if (textField.tag == 1) {
        self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216

    }
    if (textField.tag == 2) {
        self.view.frame = CGRectMake(0.0f, -150.0f, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    if (textField.tag == 3) {
        [self.view endEditing:YES];
        _datepickerview.hidden = NO;
        return NO;
    }
    
    [UIView commitAnimations];
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    
   // [self.remarkText resignFirstResponder];
    [self.view endEditing:YES];
    [UIView commitAnimations];
    return YES;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height); //64-216
    [self.view endEditing:YES];
    //[self.remarkText resignFirstResponder];
    [UIView commitAnimations];
}

- (IBAction)orderButton:(id)sender {
    NSLog(@"测试：%@",self.nameText.text);
    BOOL isName = (self.nameText.text == nil) ||[self.nameText.text isEqualToString:@""];
    BOOL isProductName = self.productNameText.text == nil||[self.productNameText.text isEqualToString:@""];
    BOOL isTelText = self.telText.text == nil||[self.telText.text isEqualToString:@""];
    BOOL isStandbyTel = self.standbyTelText.text == nil||[self.standbyTelText.text isEqualToString:@""];
    BOOL isTime = self.timeText.text == nil||[self.timeText.text isEqualToString:@""];
    BOOL isAdress = self.adressText.text == nil||[self.adressText.text isEqualToString:@""];
    BOOL isRemark = self.remarkText.text == nil||[self.remarkText.text isEqualToString:@""];
    if (isName || isProductName || isTelText || isTime || isAdress ||isRemark) {
        [ToastUtil showToast:@"请填写完整信息！"];
        return;
    }
    
    
    if (!isStandbyTel) {
        if (![self valiMobile:self.standbyTelText.text]) {
            [ToastUtil showToast:@"电话号码格式不正确！"];
            return;
        }
    }
    
    
    NSDictionary *parameter = @{@"tel":self.telText.text,
                                    @"reserveTel":self.standbyTelText.text,
                                    @"userName":self.nameText.text,
                                    @"site":self.adressText.text,
                                    @"poductName":self.productNameText.text,
                                    @"remark":self.remarkText.text,
                                    @"appointmentTime":self.timeText.text
                                    };
    [OrderTool sharedOrderTool].paramDictionary = parameter;
    //[OrderTool sharedOrderTool] sendOrderRequestWithResponse:<#^(NSDictionary *dict)block#>;
    [[OrderTool sharedOrderTool] sendOrderRequest];
    
    
}

#pragma mark - 判断手机号
-(BOOL)valiMobile:(NSString*)mobile
{
    mobile = [mobile  stringByReplacingOccurrencesOfString:@" "withString:@""];
        if (mobile.length != 11)
            {
                    return NO;
                }else{
                        /**
                                  * 移动号段正则表达式
                                  */
                        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
                        /**
                                  * 联通号段正则表达式
                                  */
                        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
                        /**
                                  * 电信号段正则表达式
                                  */
                        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
                        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
                        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
                        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
                        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
                        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
                        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
                 
                        if (isMatch1 || isMatch2 || isMatch3) {
                                return YES;
                            }else{
                                    return NO;
                                }
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

@end
