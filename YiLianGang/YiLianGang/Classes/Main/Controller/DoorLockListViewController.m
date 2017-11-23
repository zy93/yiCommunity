//
//  DoorLockListViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/15.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DoorLockListViewController.h"
#import "DoorLockListTableViewCell.h"
#import "DoorLockDescribeViewController.h"

@interface DoorLockListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *doorLockListTableView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *productDescribe;
@property (nonatomic, strong) NSArray *allModelArray;
@property (nonatomic, strong) NSArray *piceArray;

@end

@implementation DoorLockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.doorLockListTableView setTableFooterView:[UIView new]];
    self.piceArray = @[@{@"小丫360卫士":@"1299"},
  @{@"8系列":@"1999",
    @"9系列":@"2999"},
  @{@"2106系列":@"3399",
    @"9888系列":@"3399",
    @"8202系列":@"2799",
    @"1880系列":@"2799",
    @"9001系列":@"3599",
    @"2120系列":@"2199",
    @"8866系列":@"12799"}];
    
    self.allModelArray = @[@[@"小丫360卫士"],@[@"8系列",@"9系列"],@[@"2106系列",@"9888系列",@"8202系列",@"1880系列",@"9001系列",@"2120系列",@"8866系列"]];
    self.imageArray = @[@"qihu",@"dahua",@"haolishi"];
    self.titleArray = @[@"小丫3智能门锁",@"大华家居智能锁",@"豪力士"];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.imageArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoorLockListTableViewCell *cell= [[[NSBundle mainBundle]loadNibNamed:@"DoorLockListTableViewCell" owner:nil options:nil] firstObject];
    [cell.productImage setImage:[UIImage imageNamed:self.imageArray[indexPath.section]]];
    cell.productName.text = self.titleArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoorLockDescribeViewController *doorLockDescribe = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DoorLockDescribeViewController"];
    doorLockDescribe.modelArray = self.allModelArray[indexPath.section];
    doorLockDescribe.piceDict = self.piceArray[indexPath.section];
    NSLog(@"row:%ld",indexPath.section);
    [self.navigationController pushViewController:doorLockDescribe animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
