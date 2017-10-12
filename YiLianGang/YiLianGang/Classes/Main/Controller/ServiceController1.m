//
//  ServiceController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/18.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "ServiceController1.h"

#import "OneViewTableTableViewController.h"
#import "SecondViewTableViewController.h"
#import "ThirdViewCollectionViewController.h"
#import "MainTouchTableTableView.h"
#import "MYSegmentView.h"
#import "UIImage+ImageColorChange.h"
#define Main_Screen_Height      ([[UIScreen mainScreen] bounds].size.height+64)
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
static CGFloat const headViewHeight = 200;

@interface ServiceController1 ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MYSegmentView * RCSegView;
@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
@property(nonatomic,assign) CGPoint contentOffset;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;


@end

@implementation ServiceController
@synthesize mainTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    self.navigationItem.title = @"服务";
    
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView addSubview:self.headImageView];
    self.mainTableView.bounces = NO;
    /*
     *
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mainTableView.contentOffset= self.contentOffset;
//    self.mainTableView.contentInset = UIEdgeInsetsZero;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    //NSLog(@"%f",yOffset);
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y-64;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat colorChangeOffset = tabOffsetY - yOffset;
    //NSLog(@"--%f",colorChangeOffset);
    CGFloat naviAlpha = 0.0;
    if (colorChangeOffset<100 && colorChangeOffset>=0) {
        naviAlpha = (100-colorChangeOffset)/100;
        
    }
    else if(colorChangeOffset>=100){
        naviAlpha = 0.0;
    }else{
        naviAlpha = 1.0;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.9951 green:0.995 blue:0.995 alpha:naviAlpha]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithRed:0.6423 green:0.6423 blue:0.6423 alpha:naviAlpha]]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.302 green:0.302 blue:0.302 alpha:naviAlpha],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.706 green:0.706 blue:0.706 alpha:naviAlpha]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:naviAlpha]];
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.contentOffset = scrollView.contentOffset;
        _isTopIsCanNotMoveTabView = YES;
    }else{
        self.contentOffset = scrollView.contentOffset;        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    
    /**
     * 处理头部视图
     */
    if(yOffset < -headViewHeight) {
        
        CGRect f = self.headImageView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        
        //改变头部视图的fram
        self.headImageView.frame= f;
        
        
    }
    
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"server_header_pic"]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,Main_Screen_Width,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        

    }
    return _headImageView;
}


-(UITableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height-64-48)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height-64-48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}

/*
 * 这里可以任意替换你喜欢的pageView
 */
-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
        
        OneViewTableTableViewController * First=[[OneViewTableTableViewController alloc]initWithContentSize:CGSizeMake(Main_Screen_Width, Main_Screen_Height-64-48-41)];
        
        SecondViewTableViewController * Second=[[SecondViewTableViewController alloc]initWithContentSize:CGSizeMake(Main_Screen_Width, Main_Screen_Height-64-48-41)];
        
        ThirdViewCollectionViewController * Third=[[ThirdViewCollectionViewController alloc]initWithContentSize:CGSizeMake(Main_Screen_Width, Main_Screen_Height-64-48-41)];
        
        NSArray *controllers=@[First,Second,Third];
        
        NSArray *titleArray =@[@"first",@"second",@"third"];
        
        MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64-48) controllers:controllers titleArray:titleArray ParentController:self lineWidth:Main_Screen_Width/5 lineHeight:3.];
        
        _RCSegView = rcs;
    }
    return _RCSegView;
}

@end