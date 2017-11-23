//
//  MaintenanceView.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/16.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MaintenanceView.h"
#import "MaintenanceViewController.h"
#import "YYUtil.h"
#import "LoginTool.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+KR.h"
#import "MBProgressHUDUtil.h"
#import "WN_YL_RequestTool.h"
#import "MLSelectPhoto.h"
#import "YYUtil.h"
#import "WOTDatePickerView.h"
#import "JudgmentTime.h"
#import "MBProgressHUD+Extension.h"



@interface MaintenanceView () <UITextViewDelegate, UIPickerViewDelegate,ZLPhotoPickerViewControllerDelegate,UITextFieldDelegate>
{
    UIButton *mIndividualBnt;
    UIButton *mCommonBnt;
    UITextView *mTextView;
    
    UIView *mUserInfoView;
    
    UIButton *mSelectImageBtn;
    
    
    UIDatePicker *mDatePicker;
    UITextField *mText;
    BOOL isFrist;
    
    NSString *userAddr;
    NSDate *mDate;
    NSMutableDictionary *fileDic;
    WN_YL_RequestTool*request;
    MLSelectPhotoPickerViewController *pickerVc;
    NSString *time;
}

@property (nonatomic,strong)UITextField *adressTextField;
@property (nonatomic,strong)UITextField *telTextField;
@property (nonatomic, strong) WOTDatePickerView *datepickerview;
@property (nonatomic, strong) JudgmentTime *judgmentTime;
@property (nonatomic, assign) BOOL isValidTime;
@property (nonatomic, assign) BOOL isValidTel;
@property (nonatomic, strong) UIButton *lab2;

@end

@implementation MaintenanceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        userAddr = @"海淀区四季青路7号院优客工场223室";
        [self createSubviewsWithFrame:frame];
        [self setupView];
        isFrist = YES;
    }
    return self;
}

