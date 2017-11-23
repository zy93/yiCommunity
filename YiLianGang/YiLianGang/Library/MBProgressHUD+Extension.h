//
//  MBProgressHUD+Extension.h
//  WOTWorkSpace
//
//  Created by 张雨 on 2017/9/6.
//  Copyright © 2017年 北京物联港科技发展有限公司. All rights reserved.
//

#import "MBProgressHUD.h"

typedef void(^Complete)();

@interface MBProgressHUD (Extension)

-(void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay complete:(Complete)complete;

@end
