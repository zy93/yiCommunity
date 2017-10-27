//
//  LoginTableController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "LoginTableController.h"
#import "RegisterController.h"
#import "LoginTool.h"
#import "MBProgressHUD+KR.h"
#import "NSString+JSON.h"
#import "TabBarSetTool.h"
#import "StyleTool.h"
#import "JPUSHService.h"
#import "MaintenanceListViewController.h"
#import "UIImage+ImageColorChange.h"


@interface LoginTableController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *logoCell;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *noAcountLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *managerLoginBtn;


@end

@implementation LoginTableController
//点击忘记密码按钮
- (IBAction)clickForgetPwdButton:(id)sender {
    //TODO: 忘记密码部分
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc{
    NSLog(@"login dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self doPretteyView];
    [self addTapEndEdit];
    self.tableView.scrollEnabled = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
//    CATransition *transition = [CATransition animation];
//    [transition setDuration:0.5];
//    [transition setType:@"fade"];
//    [self.view.layer addAnimation:transition forKey:nil];
}
-(void)addTapEndEdit{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToEndEdit)]];
}
-(void)tapToEndEdit{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**美化界面*/
-(void)doPretteyView{
    self.tableView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    StyleInfo *styleInfo = [[StyleTool sharedStyleTool]sessionSyle];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, height*0.8-width/1125*1599, width, width/1125*1599)];
    imageView.image = styleInfo.welcomeImage;
    self.iconImageView.image = styleInfo.logoImage;
    self.iconImageView.image = [self.iconImageView.image imageChangeColor:[UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1]];
    self.loginButton.backgroundColor = styleInfo.welcomeColor;
    [self.registerButton setTitleColor:styleInfo.welcomeColor forState:UIControlStateNormal];
    self.noAcountLabel.textColor = [UIColor colorWithRed:0.1765 green:0.1765 blue:0.1765 alpha:1.0];
    
    [self.view insertSubview:imageView atIndex:0];
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    self.navigationItem.title = @"用户登录";
    
    self.backBtn.layer.cornerRadius = 15;
    self.backBtn.layer.masksToBounds = YES;
    
    if (self.isManagerLogin == NO) {
        _backBtn.hidden = YES;
        _managerLoginBtn.hidden = NO;
    }
    else {
        _backBtn.hidden = NO;
        _managerLoginBtn.hidden = YES;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat topHeight = 180;
    if (indexPath.row == 0) {
        if (self.navigationController.isNavigationBarHidden) {
            return topHeight;
        }else{
            return topHeight-64;
        }

    }else if(indexPath.row == 1){
        return 62;
    }else if(indexPath.row == 1){
        return 79;
    }else if(indexPath.row == 1){
        return 111;
    }else{
        return 153;
    }
}
#pragma mark Click Button
//TODO: 第三方登录
- (IBAction)clickSinaLoginButton:(id)sender {
}
- (IBAction)clickQQLoginButton:(id)sender {
}
- (IBAction)clickWeixinLoginButton:(id)sender {
}

/**点击登录按钮*/
- (IBAction)clickLoginButton:(id)sender {
    [LoginTool sharedLoginTool].isManager = _isManagerLogin;
    [self.view endEditing:YES];
    if (_isManagerLogin == NO) {
        [ToastUtil showLoadingToast:@"登陆中"];
        [LoginTool sharedLoginTool].userName = self.userField.text;
        [LoginTool sharedLoginTool].password = self.pwdField.text;
        [[LoginTool sharedLoginTool] sendLoginRequestWithResponse:^(NSDictionary *dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ToastUtil unShowLoading];
                if (dict) {
                    NSLog(@"%@",dict);
                    if([[dict[@"error_code"]stringValue] isEqualToString:@"0"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[LoginTool sharedLoginTool]setUserIDWithOriginDict:dict];
                            [[NSUserDefaults standardUserDefaults]setObject:[LoginTool sharedLoginTool].userName forKey:@"userName"];
                            [[NSUserDefaults standardUserDefaults]setObject:[LoginTool sharedLoginTool].password forKey:@"userPwd"];
                            NSString *alias = [NSString stringWithFormat:@"%@B",self.userField.text];
                            [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                            }];
                            [self loginDidSuccess];
                        });
                    }else if([[dict[@"error_code"]stringValue]isEqualToString:@"1"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:@"用户名或密码不正确"];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:@"网络错误"];
                        });
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showError:@"网络错误"];
                    });
                    
                }
            });
        }];
    }
    else {
        [[LoginTool sharedLoginTool] sendManagerLoginRequestWithUserName:self.userField.text pass:self.pwdField.text Response:^(NSDictionary *dict) {
            //NSLog(@"测试用户id：%@",dict);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dict[@"code"] intValue] == 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self managerDidLoginSuccess];
                        NSString *alias = [NSString stringWithFormat:@"%@A",self.userField.text];
                        [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                            }];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showError:@"用户名或密码不正确"];
                    });
                }
                
            });
        }];
    }
}

-(BOOL)isComplete{
    if (self.userField.text.length==0&&self.pwdField.text.length==0){
        [MBProgressHUD showError:@"用户名和密码未填写"];
        return NO;
    }else if (self.userField.text.length==0){
        [MBProgressHUD showError:@"用户名未填写"];
        return NO;
    }else if (self.pwdField.text.length==0) {
        [MBProgressHUD showError:@"密码未填写"];
        return NO;
    }
    return YES;
}


-(void)loginDidSuccess{
//    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarSetTool sharedTabBarSetTool]getTabBarController];
    
    UIViewController *vc = [[TabBarSetTool sharedTabBarSetTool]getTabBarController];
    
    [UIView transitionFromView:[UIApplication sharedApplication].keyWindow.rootViewController.view
                        toView:vc.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
         [UIApplication sharedApplication].keyWindow.rootViewController = vc;
     }];
}

-(void)managerDidLoginSuccess {
    
    MaintenanceListViewController *vc = [[MaintenanceListViewController alloc] init];
    UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [UIView transitionFromView:[UIApplication sharedApplication].keyWindow.rootViewController.view
                        toView:root.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
         [[self presentingViewController] dismissViewControllerAnimated:NO completion:^{
             [UIApplication sharedApplication].keyWindow.rootViewController = root;
         }];
     }];
}

#pragma mark 注册
/**点击注册按钮*/
- (IBAction)clickRegisterButton:(id)sender {
//    RegisterTableController *rtc = [[RegisterTableController alloc]initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:rtc animated:YES];
    RegisterController *rc = [UIStoryboard storyboardWithName:@"RegisterController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:rc animated:YES];
}

- (IBAction)clickManagerButton:(id)sender {

    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginTableStoryboard" bundle:nil];
    //    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]];
    //    [self.window.rootViewController presentViewController:[[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]] animated:NO completion:nil];
    //    self.window = window;
    //    [self.window makeKeyAndVisible];
    UINavigationController *vc = [[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]];
//
    
    for (id VC in vc.viewControllers) {
//        NSLog(@"-----%@",[VC class]);
        if ([VC isKindOfClass:[LoginTableController class]]) {
            ((LoginTableController *)VC).isManagerLogin = YES;
            break;
        }
    }
    
    [self presentViewController:vc animated:YES completion:nil];

    
    
}



@end
