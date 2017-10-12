//
//  HistoryContentView.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/31.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "HistoryContentView.h"
#import "MaintenanceContentView.h"
#import "YYUtil.h"
#import "MLSelectPhoto.h"
#import "WN_YL_RequestTool.h"
#import "MBProgressHUD.h"

@interface HistoryContentView () <UITextViewDelegate,ZLPhotoPickerViewControllerDelegate>

@end


@implementation HistoryContentView
{
    UILabel *mContentLab;
    UILabel *mAddr;
    UILabel *mTel;
    UILabel *mTime;
    UIButton *mInfo1ImageBtn; //第一张图
    UIButton *mInfo2ImageBtn; //第二张图
    UIButton *mInfo3ImageBtn; //第三张图
    
    
    
    //
    UIView *mEvaluateView;
    UITextView *mTextView;
    
    UIButton *mSelectImageBtn;
    UIButton *mCommitBnt;
    
    NSDictionary *mContentDic;
    BOOL isAmplify;
    BOOL isFrist;
    CGRect zroeRect;
    CGRect viewRect;
    
    UIView *vvv;
    NSInteger evealu;
    
    NSMutableDictionary *fileDic;
    MLSelectPhotoPickerViewController *pickerVc;
    
}
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
        [self createSubview];
        isFrist = YES;
        
        //注册键盘出现的通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWasShow:)
         
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        //注册键盘消失的通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillBeHidden:)
         
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)createSubview
{
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 64)];
    topBar.backgroundColor  = HEXCOLOR(0x47d2ae);
    [self addSubview:topBar];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.frame), 44)];
    titleLab.text = @"维修内容";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:17.f];
    titleLab.textColor = [UIColor whiteColor];
    [topBar addSubview:titleLab];
    
    mContentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, CGRectGetWidth(self.frame)-40, 120)];
    mContentLab.text = @"请在此填写报修报修内容";
    mContentLab.numberOfLines = 0;
    mContentLab.textAlignment = NSTextAlignmentJustified;
    [self addSubview:mContentLab];
    
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mContentLab.frame)+20, CGRectGetWidth(self.frame), 1)];
    [line1 setBackgroundColor:HEXCOLOR(0xefefef)];
    [self addSubview:line1];
    
    
    UIView *mUserInfoView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line1.frame)+5, CGRectGetWidth(self.frame), 90)];
    [self addSubview:mUserInfoView];
    
    mAddr = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mUserInfoView.frame), 20)];
    mAddr.text = @"地址：xxx";
    [mUserInfoView addSubview:mAddr];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mAddr.frame)+5, CGRectGetWidth(self.frame), 1)];
    [line2 setBackgroundColor:HEXCOLOR(0xefefef)];
    [mUserInfoView addSubview:line2];
    
    
    mTel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame)+5, CGRectGetWidth(line2.frame), 20)];
    mTel.text =@"电话：xxx";
    [mUserInfoView addSubview:mTel];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mTel.frame)+5, CGRectGetWidth(self.frame), 1)];
    [line3 setBackgroundColor:HEXCOLOR(0xefefef)];
    [mUserInfoView addSubview:line3];
    
    
    mTime = [[UILabel alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(line3.frame), CGRectGetWidth(line1.frame), 30)];
    mTime.text =@"预约时间：-/-/-";
    [mUserInfoView addSubview:mTime];
    
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mUserInfoView.frame), CGRectGetWidth(self.frame), 1)];
    [line4 setBackgroundColor:HEXCOLOR(0xefefef)];
    [self addSubview:line4];
    
    mInfo1ImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mInfo1ImageBtn setFrame:CGRectMake(20, CGRectGetMaxY(line4.frame)+10, 40, 40)];
    //    [mInfo1ImageBtn setBackgroundImage:[UIImage imageNamed:@"丁丁停车"] forState:UIControlStateNormal];
    mInfo1ImageBtn.layer.borderWidth = 0.5f;
    [mInfo1ImageBtn addTarget:self action:@selector(seeImage:) forControlEvents:UIControlEventTouchUpInside];
    mInfo1ImageBtn.tag = 1001;
    mInfo1ImageBtn.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
    [self addSubview:mInfo1ImageBtn];
    
    
    mInfo2ImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mInfo2ImageBtn setFrame:CGRectMake(CGRectGetMaxX(mInfo1ImageBtn.frame)+10, CGRectGetMinY(mInfo1ImageBtn.frame), 40, 40)];
    //    [mInfo2ImageBtn setBackgroundImage:[UIImage imageNamed:@"报事报修"] forState:UIControlStateNormal];
    mInfo2ImageBtn.layer.borderWidth = 0.5f;
    [mInfo2ImageBtn addTarget:self action:@selector(seeImage:) forControlEvents:UIControlEventTouchUpInside];
    mInfo2ImageBtn.tag = 1002;
    mInfo2ImageBtn.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
    [self addSubview:mInfo2ImageBtn];
    
    mInfo3ImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mInfo3ImageBtn setFrame:CGRectMake(CGRectGetMaxX(mInfo2ImageBtn.frame)+10, CGRectGetMinY(mInfo1ImageBtn.frame), 40, 40)];
    //    [mInfo3ImageBtn setBackgroundImage:[UIImage imageNamed:@"报事报修"] forState:UIControlStateNormal];
    mInfo3ImageBtn.layer.borderWidth = 0.5f;
    [mInfo3ImageBtn addTarget:self action:@selector(seeImage:) forControlEvents:UIControlEventTouchUpInside];
    mInfo3ImageBtn.tag = 1003;
    mInfo3ImageBtn.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
    [self addSubview:mInfo3ImageBtn];
    
    [self createEvaluateView];
    
    
}

