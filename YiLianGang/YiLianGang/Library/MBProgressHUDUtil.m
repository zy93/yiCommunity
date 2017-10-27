//
//  MBProgressHUDUtil.m
//  LYFaultDiagnosis
//
//  Created by YNKJMACMINI2 on 15/10/12.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import "MBProgressHUDUtil.h"
#import "MBProgressHUD.h"

@implementation MBProgressHUDUtil
+(void)showMessage:(NSString *)message toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    if(message==nil || [message isEqualToString:@""])
    {
        hud.labelText = @"MBProgressHUDUtil收到的message为空";
    }
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}

+(void)showLoadingWithMessage:(NSString *)message toView:(UIView *)view whileExcusingBlock:(void(^)(MBProgressHUD *hud))block
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    block(hud);
}

+(void)showLoadingWithCustomView:(UIView *)coustomView toView:(UIView *)view whileExcusingBlock:(void(^)(MBProgressHUD *hud))block{
    [self showLoadingWithCustomView:coustomView message:nil toView:view whileExcusingBlock:block];
}

+(void)showLoadingWithCustomView:(UIView *)coustomView message:(NSString *)message toView:(UIView *)view whileExcusingBlock:(void(^)(MBProgressHUD *hud))block{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (message != nil && ![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        hud.labelText = message;
    }
    hud.customView = coustomView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = [UIColor clearColor];
    hud.removeFromSuperViewOnHide = YES;
    block(hud);
}
@end