-(void)setupView
{
    __weak typeof(self) weakSelf = self;
    weakSelf.judgmentTime = [[JudgmentTime alloc] init];
    _datepickerview = [[NSBundle mainBundle]loadNibNamed:@"WOTDatePickerView" owner:nil options:nil].lastObject;
    [_datepickerview setFrame:CGRectMake(0, self.frame.size.height - 300, self.frame.size.width, 300)];
    _datepickerview.cancelBlokc = ^(){
        weakSelf.datepickerview.hidden = YES;
    };
    _datepickerview.okBlock = ^(NSInteger year,NSInteger month,NSInteger day,NSInteger hour,NSInteger min){
        weakSelf.datepickerview.hidden = YES;
        NSLog(@"%ld年%ld月%ld日",year,month,day);
        weakSelf.isValidTime = [weakSelf.judgmentTime judgementTimeWithYear:year month:month day:day];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.isValidTime) {
                time = [NSString stringWithFormat:@"%02d/%02d/%02d%@%02d%@%02d%@%@ ",(int)year, (int)month, (int)day,@" ",(int)hour,@":",(int)min,@":",@"00"];
                //self.timeText.text = time;
                 [weakSelf.lab2 setTitle:[NSString stringWithFormat:@"预约时间：%@",time] forState:UIControlStateNormal];
                //_datepickerview.hidden  = YES;
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
    [self addSubview:_datepickerview];
    _datepickerview.hidden = YES;
    
}

-(void)createSubviewsWithFrame:(CGRect)frame
{
    mText =[[UITextField alloc] initWithFrame:CGRectZero];
    [self addSubview:mText];
    mIndividualBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [mIndividualBnt setFrame:CGRectMake(20, 20, CGRectGetWidth(frame)/2 - 25, 36)];
    [mIndividualBnt setTitle:@"个人报修" forState:UIControlStateNormal];
    //[mIndividualBnt setTitleColor:HEXCOLOR(0x47d2ae) forState:UIControlStateNormal];
    [mIndividualBnt setTitleColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1] forState:UIControlStateNormal];
    mIndividualBnt.tag = 101;
    mIndividualBnt.layer.cornerRadius = 5.f;
    //mIndividualBnt.layer.borderColor = HEXCOLOR(0x47d2ae).CGColor;
     mIndividualBnt.layer.borderColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1].CGColor;
    mIndividualBnt.layer.borderWidth = 1.f;
    mIndividualBnt.selected = YES;
    //mIndividualBnt.backgroundColor = HEXCOLOR(0x47d2ae);
     mIndividualBnt.backgroundColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1];
    [mIndividualBnt setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [mIndividualBnt addTarget:self action:@selector(selectMaintenance:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mIndividualBnt];
    
    
    mCommonBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [mCommonBnt setFrame:CGRectMake(CGRectGetMaxX(mIndividualBnt.frame)+10, 20, CGRectGetWidth(mIndividualBnt.frame), 36)];
    [mCommonBnt setTitle:@"公共报修" forState:UIControlStateNormal];
    //[mCommonBnt setTitleColor:HEXCOLOR(0x47d2ae) forState:UIControlStateNormal];
    [mCommonBnt setTitleColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1] forState:UIControlStateNormal];
    mCommonBnt.tag = 102;
    mCommonBnt.layer.cornerRadius = 5.f;
    //mCommonBnt.layer.borderColor = HEXCOLOR(0x47d2ae).CGColor;
    mCommonBnt.layer.borderColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1].CGColor;
    mCommonBnt.layer.borderWidth = 1;
    [mCommonBnt setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateSelected];
    [mCommonBnt addTarget:self action:@selector(selectMaintenance:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mCommonBnt];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mCommonBnt.frame)+20, CGRectGetWidth(self.frame), 1)];
    [line setBackgroundColor:HEXCOLOR(0xefefef)];
    [self addSubview:line];
    
    
    mTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame)+10, CGRectGetWidth(self.frame)-40, 120)];
    mTextView.delegate = self;
    mTextView.text = @"请在此填写报修报修内容";
    [self addSubview:mTextView];
    
    mSelectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mSelectImageBtn setFrame:CGRectMake(20, CGRectGetMaxY(mTextView.frame)+10, 40, 40)];
    [mSelectImageBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    mSelectImageBtn.layer.borderWidth = 0.5f;
    [mSelectImageBtn addTarget:self action:@selector(selectMedia:) forControlEvents:UIControlEventTouchUpInside];
    mSelectImageBtn.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
    [self addSubview:mSelectImageBtn];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mSelectImageBtn.frame)+20, CGRectGetWidth(self.frame), 1)];
    [line1 setBackgroundColor:HEXCOLOR(0xefefef)];
    [self addSubview:line1];
    
    
    mUserInfoView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line1.frame)+5, CGRectGetWidth(self.frame), 90)];
    [self addSubview:mUserInfoView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    lab.text = [NSString stringWithFormat:@"地址:"];
    [mUserInfoView addSubview:lab];
    
    self.adressTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, mUserInfoView.frame.size.width-30, 20)];
    _adressTextField.delegate = self;
    [mUserInfoView addSubview:_adressTextField];
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame)+5, CGRectGetWidth(self.frame), 1)];
    [line2 setBackgroundColor:HEXCOLOR(0xefefef)];
    [mUserInfoView addSubview:line2];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame)+5, 40, 20)];
    lab1.text = [NSString stringWithFormat:@"电话:"];
    [mUserInfoView addSubview:lab1];
    
    self.telTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(line2.frame)+5, mUserInfoView.frame.size.width-30, 20)];
    _telTextField.delegate = self;
    [mUserInfoView addSubview:_telTextField];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame)+5, CGRectGetWidth(self.frame), 1)];
    [line3 setBackgroundColor:HEXCOLOR(0xefefef)];
    [mUserInfoView addSubview:line3];
    
    
    _lab2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _lab2.frame = CGRectMake(0, CGRectGetMaxY(line3.frame), CGRectGetWidth(line1.frame), 30);
    [_lab2 setTitle:@"预约时间：" forState:UIControlStateNormal];
    [_lab2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [lab2.titleLabel setTextAlignment:NSTextAlignmentLeft];
    _lab2.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_lab2 addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    _lab2.titleLabel.font = [UIFont systemFontOfSize:16];
    [_lab2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mUserInfoView addSubview:_lab2];
    
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mUserInfoView.frame), CGRectGetWidth(self.frame), 1)];
    [line4 setBackgroundColor:HEXCOLOR(0xefefef)];
    [self addSubview:line4];
    
    
    mDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    mDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [mDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UIButton *commBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commBtn setFrame:CGRectMake(20, CGRectGetMaxY(line4.frame)+20, CGRectGetWidth(self.frame)-40, 50)];
    [commBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [commBtn addTarget:self action:@selector(commitContent:) forControlEvents:UIControlEventTouchUpInside];
    [commBtn setTitleColor:HEXCOLOR(0x22dd44) forState:UIControlStateHighlighted];
    commBtn.tag = 102;
    commBtn.layer.cornerRadius = 5.f;
    //commBtn.layer.borderColor = HEXCOLOR(0x47d2ae).CGColor;
      commBtn.layer.borderColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1].CGColor;
    commBtn.layer.borderWidth = 1;
    //commBtn.backgroundColor = HEXCOLOR(0x47d2ae);
    commBtn.backgroundColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1];;
    [self addSubview:commBtn];
    
}