-(void)createEvaluateView
{
    
    mEvaluateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mInfo3ImageBtn.frame)+10, CGRectGetWidth(self.frame), 300)];
//    mEvaluateView.backgroundColor = [UIColor yellowColor];
    [self addSubview:mEvaluateView];
    
    UILabel *titl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (16*5), 20)];
    titl.text = @"编写评价:";
    titl.font = [UIFont systemFontOfSize:16.f];
    [mEvaluateView addSubview:titl];
    [self createStartWithFrame:titl.frame];
    
    
    mTextView = [[UITextView alloc] initWithFrame:CGRectMake(20,  CGRectGetMaxY(titl.frame)+10, CGRectGetWidth(self.frame)-40, 80)];
    mTextView.delegate = self;
    mTextView.layer.borderColor = [UIColor grayColor].CGColor;
    mTextView.layer.borderWidth = 0.5f;
    mTextView.text = @"请在此填写报评价内容";
    [mEvaluateView addSubview:mTextView];
    
    mSelectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mSelectImageBtn setFrame:CGRectMake(20, CGRectGetMaxY(mTextView.frame)+10, 40, 40)];
    [mSelectImageBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    mSelectImageBtn.layer.borderWidth = 0.5f;
    [mSelectImageBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    mSelectImageBtn.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
    [mEvaluateView addSubview:mSelectImageBtn];
    
    mCommitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [mCommitBnt setFrame:CGRectMake(20, CGRectGetMaxY(mSelectImageBtn.frame)+20, CGRectGetWidth(self.frame)-40, 50)];
    [mCommitBnt setTitle:@"提交" forState:UIControlStateNormal];
    [mCommitBnt setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [mCommitBnt addTarget:self action:@selector(commitEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    mCommitBnt.tag = 102;
    mCommitBnt.layer.cornerRadius = 5.f;
    mCommitBnt.layer.borderColor = HEXCOLOR(0x47d2ae).CGColor;
    mCommitBnt.layer.borderWidth = 1;
    mCommitBnt.backgroundColor = HEXCOLOR(0x47d2ae);
    [mEvaluateView addSubview:mCommitBnt];

    
}

-(void)createStartWithFrame:(CGRect )frame
{
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(CGRectGetMaxX(frame)+(i*40), 5, 30, 30)];
        [btn setImage:[UIImage imageNamed:@"start_y"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"start_g"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectStart:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200+i;
        [mEvaluateView addSubview:btn];
    }
}

-(void)selectStart:(UIButton *)sender
{
    int tag = (int)sender.tag;
    evealu = tag-200;
    for (int i=0; i<5; i++) {
        UIButton *btn = [self viewWithTag:200+i];
        if (btn.tag <= tag) {
            btn.selected = YES;
        }
        else {
            btn.selected = NO;
        }
    }
}

-(void)seeImage:(UIButton *)sender
{
    
    if (isAmplify == NO) {
        zroeRect = sender.frame;
        isAmplify = !isAmplify;
        //放大
        UIImage *im = [sender backgroundImageForState:UIControlStateNormal];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window.windowLevel == 1996.00) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for (window in windows) {
                if (window.windowLevel == UIWindowLevelNormal) {
                    break;
                }
            }
        }
        sender.center = window.center;
        vvv = sender;
        [window  addSubview:sender];
        
        
        
        [UIView animateWithDuration:0.5f animations:^{
            sender.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            //            [sender setImage:im forState:UIControlStateNormal];
            //            [sender setBackgroundImage:nil forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else {
        //缩小
        isAmplify = !isAmplify;
        UIImage *im = [sender imageForState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            sender.frame = zroeRect;
            //            [sender setImage:nil forState:UIControlStateNormal];
            //            [sender setBackgroundImage:im forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            [vvv removeFromSuperview];
            [self addSubview:vvv];
        }];
    }
    
}


-(void)setData:(NSDictionary *)dic
{
    mContentDic = dic;
    [mContentLab setText:dic[@"info"]];
    [mAddr setText:[NSString stringWithFormat:@"地址：%@",dic[@"address"]]];
    [mTel setText:[NSString stringWithFormat:@"电话：%@",dic[@"phone"]]];
    [mTime setText:[NSString stringWithFormat:@"预约时间：%@",[YYUtil timeWithTimeInterval:[dic[@"infoTime"] floatValue]*1000]]];
    mEvaluateView.hidden = YES;
    //待维修状态
    if ([dic[@"state"] isEqualToString:StateOrderPlacement]) {
        mInfo2ImageBtn.hidden = YES;
        mInfo3ImageBtn.hidden = YES;
        
        if (strIsEmpty(dic[@"pictureOne"])) {
            mInfo1ImageBtn.hidden = YES;
        }
        else {
            [self loadImageWithUrl:dic[@"pictureOne"] button:mInfo1ImageBtn];
        }
        
    }
    //接单状态
    else if ([dic[@"state"] isEqualToString:StateOrderReceiving])  {
        
        if (strIsEmpty(dic[@"pictureOne"])) {
            mInfo1ImageBtn.hidden = YES;
            mInfo2ImageBtn.hidden = YES;
            mInfo3ImageBtn.hidden = YES;
            [mSelectImageBtn setFrame:mInfo1ImageBtn.frame];
        }
        else {
            mInfo2ImageBtn.hidden = YES;
            mInfo3ImageBtn.hidden = YES;
            [mSelectImageBtn setFrame:mInfo2ImageBtn.frame];
            [self loadImageWithUrl:dic[@"pictureOne"] button:mInfo1ImageBtn];
            
        }
    }
    //维修中状态
    else if ([dic[@"state"] isEqualToString:StateOrderMaintenance]) {
        mInfo3ImageBtn.hidden = YES;
        if (strIsEmpty(dic[@"pictureOne"])) {
            mInfo1ImageBtn.hidden = YES;
            [mInfo2ImageBtn setFrame:mInfo1ImageBtn.frame];
        }
        else {
        }
        [self loadImageWithUrl:dic[@"pictureOne"] button:mInfo1ImageBtn];
        [self loadImageWithUrl:dic[@"pictureTwo"] button:mInfo2ImageBtn];
    }
    //维修完成状态
    else if ([dic[@"state"] isEqualToString:StateOrderComplete]) {
        mEvaluateView.hidden = NO;
        if (strIsEmpty(dic[@"pictureOne"])) {
        }
        else {
//            [mSelectImageBtn setTag:1004];
//            [mSelectImageBtn setImage:nil forState:UIControlStateNormal];
        }
        
        [self loadImageWithUrl:dic[@"pictureOne"] button:mInfo1ImageBtn];
        [self loadImageWithUrl:dic[@"pictureTwo"] button:mInfo2ImageBtn];
        [self loadImageWithUrl:dic[@"pictureThree"] button:mInfo3ImageBtn];
    }
    //结束状态
    else {
        mEvaluateView.hidden = NO;

        if (strIsEmpty(dic[@"pictureOne"])) {
        }
        else {
            [mSelectImageBtn setTag:1004];
            [mSelectImageBtn setImage:nil forState:UIControlStateNormal];
        }
        
        [self loadImageWithUrl:dic[@"pictureOne"] button:mInfo1ImageBtn];
        [self loadImageWithUrl:dic[@"pictureTwo"] button:mInfo2ImageBtn];
        [self loadImageWithUrl:dic[@"pictureThree"] button:mInfo3ImageBtn];
        [self loadImageWithUrl:dic[@"pictureFour"] button:mSelectImageBtn];
    }
    
}

-(void)selectImage:(UIButton *)sender
{
    if (sender.tag == 1234) {
        [self seeImage:sender];
        return;
    }
    
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

-(void)commitEvaluate:(UIButton *)sender
{
    NSDictionary *dic = @{@"infoId":mContentDic[@"infoId"],
                          @"title":@"订单评价",
                          @"evaluation":mTextView.text,
                          @"star":[NSString stringWithFormat:@"%d",(int)evealu+1],
                          };
    
    NSString *url = [NSString stringWithFormat:@"%@WY/info/info_evaluation",HTTP_Service];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    [hud setLabelText:@"提交中"];
    [self addSubview:hud];
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [YYUtil PostImagesToServer:url dicPostParams:dic dicImages:fileDic block:^(NSInteger httpCode, NSData *data) {
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

-(void)loadImageWithUrl:(NSString *)ur button:(UIButton *)button
{
    __weak UIButton *weak = button;
    NSString *u = [NSString stringWithFormat:@"%@%@",HTTP_Service,ur];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:u];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak setBackgroundImage:image forState:UIControlStateNormal];
            
        });
    });
}


#pragma mark - textview delegate
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

#pragma mark pciker delegate
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


#pragma mark - notification
-(void)keyboardWasShow:(NSNotification *)notf
{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, -150, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {

    }];
}

-(void)keyboardWillBeHidden:(NSNotification *)notf
{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        
    }];
}

@end
