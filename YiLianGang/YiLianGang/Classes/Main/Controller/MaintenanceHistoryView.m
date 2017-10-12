//
//  MaintenanceListView.m
//  YiLianGang
//
//  Created by 张雨 on 2017/3/17.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "MaintenanceHistoryView.h"
#import "MaintenanceHistoryViewController.h"
#import "MJRefresh.h"
#import "MaintenanceContentView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface HistoryCell()

@property (nonatomic, strong) UIView *mTagView;
@property (nonatomic, strong) UILabel *mTitleLab;
@property (nonatomic, strong) UILabel *mSubtitleLab;
@property (nonatomic, strong) UIView *mLine;
@property (nonatomic, strong) UILabel *mStateLab;
@property (nonatomic, strong) UIImageView *mArrowIV;

@end


@implementation HistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubview];
    }
    return self;
}

-(void)createSubview
{
    _mTagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 75)];
    //    _mTagView.backgroundColor
    [self addSubview:_mTagView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 64)];
    title.text = @"报修内容";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    
    _mTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mTagView.frame)+10, 20, SCREEN_WIDTH-100, 20)];
    //    _mTitleLab.backgroundColor = HEXCOLOR(0x34aa77);
    _mTitleLab.text = @"ASFSAFSAFSFSDA";
    _mTitleLab.font = [UIFont systemFontOfSize:17.f];
    [self addSubview:_mTitleLab];
    
    _mSubtitleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_mTitleLab.frame), CGRectGetMaxY(_mTitleLab.frame)+5, CGRectGetWidth(_mTitleLab.frame), 20)];
    _mSubtitleLab.text = @"AAAAAAAAAAAAAA";
    _mSubtitleLab.font = [UIFont systemFontOfSize:12.f];
    //    _mSubtitleLab.backgroundColor = HEXCOLOR(0x77dd3d);
    [self addSubview:_mSubtitleLab];
    
    _mStateLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-21-12-10-39, 25, 39, 39)];
    _mStateLab.center = CGPointMake(CGRectGetMidX(_mStateLab.frame), 75/2);
    _mStateLab.text = @"已完成";
    _mStateLab.font = [UIFont systemFontOfSize:10.f];
    _mStateLab.layer.cornerRadius = _mStateLab.frame.size.height/2;
    _mStateLab.clipsToBounds = YES;
    _mStateLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_mStateLab];
    
    _mArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_mStateLab.frame)+10, 25, 12, 20)];
    _mStateLab.center = CGPointMake(CGRectGetMidX(_mStateLab.frame), 75/2);
    
    [_mArrowIV setImage:[UIImage imageNamed:@"arrow"]];
    [self addSubview:_mArrowIV];
    
}

@end





@interface MaintenanceHistoryView ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *mTable;
    NSArray *mArray;
}
@end

@implementation MaintenanceHistoryView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
        [self addRefreshHeader];
    }
    return self;
}

-(void)createSubview
{
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 64)];
    topBar.backgroundColor  = HEXCOLOR(0x47d2ae);
    [self addSubview:topBar];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.frame), 44)];
    title.text = @"报修事项";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:17.f];
    title.textAlignment = NSTextAlignmentCenter;
    [topBar addSubview:title];
    
    
    
    mTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-64) style:UITableViewStylePlain];
    mTable.dataSource = self;
    mTable.delegate = self;
    mTable.backgroundColor = HEXCOLOR(0xefefef);
    [self addSubview:mTable];
}

-(void)addRefreshHeader
{
    __weak UITableView *pTableView = mTable;
    ///添加刷新事件
    pTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(StartRefresh)];
    pTableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)StartRefresh
{
    if (mTable.mj_footer != nil && [mTable.mj_footer isRefreshing])
    {
        [mTable.mj_footer endRefreshing];
    }
    [(MaintenanceHistoryViewController *)[self GetSubordinateControllerForSelf] refreshData];
}

- (void)StopRefresh
{
    if (mTable.mj_header != nil && [mTable.mj_header isRefreshing])
    {
        [mTable.mj_header endRefreshing];
    }
}

-(void)setData:(NSArray *)dataArray
{
    mArray = dataArray;
    [mTable reloadData];
    [self StopRefresh];
}



#pragma mark - delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaintenanceCell"];
    if (!cell) {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaintenanceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = mArray[indexPath.row];
    
    if ([dic[@"state"] isEqualToString:StateOrderPlacement]) {
        [cell.mTagView setBackgroundColor:HEXCOLOR(0xe94e4d)];
        [cell.mStateLab setBackgroundColor:HEXCOLOR(0xe94e4d)];
        [cell.mStateLab setText:@"待维修"];
    }
    else if ([dic[@"state"] isEqualToString:StateOrderReceiving]) {
        [cell.mTagView setBackgroundColor:HEXCOLOR(0xabe9bb)];
        [cell.mStateLab setBackgroundColor:HEXCOLOR(0xabe9bb)];
        [cell.mStateLab setText:@"已接受"];
    }
    else if ([dic[@"state"] isEqualToString:StateOrderMaintenance]) {
        [cell.mTagView setBackgroundColor:HEXCOLOR(0xeee94a)];
        [cell.mStateLab setBackgroundColor:HEXCOLOR(0xeee94a)];
        [cell.mStateLab setText:@"维修中"];
    }
    else if ([dic[@"state"] isEqualToString:StateOrderComplete]) {
        [cell.mTagView setBackgroundColor:HEXCOLOR(0xaae9aa)];
        [cell.mStateLab setBackgroundColor:HEXCOLOR(0xaae9aa)];
        [cell.mStateLab setText:@"完成维修"];
        cell.mStateLab.adjustsFontSizeToFitWidth = YES;
    }
    else  {
        [cell.mTagView setBackgroundColor:HEXCOLOR(0x47d2ae)];
        [cell.mStateLab setBackgroundColor:HEXCOLOR(0x47d2ae)];
        [cell.mStateLab setText:@"已结束"];
    }
    [cell.mTitleLab setText:@"报修"];
    [cell.mTitleLab setText:dic[@"info"]];
    [cell.mSubtitleLab setText:dic[@"info"]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaintenanceHistoryViewController*vc = (MaintenanceHistoryViewController *)[self GetSubordinateControllerForSelf];
    [vc goToHistoryContentViewControllerWith:mArray[indexPath.row]];
}

@end
