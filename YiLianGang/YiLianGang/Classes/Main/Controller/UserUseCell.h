//
//  UserUseCell.h
//  CYPA
//
//  Created by 张雨 on 2017/5/12.
//  Copyright © 2017年 HDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserUseCell : UITableViewCell
@property (nonatomic, strong) UIButton *mFluxSumBtn;
@property (nonatomic, strong) UIImageView *mLine1Img;
@property (nonatomic, strong) UILabel *mFluxSumLab;

@property (nonatomic, strong) UIButton *mPriceBtn;
@property (nonatomic, strong) UIImageView *mLine2Img;
@property (nonatomic, strong) UILabel *mPriceLab;

@property (nonatomic, strong) UIButton *mBalanceBtn;
@property (nonatomic, strong) UIImageView *mLine3Img;
@property (nonatomic, strong) UILabel *mBalanceLab;

@property (nonatomic, strong) UIButton *mChargeBtn;
@property (nonatomic, strong) UIImageView *mLine4Img;

@property (nonatomic, assign) NSInteger fluxSum;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat balance;

@end
