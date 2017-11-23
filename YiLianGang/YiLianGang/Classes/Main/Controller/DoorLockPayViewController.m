//
//  DoorLockPayViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/15.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DoorLockPayViewController.h"
#import "JXPopoverView.h"
#import "MBProgressHUDUtil.h"
#import "AppointmentInstallRequestTool.h"

@interface DoorLockPayViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTelTextField;

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;



@end

@implementation DoorLockPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameTextField.delegate = self;
    self.userTelTextField.delegate = self;
    self.verificationCodeTextField.delegate = self;
    self.addressTextField.delegate = self;
    self.remarkTextField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseModelButton:(id)sender {
    if (self.modelArray.count) {
        JXPopoverView *popoverView = [JXPopoverView popoverView];
        NSMutableArray *JXPopoverActionArray = [[NSMutableArray alloc] init];
        for (NSString *name in self.modelArray) {
            JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:name handler:^(JXPopoverAction *action) {
                self.modelLabel.text = name;
                [self.payButton setTitle:[NSString stringWithFormat:@"支付：¥%@.00",[self.piceDict objectForKey:name]] forState:UIControlStateNormal];
            }];
            [JXPopoverActionArray addObject:action1];
        }
        [popoverView showToView:sender withActions:JXPopoverActionArray];
    }
}

#pragma mark - 支付按钮
- (IBAction)payButtonMethod:(id)sender {
[MBProgressHUDUtil showMessage:@"敬请期待" toView:self.view];
}

#pragma mark - 获取验证码

- (IBAction)getVerificationCode:(id)sender {
    
    //先判断手机号是否为空
    if ([self.userTelTextField.text isEqualToString:@""]) {
        [MBProgressHUDUtil showMessage:@"请填写手机号" toView:self.view];
        return;
    }
    if (![self isMobileNumber:self.userTelTextField.text]) {
        [MBProgressHUDUtil showMessage:@"手机号格式错误！" toView:self.view];
        return;
    }
    [self openCountdown:self.getVerificationCodeButton];
    [AppointmentInstallRequestTool sharedInstallTool].urlString = @"ReserveSever/Doorlocksubscribe/sendVerify";
    NSDictionary *parmDic = @{@"tel":self.userTelTextField.text};
    [AppointmentInstallRequestTool sharedInstallTool].parameterDict = parmDic;
    [[AppointmentInstallRequestTool sharedInstallTool] sendInstallRequestWithResponse:^(NSDictionary *dict) {
        if (dict) {
            NSLog(@"打印信息：%@",dict);
        }else
        {
            
        }
    }];
    
}

-(void)openCountdown:(UIButton *)button
{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:36.f/255.f green:149.f/255.f blue:253.f/255.f alpha:1] forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [button setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - 判断手机号
-(BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
