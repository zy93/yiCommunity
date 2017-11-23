//
//  DeliveredViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/14.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DeliveredViewController.h"
#import "MBProgressHUDUtil.h"
#import "DepositRefundRequestTool.h"

@interface DeliveredViewController ()

@end

@implementation DeliveredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)depositRefundButton:(id)sender {
    if ([self.orderNum isEqualToString:@""]) {
        
        [MBProgressHUDUtil showMessage:@"没有订单" toView:self.view];
        return;
    }
    NSString *urlStr = @"ReserveSever/Watersubscribe/returnPremium";
    NSDictionary *parDict = @{@"orderNum":self.orderNum};
    
    [DepositRefundRequestTool sharedDepositRefundTool].urlString = urlStr;
    [DepositRefundRequestTool sharedDepositRefundTool].parameterDict = parDict;
    [[DepositRefundRequestTool sharedDepositRefundTool] sendDepositRefundRequestWithResponse:^(NSDictionary *dict) {
        if([[dict allKeys] containsObject:@"code"] && [[dict allKeys] containsObject:@"msg"])
        {
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUDUtil showMessage:@"押金退回申请成功！" toView:self.view];
                    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];

                });
                
            }
        }
        else
        {
            [MBProgressHUDUtil showMessage:@"失败！" toView:self.view];
        }
    }];
}

-(void)delayMethod
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
