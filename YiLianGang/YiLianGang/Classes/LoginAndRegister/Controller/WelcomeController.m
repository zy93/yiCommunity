//
//  WelcomeController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/16.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WelcomeController.h"
#import "WelcomeView.h"
@interface WelcomeController ()
@property(nonatomic,strong) WelcomeView *welcomeView;
@end

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.welcomeView = [[NSBundle mainBundle]loadNibNamed:@"WelcomeView" owner:nil options:nil].lastObject;
    self.welcomeView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.welcomeView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)dealloc{
    
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
