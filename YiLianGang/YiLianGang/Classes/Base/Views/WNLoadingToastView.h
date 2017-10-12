//
//  WNLoadingToastView.h
//  Wuzhoubaochexian
//
//  Created by Way_Lone on 2017/2/13.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WNLoadingToastView : UIView
-(instancetype)initWithFrame:(CGRect)frame toastString:(NSString *)str backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@end
