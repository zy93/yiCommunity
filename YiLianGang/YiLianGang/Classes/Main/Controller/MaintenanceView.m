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
#import "WN_YL_RequestTool.h"
#import "MLSelectPhoto.h"
#import "YYUtil.h"


@interface MaintenanceView () <UITextViewDelegate, UIPickerViewDelegate, WN_YL_RequestToolDelegate,ZLPhotoPickerViewControllerDelegate>
{
    UIButton *mIndividualBnt;
    UIButton *mCommonBnt;
    UITextView *mTextView;
    
    UIView *mUserInfoView;
    
    UIButton *mSelectImageBtn;
    
    UIButton *lab2;
    UIDatePicker *mDatePicker;
    UITextField *mText;
    BOOL isFrist;
    
    NSString *userAddr;
    NSDate *mDate;
    NSMutableDictionary *fileDic;
    WN_YL_RequestTool*request;
    MLSelectPhotoPickerViewController *pickerVc;
}

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
        isFrist = YES;
    }
    return self;
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
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mUserInfoView.frame), 20)];
    lab.text = [NSString stringWithFormat:@"地址：%@",userAddr];
    [mUserInfoView addSubview:lab];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame)+5, CGRectGetWidth(self.frame), 1)];
    [line2 setBackgroundColor:HEXCOLOR(0xefefef)];
    [mUserInfoView addSubview:line2];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame)+5, CGRectGetWidth(line2.frame), 20)];
    lab1.text = [NSString stringWithFormat:@"电话：%@",[LoginTool sharedLoginTool].userTel];
    [mUserInfoView addSubview:lab1];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame)+5, CGRectGetWidth(self.frame), 1)];
    [line3 setBackgroundColor:HEXCOLOR(0xefefef)];
    [mUserInfoView addSubview:line3];
    
    
    lab2 = [UIButton buttonWithType:UIButtonTypeCustom];
    lab2.frame = CGRectMake(0, CGRectGetMaxY(line3.frame), CGRectGetWidth(line1.frame), 30);
    [lab2 setTitle:@"预约时间：-/-/-" forState:UIControlStateNormal];
    [lab2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [lab2.titleLabel setTextAlignment:NSTextAlignmentLeft];
    lab2.titleLabel.textAlignment = NSTextAlignmentLeft;
    [lab2 addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    lab2.titleLabel.font = [UIFont systemFontOfSize:16];
    [lab2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mUserInfoView addSubview:lab2];
    
    
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
        pickerVc.maxCount = 9;
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


-(void)commitContent:(UIButton *)sender
{
    //
    NSString *alias= [NSString stringWithFormat:@"%@B",[LoginTool sharedLoginTool].userTel];
    NSDictionary *dic = @{@"Info":mTextView.text,
                          @"alias":alias,
                          @"phone":[LoginTool sharedLoginTool].userTel,
                          @"address":userAddr,
                          @"title":@"维修申请",
                          @"appointmentTime":[NSString stringWithFormat:@"%.0f",[self dateToTimestamp:mDate]]};
    NSString *url = [NSString stringWithFormat:@"%@KP/info/info_intoInfo",HTTP_Service];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:hud];
    [hud setLabelText: @"提交中"];
    [hud show:YES];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YYUtil PostImagesToServer:url dicPostParams:dic dicImages:fileDic block:^(NSInteger httpCode, NSData *data) {
//            NSLog(@"----------------****%ld",(long)httpCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (httpCode == 200) {
                    [hud setLabelText:@"提交成功"];
                }
                else {
                    [hud setLabelText:@"提交错误"];
                }
                [hud hide:YES afterDelay:1.0f];
            });
        }];
    });
    
}



bool isA = NO;
-(void)selectTime:(UIButton *)sender
{
    if (isA) {
        isA = NO;
        [mText resignFirstResponder];
        mText.inputView = mDatePicker;
    }
    else
    {
        isA = YES;
        mText.inputView = mDatePicker;
        [mText becomeFirstResponder];
    }
}

-(void)dateChanged:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    mDate = date;
//    date = [YYUtil getNowDateFromatAnDate:date];
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSString* dateString = [formatter stringFromDate:date];
    [lab2 setTitle:[NSString stringWithFormat:@"预约时间：%@",dateString] forState:UIControlStateNormal];

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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
