//
//  PayBillViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/13.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PayBillViewController.h"


@implementation PayContentCell
@end






@implementation PayTitleCell
@end













@interface PayBillViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titleArray;
    NSArray *contentArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation PayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //解决布局顶部空白问题
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    titleArray = @[@"2017年09月",@"2017年08月",@"2017年07月"];
    contentArray = @[@"",@"物业费：",@"停车费：",@"保洁保安费："];
}


#pragma mark - table delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 30;
    }
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        PayTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTitleCell"];
        if (cell==nil) {
            cell = [[PayTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayTitleCell"];
        }
        [cell.title setText:titleArray[indexPath.row]];
        return cell;
    }
    else {
        PayContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayContentCell"];
        if (cell==nil) {
            cell = [[PayContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayContentCell"];
        }
        [cell.title setText: contentArray[indexPath.row]];
        [cell.price setText:@"￥200.00"];
        [cell.state setText:@"未支付"];
        return cell;
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
