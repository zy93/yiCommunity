//
//  TDSCell.m
//  CYPA
//
//  Created by 张雨 on 2017/5/12.
//  Copyright © 2017年 HDD. All rights reserved.
//

#import "TDSCell.h"
#import "Header.h"


typedef NS_ENUM(NSInteger, TDS_LEVEL) {
    TDS_LEVEL_LOW = 1,
    TDS_LEVEL_MIDDLE,
    TDS_LEVEL_HIGH,
};

@interface TDSCell()
@property (nonatomic, assign) TDS_LEVEL mLevel;
@property (nonatomic, strong) UILabel *mLowLab;
@property (nonatomic, strong) UILabel *mMiddleLab;
@property (nonatomic, strong) UILabel *mHighLab;
@property (nonatomic, strong) UILabel *waterQualityLabel;
@end


@implementation TDSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.contentView.backgroundColor = [UIColor blueColor];
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
    self.mBGImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"刻度"]];
    [self.contentView addSubview:self.mBGImage];
    
    UIImage *image = [UIImage imageNamed:@"指针"];
//    UIImage *image1 = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
    self.mPointerImage = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:self.mPointerImage];
    
    self.mLowLab = [[UILabel alloc] init];
    self.mLowLab.text = @"差";
    self.mLowLab.textColor = UIColorHEX(0xfbbc06);
    [self.contentView addSubview:self.mLowLab];
    
    self.mMiddleLab = [[UILabel alloc] init];
    self.mMiddleLab.text = @"中";
    self.mMiddleLab.textColor = UIColorHEX(0xf8a307);
    [self.contentView addSubview:self.mMiddleLab];
    
    self.mHighLab = [[UILabel alloc] init];
    self.mHighLab.text = @"优";
    self.mHighLab.textColor = UIColorHEX(0xd75b07);
    [self.contentView addSubview:self.mHighLab];
    
    self.waterQualityLabel = [[UILabel alloc] init];
    self.waterQualityLabel.text = @"水质";
    self.waterQualityLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.waterQualityLabel];
    
}

-(void)setNumber:(NSInteger)number
{
    _number = number;
    if(_number>75){
        self.mLevel = TDS_LEVEL_LOW;
    }
    else if (_number>50) {
        self.mLevel = TDS_LEVEL_MIDDLE;
    }
    else {
        self.mLevel = TDS_LEVEL_HIGH;
    }
    [self setNeedsUpdateConstraints];
}

-(void)layoutSubviews
{
    [self.mBGImage mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(57, 35, 64, 35));
        //CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
        make.top.equalTo(self.contentView).with.offset(57);
        make.left.equalTo(self.contentView).with.offset(35);
        make.bottom.equalTo(self.waterQualityLabel.mas_top).with.offset(-30);
       // make.bottom.equalTo(self.contentView).with.offset(-64);
        make.right.equalTo(self.contentView).with.offset(-35);
    }];
    
    [self.mPointerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mBGImage.mas_bottom);
        make.centerX.mas_equalTo(self.mBGImage.mas_centerX).with.offset(5);
    }];
    
    [self.mLowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mBGImage.mas_left);
        make.bottom.mas_equalTo(self.mBGImage.mas_bottom);
    }];
    
    [self.mMiddleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mBGImage.mas_centerX);
        make.bottom.mas_equalTo(self.mBGImage.mas_top);
    }];
    
    [self.mHighLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mBGImage.mas_right);
        make.bottom.mas_equalTo(self.mBGImage.mas_bottom);
    }];
    
    [self.waterQualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mBGImage.mas_centerX);
       // make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
}

-(void)updateConstraints
{
    [super updateConstraints];
    if(_number>75){
        self.mLevel = TDS_LEVEL_LOW;
        UIImage *image = self.mPointerImage.image;
        UIImage *image1 = [UIImage imageWithCGImage:image.CGImage scale:2.f orientation:UIImageOrientationLeft];

        [self.mPointerImage setImage: image1];
        [self.mPointerImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mBGImage.mas_centerX).with.offset(5);
            make.bottom.mas_equalTo(self.mBGImage.mas_bottom);
        }];
    }
    else if (_number>50) {
        self.mLevel = TDS_LEVEL_MIDDLE;
    }
    else {
        self.mLevel = TDS_LEVEL_HIGH;
        UIImage *image = self.mPointerImage.image;
        UIImage *image1 = [UIImage imageWithCGImage:image.CGImage scale:2.f orientation:UIImageOrientationRight];

        [self.mPointerImage setImage: image1];
        [self.mPointerImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mBGImage.mas_centerX).with.offset(-5);
            make.bottom.mas_equalTo(self.mBGImage.mas_bottom);
        }];
    }
}

@end
