//
//  DringkingDetailViewController.m
//  CYPA
//
//  Created by 张雨 on 2017/5/11.
//  Copyright © 2017年 HDD. All rights reserved.
//

#import "DringkingDetailViewController.h"
#import "Header.h"
#import "TDSCell.h"
//#import "QueryDeviceCell.h"
#import "UserUseCell.h"
#import "PayMentViewController.h"
#import "LoginTool.h"
//#import "SetDeviceInfoCell.h"

@interface DringkingDetailViewController ()<UITableViewDelegate, UITableViewDataSource>//, SetDeviceInfoCellDelegate>
{
    //UITableView *mTable;
    UIButton *mSwitchBtn;
    BOOL isOn;
}


@end

@implementation DringkingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //if (self.navigationController) {
        //self.navigationItem.title = @"直饮水";
    self.title = @"直饮水";
    //}
    
    isOn = NO;
    [self setupView];
    //[self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"WaterNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTableView) name:@"ReloadDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Pay) name:@"PayNotification" object:nil];
    
   // [self addObserver:self.mDevice forKeyPath:@"fluxPulse" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    //[self removeObserver:self.mDevice forKeyPath:@"fluxPulse"];
}

-(void)loadTableView
{
    [self.tableView reloadData];
}


-(void)setupView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    self.tableView.separatorStyle = UITableViewStyleGrouped;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    // mTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // mTable.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // [self.view addSubview:self.tableView];
    
    mSwitchBtn = [[UIButton alloc] init];
    mSwitchBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    [mSwitchBtn setTitle:@"开" forState:UIControlStateNormal];
    //[mSwitchBtn setTitle:@"关" forState:UIControlStateSelected];
    [mSwitchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mSwitchBtn addTarget:self action:@selector(deviceSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [mSwitchBtn setBackgroundColor:UIColorHEX(0xea5404)];
    self.tableView.tableFooterView = mSwitchBtn;
    
}

#pragma mark - 更新数据
-(void)loadData
{
    [self getTDS];
    [self getPrice];
    [self getBalance];
    [self getFluxSum];
//    [self.mDevice getDeviceID];
//    [self.mDevice getFluxPulse];
   // [self.tableView reloadData];
}

-(void)getTDS
{
    [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"getTDS",@"seq":@"沃特德",@"param":@{}}];
}

-(void)getPrice
{
    [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"getPrice",@"seq":@"沃特德",@"param":@{}}];
}

-(void)getBalance
{
    [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"getBalance",@"seq":@"沃特德",@"param":@{}}];
}

-(void)getFluxSum
{
    [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"getFluxSum",@"seq":@"沃特德",@"param":@{}}];
}

-(void)updateView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [self updateView];
}

#pragma mark - 开关
-(void)deviceSwitch:(UIButton *)sender
{
//    [self.mDevice controlWith:sender.isSelected withResponse:^(NSDictionary *dic) {
//        if ([dic[@"data"][@"result"] isEqualToString:@"success"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                sender.selected = !sender.isSelected;
//            });
//        }
//    }];
    if (isOn) {
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"seq":@"沃特德",@"param":@{@"control":@"0"}}];
        //mSwitchBtn.titleLabel.text = @"开";
        [mSwitchBtn setTitle:@"开" forState:UIControlStateNormal];

        isOn = NO;
    }else
    {
        [self sendWebSocketStringWithParam:@{@"thingId":self.deviceInfo.thingId,@"serviceId":@"control",@"seq":@"沃特德",@"param":@{@"control":@"1"}}];
        [mSwitchBtn setTitle:@"关" forState:UIControlStateNormal];
        isOn = YES;
    }
    NSLog(@"测试：开关");
}

#pragma  mark - table delegate & dataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 5;
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
    //return 50;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
       return 275;
        //return 300;
    }
    else if (indexPath.section==1) {
        return 268;
    }
    else if (indexPath.section==2||indexPath.section==3) {
        return 92;
    }
    
    return 267;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"测试结果：%@,%@,%@,%@",self.priceMessageDictionary,self.TDSMessageDictionary,self.fluxSumMessageDictionary,self.balanceMessageDictionary);
    if (indexPath.section==0) {
        TDSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TDSCell"];
        if (!cell) {
            cell = [[TDSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TDSCell"];
        }
        //cell.number = self.mDevice.TDS.integerValue;
        //NSNumber* i =[self.TDSMessageDictionary objectForKey:@"number"];
        
        cell.number = [[self.TDSMessageDictionary objectForKey:@"number"] integerValue];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UserUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserUseCell"];
        if (!cell) {
            cell = [[UserUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserUseCell"];
        }
        //        cell.fluxSum = self.mDevice.fluxSum.integerValue;
        //        cell.balance = self.mDevice.balance.integerValue;
        //        cell.price   = self.mDevice.price.integerValue;
        cell.fluxSum = [[self.fluxSumMessageDictionary objectForKey:@"sum"] integerValue];
        cell.balance = [[self.balanceMessageDictionary objectForKey:@"money"] integerValue];
        cell.price   = [[self.priceMessageDictionary objectForKey:@"flux"] integerValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(void)Pay
{
    NSLog(@"测试用户id:%@",[LoginTool sharedLoginTool].userID);
    PayMentViewController *payMentView= [[PayMentViewController alloc]initWithNibName:@"PayMentViewController" bundle:[NSBundle mainBundle]];
    payMentView.url = [NSString stringWithFormat:@"http://www.yiliangang.net:8012/JuHeFuPay/pay.jsp?facilitator=0001&carrieroperator=0002&useridpro=%@&thingidpro=%@&productnamepro=%@&productdescpro%@&phonepro=13240371551&redirecturlpro=http://www.yiliangang.net:8012/JuHeFuPay/success.jsp",[LoginTool sharedLoginTool].userID,self.deviceInfo.thingId,PRODUCTNAMEPRO,PRODUCTDESCPRO];
    [self.navigationController pushViewController:payMentView animated:YES];
}

@end
