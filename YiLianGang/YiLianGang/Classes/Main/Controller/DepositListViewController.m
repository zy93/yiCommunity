//
//  DepositListViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/14.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DepositListViewController.h"
#import "DeliveredViewController.h"
#import "OrderInquiryRequestTool.h"
#import "LoginTool.h"
#import "MBProgressHUDUtil.h"

@interface DepositListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *depositListTableView;
@property (nonatomic, strong) NSArray *orderListArray;


@end

@implementation DepositListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orderListArray  = [[NSArray alloc] init];
    [self requestOderListData];
    [self.depositListTableView setTableFooterView:[UIView new]];
}
#pragma mark - table delegate & source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.tabBar setHidden:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepositListVCCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DepositListVCCell"];
    }
    cell.textLabel.text = @"沃特德直饮水设备押金";
    
    
    if ([[self.orderListArray[indexPath.row] objectForKey:@"orderState"] isEqualToString:@"SUCCESS"]) {
        cell.detailTextLabel.text = @"已交";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1];
    }else
    {
        cell.detailTextLabel.text = @"未交";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:192.0 / 255.0 green:192.0 / 255.0 blue:192.0 / 255.0 alpha:1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[self.orderListArray[indexPath.row] objectForKey:@"orderState"] isEqualToString:@"SUCCESS"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DepositListViewController" bundle:nil];
        
        /* 获取storyboard的InitialViewController 即根控制器*/
        DeliveredViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DeliveredViewController"];
        vc.orderNum = [self.orderListArray[indexPath.row] objectForKey:@"orderNum"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestOderListData
{
    NSString *urlStr = @"ReserveSever/Watersubscribe/findTel";
    NSDictionary *parmDict = @{@"tel":[LoginTool sharedLoginTool].userTel};
    [OrderInquiryRequestTool sharedOrderInquiryTool].urlString = urlStr;
    [OrderInquiryRequestTool sharedOrderInquiryTool].parameterDict = parmDict;
    [[OrderInquiryRequestTool sharedOrderInquiryTool] sendOrderInquiryRequestWithResponse:^(NSDictionary *dict) {
        if([[dict allKeys] containsObject:@"code"] && [[dict allKeys] containsObject:@"msg"])
        {
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                self.orderListArray = [dict objectForKey:@"msg"];
                NSLog(@"押金列表：%@",self.orderListArray);
                [self.depositListTableView reloadData];
            }
        }
        else
        {
            [MBProgressHUDUtil showMessage:@"没有订单" toView:self.view];
        }
    }];
}

@end
