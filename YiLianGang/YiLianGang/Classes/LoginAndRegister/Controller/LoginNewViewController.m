//
//  LoginNewViewController.m

//
//  Created by 编程 on 2017/11/24.
//  Copyright © 2017年 YiLiANGANG. All rights reserved.
//

#import "LoginNewViewController.h"
#import "Masonry.h"

@interface LoginNewViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *userTelView;
@property (nonatomic, strong) UIImageView *userTelImageView;
@property (nonatomic, strong) UITextField *userTelField;
@property (nonatomic, strong) UIButton *verificationCodeButton;

@property (nonatomic, strong) UIView *verificationCodeView;
@property (nonatomic, strong) UIImageView *verificationCodeImageView;
@property (nonatomic, strong) UITextField *verificationCodeField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LoginNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.f green:242.0f/255.f blue:242.0f/255.f alpha:1];
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_ylg"]];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.logoImageView];
    
    self.userTelView = [UIView new];
    self.userTelView.backgroundColor = [UIColor whiteColor];
    self.userTelView.layer.cornerRadius = 5.f;
    [self.view addSubview:self.userTelView];
    
    
    self.userTelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"usericon"]];
    self.userTelImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.userTelView addSubview:self.userTelImageView];
    
    self.userTelField = [[UITextField alloc] init];
    self.userTelField.placeholder = @"请输入手机号";
    [self.userTelView addSubview:self.userTelField];
    
    self.verificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verificationCodeButton addTarget:self action:@selector(getVerificationCodeMethod:) forControlEvents:UIControlEventTouchDown];
    [self.verificationCodeButton setTitleColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1] forState:UIControlStateNormal];
    self.verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    [self.verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.userTelView addSubview:self.verificationCodeButton];
    
    
    self.verificationCodeView = [UIView new];
    self.verificationCodeView.backgroundColor = [UIColor whiteColor];
    self.verificationCodeView.layer.cornerRadius = 5.f;
    [self.view addSubview:self.verificationCodeView];
    
    self.verificationCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwdicon"]];
    self.verificationCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.verificationCodeView addSubview:self.verificationCodeImageView];
    
    self.verificationCodeField = [[UITextField alloc] init];
    self.verificationCodeField.placeholder = @"请输入验证码";
    [self.verificationCodeView addSubview:self.verificationCodeField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton addTarget:self action:@selector(loginButtonMethod) forControlEvents:UIControlEventTouchDown];
    [self.loginButton setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1]];
    self.loginButton.layer.cornerRadius = 5.f;
    self.loginButton.layer.borderColor =[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1].CGColor;
    self.loginButton.layer.borderWidth = 1.f;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:self.loginButton];
    
}

-(void)viewDidLayoutSubviews
{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.left.equalTo(self.view.mas_left).with.offset(30);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    [self.userTelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset(50);
        make.left.equalTo(self.view.mas_left).with.offset(30);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self.userTelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userTelView);
        make.centerY.equalTo(self.userTelView);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(21);
    }];
    [self.verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userTelView);
        make.right.equalTo(self.userTelView);
        //make.left.equalTo(self.userTelField.mas_right);
        make.bottom.equalTo(self.userTelView);
        make.width.mas_equalTo(100);
    }];
    
    [self.userTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userTelView);
        make.left.equalTo(self.userTelImageView.mas_right);
        make.right.equalTo(self.verificationCodeButton.mas_left);
        make.bottom.equalTo(self.userTelView);
        
    }];
    
    [self.verificationCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userTelView.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(30);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    [self.verificationCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationCodeView);
        make.centerY.equalTo(self.verificationCodeView);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(21);
    }];
    
    [self.verificationCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationCodeView);
        make.left.equalTo(self.verificationCodeImageView.mas_right);
        make.right.equalTo(self.verificationCodeView);
        make.bottom.equalTo(self.verificationCodeView);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationCodeView.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.view).with.offset(-40);
        make.height.mas_equalTo(37);
    }];
}

#pragma mark - 获取验证码
-(void)getVerificationCodeMethod:(UIButton *)button
{
    
}

#pragma mark - 登录方法
-(void)loginButtonMethod
{
    
}
#pragma mark - 获取验证码倒计时
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