-(void)selectMaintenance:(UIButton *)sender
{
    if (sender.tag == 101) {
        //[mIndividualBnt setBackgroundColor:HEXCOLOR(0x47d2ae)];
        [mIndividualBnt setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1]];
        [mCommonBnt setBackgroundColor:HEXCOLOR(0xffffff)];
        mIndividualBnt.selected = YES;
        mCommonBnt.selected = NO;

    }
    else {
        [mIndividualBnt setBackgroundColor:HEXCOLOR(0xffffff)];//#0c7ee2
        //[mCommonBnt setBackgroundColor:HEXCOLOR(0x47d2ae)];
        [mCommonBnt setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1]];
        mIndividualBnt.selected = NO;
        mCommonBnt.selected = YES;
    }
}

-(void)selectMedia:(UIButton *)sender
{
    
    if (pickerVc == nil) {
        // Use
        pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        pickerVc.status = PickerViewShowStatusCameraRoll;
        // 选择图片的最小数，默认是9张图片
        pickerVc.maxCount = 1;
        // 设置代理回调
        pickerVc.delegate = self;
        // 展示控制器
        [pickerVc showPickerVc:[self GetSubordinateControllerForSelf]];
//        showView = [[ShowImageView alloc] initWithFrame:CGRectMake(0, 30, VIEW_WIDTH, 50)];
//        showView.delegate = self;
//        [_mFileBG addSubview:showView];
    }
    else {
        [pickerVc showPickerVc:[self GetSubordinateControllerForSelf]];
    }
}

