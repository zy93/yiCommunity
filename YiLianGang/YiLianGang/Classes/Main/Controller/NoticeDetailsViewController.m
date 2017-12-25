//
//  NoticeDetailsViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/9.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "NoticeDetailsViewController.h"
#import "Masonry.h"

@interface NoticeDetailsViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *releaseTimeLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation NoticeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告详情";

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.titleStr;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [self.scrollView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = self.contentStr;
    self.contentLabel.preferredMaxLayoutWidth = (self.view.frame.size.width -10.0 * 2);
    [self.contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.contentLabel.numberOfLines =0;
    [self.scrollView addSubview:self.contentLabel];
    
    self.releaseTimeLabel = [[UILabel alloc] init];
    self.releaseTimeLabel.text = self.releaseTimeStr;
    self.releaseTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:self.releaseTimeLabel];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.equalTo(self.releaseTimeLabel.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.right.mas_offset(-10);
        make.left.mas_offset(10);
        make.height.mas_offset(30);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0);
        make.right.mas_equalTo(-20.0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(5);
    }];
    
    [self.releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(5);
        make.right.mas_offset(-20);
        make.left.mas_offset(20);
        make.height.mas_offset(21);
    }];

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
