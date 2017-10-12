//
//  H5BaseViewController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/3/1.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "H5BaseViewController.h"

@interface H5BaseViewController ()

@end

@implementation H5BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, 60)];
    self.label.text = @"加载中";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.center = self.view.center;
    [self.view addSubview:self.label];
    [self setLeftBackNaviItem];
    
    [self setNaviShow];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.label removeFromSuperview];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.label.text = @"加载失败,请检查网络";
}
-(void)setLeftBackNaviItem{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.navigationController) {
        //左边
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.frame = CGRectMake(0, 0, 60, 40);
        [leftButton setTitle:@"        " forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
        
        leftButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
        [leftButton addTarget:self action:@selector(clickTopLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [leftView addSubview:leftButton];
        leftView.backgroundColor = [UIColor clearColor];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
        //隐藏navi
        
    }
}
-(void)clickTopLeftButton:(UIButton*)button{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//取出第一个括号里的字符串
-(NSString *)stringFromFirstBrackets:(NSString*)str{
    
    for (NSInteger i = 0; i<str.length; i++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i, 1)];
        if ([subStr isEqualToString:@"("]) {
            if (i+1<str.length) {
                NSString *deleteForeHeadStr = [str substringFromIndex:i+1];
                
                for (NSInteger j = deleteForeHeadStr.length-1; j>-1; j--) {
                    NSString *subStr = [deleteForeHeadStr substringWithRange:NSMakeRange(j, 1)];
                    if ([subStr isEqualToString:@")"]) {
                        NSString *innerStr = [deleteForeHeadStr substringToIndex:j];
                        return innerStr;
                    }
                }
                
            }
        }
    }
    return nil;
    
}
#pragma mark 设置导航栏隐藏或者显示
-(void)setNaviHide{
    [self.navigationController.navigationBar setHidden:YES];
    self.webView.frame = self.view.bounds;
}
-(void)setNaviShow{
    [self.navigationController.navigationBar setHidden:NO];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGFloat y = rectNav.origin.y+rectNav.size.height;
    self.webView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height-y);
}
#pragma mark 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES; // 返回NO表示要显示，返回YES将hiden
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
