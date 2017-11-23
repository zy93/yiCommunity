//
//  PayMentViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/11.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PayMentViewController.h"

@interface PayMentViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation PayMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSLog(@"测试：%@",self.url);
    //NSURL *url = [NSURL URLWithString:self.url];
    //[self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.web loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
