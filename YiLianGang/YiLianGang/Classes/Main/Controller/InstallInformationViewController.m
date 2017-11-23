//
//  InstallInformationViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/24.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "InstallInformationViewController.h"
#import "AppointmentInstallRequestTool.h"
#import "PayMentViewController.h"
#import "MBProgressHUDUtil.h"
#import "MBProgressHUD+Extension.h"
#import "InfoTableViewCell.h"
#import "VerificationCodeTableViewCell.h"
#import "AppointmentInstallRequestTool.h"
#import "OrderInquiryRequestTool.h"

@interface InstallInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *delegateTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *TickButton;


@property (nonatomic, strong) NSArray *infoArray;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userTel;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSString *adressStr;
@property (nonatomic, strong) NSString *remarkStr;
@property (nonatomic, assign) BOOL isTick;

@end

@implementation InstallInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单";
    self.isTick = NO;
    NSString *contentStr =@"两年期满拆机可退押金";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在3~length-3个单位长度内的内容显示成橙色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1] range:NSMakeRange(6, str.length-6)];
    self.infoLabel.attributedText = str;
    
    
    self.delegateTextView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.delegateTextView.layer.borderWidth = 0.6f;
    self.delegateTextView.layer.cornerRadius = 6.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.infoArray = @[@"用户名",@"手机号",@"验证码",@"地    址",@"备    注"];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,20,0,20)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,20,0,20)];
    }
   // self.SecurityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.SecurityCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];

    
   // [self getCurrentTime];
    self.payButton.layer.cornerRadius = 5.f;
    self.payButton.layer.borderWidth = 1.f;
    self.payButton.layer.borderColor = [UIColor colorWithRed:192.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:1].CGColor;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,20,0,20)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,20,0,20)];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        VerificationCodeTableViewCell *cell= [[[NSBundle mainBundle]loadNibNamed:@"VerificationCodeTableViewCell" owner:nil options:nil] firstObject];
        cell.infolabel.text = self.infoArray[indexPath.row];
        cell.inputInfoTextField.tag = indexPath.row;
        [cell.inputInfoTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        [cell.verificationCodeButton addTarget:self action:@selector(securityCodeButtonMethod:) forControlEvents:UIControlEventTouchDown];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        InfoTableViewCell *cell= [[[NSBundle mainBundle]loadNibNamed:@"InfoTableViewCell" owner:nil options:nil] firstObject];
        [cell.inputInfoTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        cell.inputInfoTextField.tag = indexPath.row;
        cell.infolabel.text = self.infoArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

-(void)textFieldWithText:(UITextField *)textfield
{
    switch (textfield.tag) {
        case 0:
            self.userName = textfield.text;
            break;
        case 1:
            self.userTel = textfield.text;
            break;
        case 2:
            self.verificationCode = textfield.text;
            break;
        case 3:
            self.adressStr = textfield.text;
            break;
        case 4:
            self.remarkStr = textfield.text;
            break;
        default:
            break;
    }
    NSLog(@"%@,%@,%@,%@,%@",self.userName,self.userTel,self.verificationCode,self.adressStr,self.remarkStr);
}


-(void)securityCodeButtonMethod:(UIButton *)button
{
    NSLog(@"");
    //先判断手机号是否为空
    if ([self.userTel isEqualToString:@""]) {
        [MBProgressHUDUtil showMessage:@"请填写手机号" toView:self.view];
        return;
    }
    if (![self isMobileNumber:self.userTel]) {
        [MBProgressHUDUtil showMessage:@"手机号格式错误！" toView:self.view];
        return;
    }
    [self openCountdown:button];
    [AppointmentInstallRequestTool sharedInstallTool].urlString = @"ReserveSever/Watersubscribe/sendVerify";
    NSDictionary *parmDic = @{@"tel":self.userTel};
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

#pragma mark - 预约安装
- (IBAction)payButtonMethod:(id)sender {
    
    BOOL isUserName = [self.userName isEqualToString:@""] || self.userName==nil;
    BOOL isUserTel = [self.userTel isEqualToString:@""] || self.userTel==nil;
    BOOL isVerificationCode = [self.verificationCode isEqualToString:@""]|| self.verificationCode==nil;
    BOOL isAdress = [self.adressStr isEqualToString:@""]|| self.adressStr==nil;
    BOOL isremarkStr = [self.remarkStr isEqualToString:@""]|| self.remarkStr==nil;
    
    if (isUserName || isUserTel || isVerificationCode || isAdress || isremarkStr) {
        
        [MBProgressHUDUtil showMessage:@"请填写完成信息后，再预约!" toView:self.view];
        return;
    }
    
    
    [OrderInquiryRequestTool sharedOrderInquiryTool].urlString = @"ReserveSever/Watersubscribe/add";
    
    NSDictionary *parmDic = @{@"tel":self.userTel,
                              @"userName":self.userName,
                              @"site":self.adressStr,
                              @"remark":self.remarkStr,
                              @"verifyNumPro":self.verificationCode,
                              @"money":@599
                              };
    [OrderInquiryRequestTool sharedOrderInquiryTool].parameterDict = parmDic;
    [[OrderInquiryRequestTool sharedOrderInquiryTool] sendOrderInquiryRequestWithResponse:^(NSDictionary *dict) {
        NSLog(@"打印信息：%@",dict);
        if ([[dict objectForKey:@"code"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUDUtil showLoadingWithMessage:@"预约成功" toView:self.view whileExcusingBlock:^(MBProgressHUD *hud) {
                    [hud hide:YES afterDelay:1.f complete:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        
                    }];
                }];
            });
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUDUtil showMessage:[dict objectForKey:@"result"] toView:self.view];

            });
        }
    }];
}

- (IBAction)TickButtonMethod:(id)sender {
    if (!self.isTick) {
        [self.TickButton setImage:[UIImage imageNamed:@"Tick"] forState:UIControlStateNormal];
        self.payButton.enabled = YES;
        self.payButton.layer.borderColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1].CGColor;
        [self.payButton setBackgroundColor:
         [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1]];
        self.isTick = YES;
    }else
    {
        [self.TickButton setImage:[UIImage imageNamed:@"NOTick"] forState:UIControlStateNormal];
        self.payButton.enabled = NO;
        self.payButton.layer.borderColor = [UIColor colorWithRed:192.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:1].CGColor;
        [self.payButton setBackgroundColor:
         [UIColor colorWithRed:192.0 / 255.0 green:192.0 / 255.0 blue:192.0 / 255.0 alpha:1]];
        self.isTick = NO;
    }
}







@end
