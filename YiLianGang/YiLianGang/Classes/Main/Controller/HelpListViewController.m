//
//  HelpListViewController.m
//  YiLianGang
//
//  Created by 张雨 on 2017/11/11.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "HelpListViewController.h"
#import "HelpAddWaterDispenserViewController.h"
#import "HelpWaterChangeWifiViewController.h"

@interface HelpListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HelpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[UIView new]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - table delegate & source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpListVCCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HelpListVCCell"];
    }
    
    if (indexPath.row == 0) {
       cell.textLabel.text = @"如何添加设备";
    }
    
    if (indexPath.row == 1) {
       cell.textLabel.text = @"如何修改设备网络";
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HelpListViewController" bundle:nil];
        
        /* 获取storyboard的InitialViewController 即根控制器*/
        HelpAddWaterDispenserViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HelpAddWaterDispenserViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HelpListViewController" bundle:nil];
        
        /* 获取storyboard的InitialViewController 即根控制器*/
        HelpAddWaterDispenserViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HelpWaterChangeWifiViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
