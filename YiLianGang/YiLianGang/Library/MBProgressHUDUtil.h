//
//  MBProgressHUDUtil.h
//  LYFaultDiagnosis
//
//  Created by YNKJMACMINI2 on 15/10/12.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBProgressHUDUtil : NSObject

/**
 *	@brief 展示自动消失的消息提示
 *
 *	@param message	提示文本
 *	@param view		要展示提示消息的view
 */
+(void)showMessage:(NSString *)message toView:(UIView *)view;


/**
 *	@brief 展示带文本的loading提示
 *
 *	@param message	提示文本
 *	@param view     要添加提示的view
 *	@param block    显示loading期间要执行的操作,block中调用hud参数的hide方法即可隐藏loading提示
 */
+(void)showLoadingWithMessage:(NSString *)message toView:(UIView *)view whileExcusingBlock:(void(^)(MBProgressHUD *hud))block;

/**
 *	@brief 展示自定义view的loading提示
 *
 *	@param coustomView	自定义view
 *	@param view	  要添加提示的view
 *	@param block	显示loading期间要执行的操作,block中调用hud参数的hide方法即可隐藏loading提示
 */
+(void)showLoadingWithCustomView:(UIView *)coustomView toView:(UIView *)view whileExcusingBlock:(void(^)(MBProgressHUD *hud))block;

/**
 *	@brief 展示带文本、自定义view的loading提示
 *
 *	@param coustomView	自定义view
 *	@param message	提示文本
 *	@param view		要添加提示的view
 *	@param block		显示loading期间要执行的操作,block中调用hud参数的hide方法即可隐藏loading提示
 */
+(void)showLoadingWithCustomView:(UIView *)coustomView message:(NSString *)message toView:(UIView *)view whileExcusingBlock:(void(^)(MBProgressHUD *hud))block;
@end
