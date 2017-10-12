//
//  MaintenanceContentController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/20.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MaintenanceContentController.h"

#import "MaintenanceContentView.h"


@interface MaintenanceContentController ()
{
    MaintenanceContentView *mView;
}

@end

@implementation MaintenanceContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSubview
{
    mView = [[MaintenanceContentView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mView];
    [mView setData:self.mContent];

}

-(void)back
{
//    [self dismissViewControllerAnimated:YES completion:NULL];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
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
