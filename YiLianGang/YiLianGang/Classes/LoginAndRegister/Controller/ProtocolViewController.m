//
//  ProtocolViewController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "ProtocolViewController.h"
#import "RegisterInfoTool.h"
@interface ProtocolViewController ()
@property (weak, nonatomic) IBOutlet UITextView *protocolTextView;

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPretteyView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**美化界面*/
-(void)doPretteyView{
    self.navigationItem.title = @"服务协议";
    //TODO: 设置协议内容
    
    //设置左上角返回键
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(8, 11, 40, 21)];
    [button addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_back.png"]];
    imageView.frame = CGRectMake(0, 0, 13, 21);
    [button addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    WS(weakSelf);
    [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetUserProtocolHandler:^(NSDictionary *dict) {
        if (dict) {
            NSString *protocolStr = dict[@"data"][@"content"];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.protocolTextView.text = protocolStr;
            });
        }
    }];
}
-(void)clickBackButton:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
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
