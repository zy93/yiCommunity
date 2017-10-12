//
//  PropertyViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/31.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PropertyViewController.h"
#import "ServiceHeaderView.h"
#import "ServiceView.h"
#import "MaintenanceViewController.h"
#import "ShortcutTool.h"
#import "ServiceInfo.h"
#import "MBProgressHUD+KR.h"

@interface PropertyViewController ()<ServiceViewDelegate>
@property(nonatomic,strong) ServiceView *serviceView;

@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ServiceHeaderView *shv = [[NSBundle mainBundle]loadNibNamed:@"ServiceHeaderView" owner:nil options:nil].lastObject;
    [shv.mTitleLab setText:@"物业管理"];
    [shv.mSubtitleLab setText:@"Property Management"];
    
    
    shv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.40);
    [self.view addSubview:shv];
    self.tableView.tableHeaderView = shv;
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.416*SCREEN_WIDTH)];
    bgImageView.image = [UIImage imageNamed:@"bg_property"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:bgImageView atIndex:0];
    [self doPrettyView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setType:@"fade"];
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}
-(void)doPrettyView{
    [self.navigationController.navigationBar setHidden:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.tableView.bounces = NO;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        [cell addSubview:self.serviceView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        self.serviceView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.6-48);
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.6-48;
}

#pragma mark - service view delegate
-(void)serviceViewDidLongpressIndex:(NSInteger)index
{
    NSLog(@"-------add to home view");
    NSString *selectServiceName = ((ServiceInfo *)[[_serviceView getAllService]objectAtIndex:index]).serviceName;
    //
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"添加到快捷操作中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        NSLog(@"-------add to home view");
        NSArray *shortcutList = [[ShortcutTool shareShortcutTool] getAllShortcut];
        for (NSString *serName in shortcutList) {
            if ([serName isEqualToString:selectServiceName]) {
                [MBProgressHUD showError:@"已存在该操作"];
                return ;
            }
        }
        [[ShortcutTool shareShortcutTool] addShortcutByShortcutName:selectServiceName];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:action];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

-(void)serviceViewDidSelectIndex:(NSInteger)index{
    if (index == 0) {
        MaintenanceViewController *root = [[MaintenanceViewController alloc] init];
        [self.navigationController pushViewController:root animated:YES];
    }
}




- (ServiceView *)serviceView {
    if(_serviceView == nil) {
        _serviceView = [[NSBundle mainBundle]loadNibNamed:@"ServiceView" owner:nil options:nil].lastObject;
        _serviceView.backgroundColor = [UIColor clearColor];
        _serviceView.delegate = self;
        _serviceView.isPro = YES;
    }
    return _serviceView;
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