#pragma mark - 提交
-(void)commitContent:(UIButton *)sender
{
    NSLog(@"1%@",mTextView.text);
    NSLog(@"2%@",self.telTextField.text);
    NSLog(@"3%@",[self cutOutTimeString:_lab2.titleLabel.text]);
    NSLog(@"4%@",self.adressTextField.text);
    BOOL isInfo = [mTextView.text isEqualToString:@""] || mTextView.text==NULL ;
    BOOL isTel = [self.telTextField.text isEqualToString:@""] || self.telTextField.text==NULL;
    BOOL isAppointmentTime = [[self cutOutTimeString:_lab2.titleLabel.text] isEqualToString:@""] || [self cutOutTimeString:_lab2.titleLabel.text]==NULL;
    BOOL isAddress = [self.adressTextField.text isEqualToString:@""];
    
    BOOL isTelCorrect = [self isMobileNumber:self.telTextField.text];
    
    if (isInfo || isTel || isAppointmentTime || isAddress) {
        [MBProgressHUDUtil showMessage:@"请填写完整信息！" toView:self];
        return;
    }else if (!isTelCorrect)
    {
        [MBProgressHUDUtil showMessage:@"手机号格式不正确！" toView:self];
        return;
    }else
    {
        NSString *alias= [NSString stringWithFormat:@"%@B",[LoginTool sharedLoginTool].userTel];
        NSDictionary *dic = @{@"Info":mTextView.text,
                              @"alias":alias,
                              @"phone":self.telTextField.text,
                              @"address":self.adressTextField.text,
                              @"title":@"维修申请",
                              @"appointmentTime":[self cutOutTimeString:_lab2.titleLabel.text]};
        NSString *url = [NSString stringWithFormat:@"%@KP/info/info_intoInfo",HTTP_Service];
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
        [hud setLabelText: @"提交中"];
        [hud show:YES];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [YYUtil PostImagesToServer:url dicPostParams:dic dicImages:fileDic block:^(NSInteger httpCode, NSData *data) {
                NSLog(@"----------------****%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (httpCode == 200) {
                        [hud hide:YES];
                       // [hud setLabelText:@"提交成功"];
                        [MBProgressHUDUtil showLoadingWithMessage:@"提交成功" toView:self whileExcusingBlock:^(MBProgressHUD *hud) {
                            [hud hide:YES afterDelay:1.f complete:^{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSNotification *notification = [NSNotification notificationWithName:@"skipNotification" object:nil userInfo:nil];
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                });
                                
                            }];
                        }];
                    }
                    else {
                        [hud setLabelText:@"提交错误"];
                    }
                    [hud hide:YES afterDelay:1.0f];
                });
            }];
        });
    }
    
    
    
}


bool isA = NO;
-(void)selectTime:(UIButton *)sender
{
    _datepickerview.hidden = NO;
//    if (isA) {
//        isA = NO;
//        [mText resignFirstResponder];
//        mText.inputView = mDatePicker;
//    }
//    else
//    {
//        isA = YES;
//        mText.inputView = mDatePicker;
//        [mText becomeFirstResponder];
//    }
}

-(void)dateChanged:(id)sender
{
    _datepickerview.hidden = NO;
//    UIDatePicker* control = (UIDatePicker*)sender;
//    NSDate* date = control.date;
//    mDate = date;
////    date = [YYUtil getNowDateFromatAnDate:date];
//    // 格式化时间
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//
//    // 毫秒值转化为秒
//    NSString* dateString = [formatter stringFromDate:date];
//    [_lab2 setTitle:[NSString stringWithFormat:@"预约时间：%@",dateString] forState:UIControlStateNormal];

}

//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    _datepickerview.hidden = YES;
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _datepickerview.hidden = YES;
}

-(NSTimeInterval)dateToTimestamp:(NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSince1970];
    return interval;
}


#pragma mark - ZLPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets
{
    if (fileDic == nil) {
        fileDic = [[NSMutableDictionary alloc] initWithCapacity:assets.count];
    }
    [mSelectImageBtn setImage:((MLSelectPhotoAssets *)assets.firstObject).originImage forState:UIControlStateNormal];
    int i = 0;
    for (MLSelectPhotoAssets *asset in assets) {
        //
        NSLog(@"------video:%@",asset);
        if (asset.isVideoType) {
            NSLog(@"------video url:%@",asset.assetURL);
            [fileDic setObject:asset.assetURL forKey:[NSString stringWithFormat:@"video_%d", i]];
        }
        else {
            [fileDic setObject:asset.originImage forKey:[NSString stringWithFormat:@"image_%d", i]];
        }
        i++;
    }
}

#pragma mark - TextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (isFrist) {
        isFrist = NO;
        textView.text = @"";
    }
}

-(NSString *)cutOutTimeString:(NSString *)timeString
{

    NSString *str2 = [timeString substringFromIndex:5];
    NSLog(@"截取的值为：%@",str2);
    return str2;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.superview endEditing:YES];
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
