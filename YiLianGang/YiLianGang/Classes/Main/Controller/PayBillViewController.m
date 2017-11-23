//
//  PayBillViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/13.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "PayBillViewController.h"
#import "PropertyBillListRequestTool.h"
#import "MBProgressHUDUtil.h"
#import "AFNetworking.h"
#import "PayInfo.h"
#import "PayContentCell.h"

@implementation PayTitleCell
@end

@interface PayBillViewController () <UITableViewDelegate, UITableViewDataSource,PayContentCellDelegate>
{
    NSArray *titleArray;
    NSArray *contentArray;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *billListArray;
@property (nonatomic, assign) int paySum;
@property (nonatomic, strong) NSMutableArray *payBillList;
@property (nonatomic, assign) int index;

@property (nonatomic, strong)NSMutableSet *selectdeSet; //记录选中状态
@property (nonatomic, strong)NSMutableArray *dataArray;//数组中添加选中时候的tag值
@property (nonatomic, strong)NSMutableSet *payFinishSet;
@end

@implementation PayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index =  0;
    self.paySum = 0;
    self.selectdeSet = [NSMutableSet set];
    self.payFinishSet = [NSMutableSet set];
    self.dataArray = [NSMutableArray array];
    self.totalPriceLab.text = [NSString stringWithFormat:@"¥%d.00",self.paySum];
    // Do any additional setup after loading the view.
    //解决布局顶部空白问题
    self.monthArray = [[NSMutableArray alloc] init];
    self.payBillList = [[NSMutableArray alloc] init] ;
    self.billListArray = [[NSMutableArray alloc] init] ;
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
    [self getPropertyBillListData];
}


#pragma mark - table delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.monthArray.count;
   // return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *numberRows = [self.billListArray[section] objectForKey:@"billList"];
    return numberRows.count+1;
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
        [cell.title setText:self.monthArray[indexPath.section]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {

        NSString *cell_id = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
        PayContentCell *cell = (PayContentCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];

        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PayContentCell" owner:nil options:nil].firstObject;
        }

        NSMutableDictionary *billDic = [[NSMutableDictionary alloc] init];
        billDic = self.billListArray[indexPath.section];
        NSArray *billList = [billDic objectForKey:@"billList"];
        [cell.title setText:[billList[indexPath.row-1] objectForKey:@"costName"]];
        NSString *cost = [[billList[indexPath.row-1] objectForKey:@"cost"] stringValue];
        [cell.price setText:[NSString stringWithFormat:@"¥%@.00",cost]];
        cell.delegate = self;
        [cell.state setText:[billList[indexPath.row-1] objectForKey:@"billState"]];
        if ([[billList[indexPath.row-1] objectForKey:@"billState"] isEqualToString:@"已缴"]) {
            [self.payFinishSet addObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
        }
        
        if ([self.payFinishSet containsObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]]) {
            cell.selectedBuuton.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.selectdeSet containsObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]]) {
            cell.selectedBuuton.selected = YES;
            
        }
        return cell;
    }
}


#pragma mark - PayContentCellDelegate
-(void)payBillSelected:(PayContentCell *)cell isSelected:(BOOL)choosed
{
    
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    if (cell.selectedBuuton.selected == NO) {
        cell.selectedBuuton.selected = YES;
        [cell.selectedBuuton setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        [self.dataArray addObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
        //向NSMutableSet动态添加选中的对象
        [self.selectdeSet addObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
        
    } else {
        cell.selectedBuuton.selected = NO;
        for (int i = 0; i < self.dataArray.count; i++) {
            if ([[self.dataArray objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]]) {
                // 删除数组中选中的对象
                [self.dataArray removeObjectAtIndex:i];
                //删除NSMutableSet中选择的对象
                [self.selectdeSet removeObject:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            }
        }
    }
    PayInfo *payInfo = self.payBillList[indexPath.section][indexPath.row-1];
    payInfo.isSelected = !payInfo.isSelected;
    cell.selectedBuuton.selected = payInfo.isSelected;
    //[self.table reloadData];
    [self countPaySum];
}

-(void)getPropertyBillListData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *requestUrl = @"http://www.yiliangang.net:8012/property_following_residence/PropertyBill/findUserTelPackage";
    NSDictionary *parmDict = @{@"userTel":@"12345678912"
                               };//请求可接受订单接口
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:requestUrl parameters:parmDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary *dict1 in [responseObject objectForKey:@"msg"]) {
            NSString *year = [NSString stringWithFormat:@"%@年",[dict1 objectForKey:@"year"]];
            NSLog(@"年打印：%@",year);
            for (NSDictionary *dict2 in [dict1 objectForKey:@"month"]) {
                NSString *month = [NSString stringWithFormat:@"%@%@月",year,[dict2 objectForKey:@"month"]];
                [self.monthArray addObject:month];
                [self.billListArray addObject:dict2];
                NSMutableArray *payInfoArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dict3 in [dict2 objectForKey:@"billList"]) {
                    PayInfo *payInfo = [[PayInfo alloc] init];
                    payInfo.payInfoDic = dict3;
                    payInfo.isSelected = NO;
                    [payInfoArray addObject:payInfo];
                }
                [self.payBillList addObject:payInfoArray];
            }
        }
        NSLog(@"打印：%@",self.billListArray);
        NSLog(@"bill:%@",self.payBillList);
        //[self countPaySum];
        [self.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

-(void)countPaySum
{
    self.paySum = 0;
    for (NSMutableArray *array in self.payBillList) {
        for (PayInfo *info in array) {
            if (info.isSelected) {
                self.paySum += [[info.payInfoDic objectForKey:@"cost"] intValue];
            }
        }
    }
    self.totalPriceLab.text = [NSString stringWithFormat:@"¥%d.00",self.paySum];
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
