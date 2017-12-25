//
//  DeviceDescribeViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/20.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DeviceDescribeViewController.h"
#import "InstallInformationViewController.h"

@interface DeviceDescribeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@end

@implementation DeviceDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // self.imageScrollView.contentSize = CGSizeMake(self.view.frame.size.width,CGRectGetMaxY(self.bottomImageView.frame)+50);
    //self.imageScrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.topImageView.height+self.bottomImageView.height);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (IBAction)ordersButton:(id)sender {
//    InstallInformationViewController *isntallInformation = [UIStoryboard storyboardWithName:@"Main" bundle:@"InstallInformationViewController"];
    InstallInformationViewController *isntallInformation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InstallInformationViewController"];
    [self.navigationController pushViewController:isntallInformation animated:YES];
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
