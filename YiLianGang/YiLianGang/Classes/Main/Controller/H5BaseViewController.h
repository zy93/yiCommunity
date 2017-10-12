//
//  H5BaseViewController.h
//  YiLianGang
//
//  Created by Way_Lone on 2017/3/1.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WN_YL_RequestTool.h"
#import "LoginTool.h"
#import "NSString+JSON.h"
#import "NSString+URL.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface H5BaseViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UILabel *label;
-(void)clickTopLeftButton:(UIButton*)button;
-(NSString *)stringFromFirstBrackets:(NSString*)str;
-(void)setNaviHide;
-(void)setNaviShow;
@end
