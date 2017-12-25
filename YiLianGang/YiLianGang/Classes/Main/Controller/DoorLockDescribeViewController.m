//
//  DoorLockDescribeViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/13.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DoorLockDescribeViewController.h"
#import "DoorLockPayViewController.h"

@interface DoorLockDescribeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DoorLockDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doorLockOrderButton:(id)sender {
    DoorLockPayViewController  *doorLockPayVC = [[UIStoryboard storyboardWithName:@"DoorLockListViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"DoorLockPayViewController"];
    doorLockPayVC.piceDict = self.piceDict;
    doorLockPayVC.modelArray = self.modelArray;
    [self.navigationController pushViewController:doorLockPayVC animated:YES];
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
