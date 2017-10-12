//
//  ServiceView.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/24.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//
#import "ServiceView.h"
#import "ServiceTool.h"
#import "ServiceCollectionViewCell.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define Margin 1

@interface ServiceView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,assign) CGFloat cellWidth;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) NSArray *serviceArray;
@end
@implementation ServiceView
-(instancetype)init{
    if (self = [super init]) {
        [self awakeFromNib];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.9951 green:0.995 blue:0.995 alpha:0.4];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.cellWidth = (Main_Screen_Width)/3;
    self.cellHeight = self.cellWidth*0.9;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 6;
    flowLayout.minimumLineSpacing = 6;
    self.collectionView.collectionViewLayout = flowLayout;
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.directionalLockEnabled = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ServiceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ServiceCell"];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.serviceArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCell" forIndexPath:indexPath];
    NSUInteger indexX = indexPath.row%3;
    NSUInteger indexY = indexPath.row/3;
    cell.frame = CGRectMake(indexX*self.cellWidth, indexY*self.cellHeight, self.cellWidth, self.cellHeight);
    ServiceInfo *info = self.serviceArray[indexPath.row];
    cell.serviceLabel.text = info.serviceName;
    cell.serviceLabel.font = [UIFont systemFontOfSize:13];
    cell.serviceImageView.image = info.serviceImage;
    UIView *bgView = [[UIView alloc]initWithFrame:cell.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0.3637 green:0.6901 blue:0.6112 alpha:0.6];
    cell.selectedBackgroundView = bgView;
    //longpress
    UILongPressGestureRecognizer* longgs=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    [cell addGestureRecognizer:longgs];//为cell添加手势
    longgs.minimumPressDuration=1.0;//定义长按识别时长
    longgs.view.tag=indexPath.row;//将手势和cell的序号绑定
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.cellWidth, self.cellHeight);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if ([self.delegate respondsToSelector:@selector(serviceViewDidSelectIndex:)]) {
        [self.delegate serviceViewDidSelectIndex:indexPath.row];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)longpress:(UILongPressGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(serviceViewDidSelectIndex:)]) {
        [self.delegate serviceViewDidLongpressIndex:gesture.view.tag];
    }
}

-(NSArray *)getAllService
{
    return _serviceArray;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
}
- (NSArray *)serviceArray {
	if(_serviceArray == nil) {
        if (_isPro) {
            _serviceArray = [[ServiceTool sharedServiceTool] getALLProperty];
        }
        else {
            _serviceArray = [[ServiceTool sharedServiceTool] getAllService];
        }
	}
	return _serviceArray;
}

@end
