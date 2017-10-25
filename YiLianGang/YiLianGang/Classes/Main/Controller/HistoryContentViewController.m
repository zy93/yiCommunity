//
//  HistoryContentViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/31.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "HistoryContentViewController.h"
#import "HistoryContentView.h"
@interface HistoryContentViewController ()
{
    HistoryContentView *mView;
}
@end

@implementation HistoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSubview
{
    mView = [[HistoryContentView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mView];
    [mView setData:self.mContent];
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
