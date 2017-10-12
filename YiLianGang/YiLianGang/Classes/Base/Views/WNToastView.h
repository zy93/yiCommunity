//
//  WNToastView.h
//  Wuzhoubaochexian
//
//  Created by Way_Lone on 2017/2/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WNToastView : UIView
-(instancetype)initWithFrame:(CGRect)frame toastString:(NSString *)str disappearTime:(CGFloat)time backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;

@end
