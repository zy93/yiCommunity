//
//  ToastUtil.m
//  Wuzhoubaochexian
//
//  Created by Way_Lone on 2017/2/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "ToastUtil.h"
#import "WNToastView.h"
#import "WNLoadingToastView.h"
static ToastUtil *instance;
@interface ToastUtil();
@property(nonatomic,strong) WNLoadingToastView *loadingView;
@end
@implementation ToastUtil
+(instancetype)sharedToastUtil{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ToastUtil new];
    });
    return instance;
}
+(void)showToast:(NSString*)str{
    CGRect frame = [UIScreen mainScreen].bounds;
    WNToastView *toastView = [[WNToastView alloc]initWithFrame:frame toastString:str disappearTime:3 backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication].keyWindow addSubview:toastView];
    
}

+(void)showLoadingToast:(NSString *)str{
    CGRect frame = [UIScreen mainScreen].bounds;
    WNLoadingToastView *loadingView = [[WNLoadingToastView alloc]initWithFrame:frame toastString:str backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor]];
    [self unShowLoading];
    [ToastUtil sharedToastUtil].loadingView = loadingView;
    [[UIApplication sharedApplication].keyWindow addSubview:loadingView];

}
+(void)unShowLoading{
    if ([ToastUtil sharedToastUtil].loadingView) {
        [[ToastUtil sharedToastUtil].loadingView.indicator stopAnimating];
        [[ToastUtil sharedToastUtil].loadingView removeFromSuperview];
    }
}
@end
