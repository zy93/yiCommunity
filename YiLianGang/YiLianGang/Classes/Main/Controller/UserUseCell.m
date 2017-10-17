//
//  UserUseCell.m
//  CYPA
//
//  Created by 张雨 on 2017/5/12.
//  Copyright © 2017年 HDD. All rights reserved.
//

#import "UserUseCell.h"
#import "Header.h"


@implementation UserUseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    self.mFluxSumBtn = [[UIButton alloc] init];
    [self.mFluxSumBtn setImage:[UIImage imageNamed:@"水_icon"] forState:UIControlStateNormal];
    [self.mFluxSumBtn setTitle:@"水量" forState:UIControlStateNormal];
    [self.mFluxSumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.mFluxSumBtn];
    
    self.mLine1Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [self.contentView addSubview:self.mLine1Img];
    
    self.mFluxSumLab = [[UILabel alloc] init];
    self.mFluxSumLab.text = @"我的老天爷啊" ;
    self.mFluxSumLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.mFluxSumLab];
    
    //
    self.mPriceBtn = [[UIButton alloc] init];
    [self.mPriceBtn setImage:[UIImage imageNamed:@"水价_icon"] forState:UIControlStateNormal];
    [self.mPriceBtn setTitle:@"水价" forState:UIControlStateNormal];
    [self.mPriceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.mPriceBtn];
    
    self.mLine2Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [self.contentView addSubview:self.mLine2Img];
    
    self.mPriceLab = [[UILabel alloc] init];
    self.mPriceLab.text = @"￥123" ;
    self.mPriceLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.mPriceLab];
    
    //
    self.mBalanceBtn = [[UIButton alloc] init];
    [self.mBalanceBtn setImage:[UIImage imageNamed:@"余额_icon"] forState:UIControlStateNormal];
    [self.mBalanceBtn setTitle:@"余额" forState:UIControlStateNormal];
    [self.mBalanceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.mBalanceBtn];
    
    self.mLine3Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [self.contentView addSubview:self.mLine3Img];
    
    self.mBalanceLab = [[UILabel alloc] init];
    self.mBalanceLab.text = @"2234元" ;
    self.mBalanceLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.mBalanceLab];
    //
    self.mChargeBtn = [[UIButton alloc] init];
    [self.mChargeBtn setImage:[UIImage imageNamed:@"充值_icon"] forState:UIControlStateNormal];
    [self.mChargeBtn addTarget:self action:@selector(payMent) forControlEvents:UIControlEventTouchDown];
    [self.mChargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [self.mChargeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.mChargeBtn];
    
    self.mLine4Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line"]];
    [self.contentView addSubview:self.mLine4Img];
    
    
    
}

-(void)layoutSubviews
{
    [self.mFluxSumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SIZE_SCALE_IPHONE6(20));
        make.left.mas_equalTo(SIZE_SCALE_IPHONE6(35));
        make.size.mas_equalTo(CGSizeMake(111, 46));
    }];
    [self.mLine1Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mFluxSumBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mFluxSumBtn.mas_left);
        make.width.mas_equalTo(self.mFluxSumBtn.mas_width);
        make.height.mas_equalTo(1);
    }];
    [self.mFluxSumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mLine1Img.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mFluxSumBtn.mas_left);
        
        make.width.mas_equalTo(self.mFluxSumBtn.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    //
    [self.mPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mFluxSumBtn.mas_top);
        make.right.mas_equalTo(SIZE_SCALE_IPHONE6(-35));
        make.width.mas_equalTo(self.mFluxSumBtn);
        make.height.mas_equalTo(self.mFluxSumBtn);
    }];
    [self.mLine2Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mPriceBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mPriceBtn.mas_left);
        make.width.mas_equalTo(self.mPriceBtn.mas_width);
        make.height.mas_equalTo(1);
    }];
    [self.mPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mPriceBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mPriceBtn.mas_left);
        make.width.mas_equalTo(self.mPriceBtn.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    //
    [self.mBalanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mFluxSumLab.mas_bottom).with.offset(SIZE_SCALE_IPHONE6(54));;
        make.left.mas_equalTo(self.mFluxSumLab.mas_left);
        make.left.mas_equalTo(self.mFluxSumLab.mas_left);
        make.width.mas_equalTo(self.mFluxSumLab.mas_width);
    }];
    [self.mLine3Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mBalanceBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mBalanceBtn.mas_left);
        make.width.mas_equalTo(self.mBalanceBtn.mas_width);
        make.height.mas_equalTo(1);
    }];
    [self.mBalanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mLine3Img.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mLine3Img.mas_left);
        make.width.mas_equalTo(self.mLine3Img.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    //
    [self.mChargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mLine3Img.mas_centerY).with.offset(-20);
        make.left.mas_equalTo(self.mPriceBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(111, 45));
    }];
    [self.mLine4Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mChargeBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.mChargeBtn.mas_left);
        make.width.mas_equalTo(self.mChargeBtn.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    
}

#pragma mark - 水量
-(void)setFluxSum:(NSInteger)fluxSum
{
    _fluxSum = fluxSum;
    [self.mFluxSumLab setText:[NSString stringWithFormat:@"已用：%ldL",fluxSum/1000]];
    
}

#pragma mark - 价格
-(void)setPrice:(CGFloat)price
{
    _price = price;
    [self.mPriceLab setText:[NSString stringWithFormat:@"%.2f元/L",price]];
}

#pragma mark -
-(void)setBalance:(CGFloat)balance
{
    _balance = balance;
    NSInteger surplusWater;
    if (_price == 0) {
        surplusWater = 0;
    } else {
       surplusWater = balance/_price;
    }
    
    [self.mBalanceLab setText:[NSString stringWithFormat:@"%.2f元(%ldL)",balance,surplusWater]];
}

-(void)payMent
{
//    NSLog(@"支付！！");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayNotification" object:nil];
}

@end
