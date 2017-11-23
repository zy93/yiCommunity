//
//  AppDelegate.m
//  YiLianGang
//
//  Created by Way_Lone on 16/7/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginTool.h"
#import "TabBarSetTool.h"
#import "WelcomeController.h"
#import "WelcomeView.h"
#import "StyleTool.h"
#import "WeatherTool.h"
#import "WXApi.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<LoginToolDelegate, JPUSHRegisterDelegate,WXApiDelegate>
@property(nonatomic,strong) UIView *coverView;
@property(nonatomic,strong) WelcomeController *welcomeController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //LoginViewController *lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self judgeIsNeedHidden];
    [self comfirmIfHasLoginSaved];
    //清楚通知小红点
    
    [[UINavigationBar appearance]setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[[StyleTool sharedStyleTool]sessionSyle].naviColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    //注册推送
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge |JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginJPushSuccess:) name:kJPFNetworkDidLoginNotification object:nil];
    [JPUSHService setupWithOption:launchOptions appKey:@"75e36ba58c40013577df92f4" channel:@"APP Store" apsForProduction:NO ];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [WXApi registerApp:@"wx6fcad0227e60327c"];
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - 微信支付回调方法
- (void)onResp:(BaseResp*)resp
{
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    
    if([resp isKindOfClass:[PayResp class]])
    {
        // 支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                //                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                //NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@"success"];
                //[[NSNotificationCenter defaultCenter] postNotification:notification];
                //NSNotification *rechargeNoti = [NSNotification notificationWithName:RECHARGE_PAY_NOTIFICATION object:@"recharge_success"];
                //[[NSNotificationCenter defaultCenter] postNotification:rechargeNoti];
                
                break;
            }
                
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
            }
        }
    }
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    //    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self refreshWeather];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"进入前台了！");
    //清楚小红点
    dispatch_async(dispatch_get_main_queue(), ^{
        [JPUSHService resetBadge];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        NSNotification *notification = [NSNotification notificationWithName:@"wifiNotification" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSLog(@"---Device Token:%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
      NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - 外包代码

-(void)comfirmIfHasLoginSaved{
    [self goToWelcomeController];
    if ([[NSUserDefaults standardUserDefaults]stringForKey:@"userName"].length>0&&[[NSUserDefaults standardUserDefaults]stringForKey:@"userPwd"].length>0) {
        NSString *nameStr = [[NSUserDefaults standardUserDefaults]stringForKey:@"userName"];
        NSString *pwdStr = [[NSUserDefaults standardUserDefaults]stringForKey:@"userPwd"];
        [LoginTool sharedLoginTool].userName = nameStr;
        [LoginTool sharedLoginTool].password = pwdStr;
        [[LoginTool sharedLoginTool] sendLoginRequest];
        [LoginTool sharedLoginTool].delegate = self;
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self goToLoginView];
        });
        
    }
}

-(void)goToLoginView{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userPwd"];
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginTableStoryboard" bundle:nil];
    //    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]];
    //    [self.window.rootViewController presentViewController:[[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]] animated:NO completion:nil];
    //    self.window = window;
    //    [self.window makeKeyAndVisible];
    UIViewController *vc = [[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]];
    
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:vc.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
         self.window.rootViewController = vc;
         self.welcomeController = nil;
     }];
    //    [self addCoverViewAnimation];
}

-(void)loginToolDidLogin:(BOOL)isSuccess withDict:(NSDictionary*)dict{
    if (isSuccess) {
        if([[dict[@"error_code"]stringValue] isEqualToString:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[LoginTool sharedLoginTool]setUserIDWithOriginDict:dict];
                
                
                [self loginDidSeccess];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self goToLoginView];
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self goToLoginView];
        });
    }
}
-(void)loginDidSeccess{
    //TODO: 登录成功
    [self goToTabBar];
}
/**设置WelcomeController*/
-(void)goToWelcomeController{
    self.welcomeController = [WelcomeController new];
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = _welcomeController;
    
    self.window = window;
    [self.window makeKeyAndVisible];
    
}
-(void)addCoverViewAnimation{
    self.coverView = [[NSBundle mainBundle]loadNibNamed:@"WelcomeView" owner:nil options:nil].lastObject;
    self.coverView.frame = [UIScreen mainScreen].bounds;
    [self.window addSubview:self.coverView];
    [UIView animateWithDuration:1.5 animations:^{
        self.coverView.alpha = 0;
    }completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.coverView removeFromSuperview];
            //            [self.welcomeController dismissViewControllerAnimated:NO completion:nil];
            self.welcomeController = nil;
        });
    }];
}
/**设置tabBar*/
-(void)goToTabBar{
    UIViewController *vc = [[TabBarSetTool sharedTabBarSetTool]getTabBarController];
    
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:vc.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
         self.window.rootViewController = vc;
         self.welcomeController = nil;
     }];
    
}

+(BOOL)isNeedHidden{
    //    return NO;
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"isNeedHidden"];
}
-(void)judgeIsNeedHidden{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [formatter dateFromString:dateTime];
    
    NSDate *date = [formatter dateFromString:@"06-11-2016-000000"];
    NSComparisonResult result = [currentDate compare:date];
    if (result == NSOrderedDescending) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isNeedHidden"];
        
    }
    else if (result == NSOrderedAscending){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isNeedHidden"];
        
    }
    
}

-(void)refreshWeather{
    WeatherTool *weatherTool = [WeatherTool sharedWeatherTool];
    if ([LoginTool sharedLoginTool].userID.length>0) {
        [weatherTool sendWeatherRequest];
    }
}

#pragma mark - JPush delegate

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary *userInfo= notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo= response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}

#pragma mark - JPush Notification
-(void)loginJPushSuccess:(NSNotification *)notf
{
    if (!strIsEmpty([LoginTool sharedLoginTool].userTel)) {
        NSString *alias = [NSString stringWithFormat:@"%@%@",[LoginTool sharedLoginTool].userTel,[LoginTool sharedLoginTool].isManager == YES? @"A":@"B"];
        [JPUSHService setTags:[NSSet setWithObject:@"iOS"] alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            //NSLog(@"********set Alias:%@",alias);
        }];
    }
}


@end
