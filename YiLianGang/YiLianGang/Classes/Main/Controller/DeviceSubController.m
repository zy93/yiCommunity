//
//  DeviceSubController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceSubController.h"
#import "DeviceCollectionViewCell.h"
#import "DeviceTool.h"
#import "UIImageView+WebCache.h"
#import "LoginTool.h"
#import "DeviceCarBoxController.h"
#import "DeviceBreathHouseController.h"
#import "DeviceCameraController.h"
#import "DeviceHomeFurnishController.h"
#import "DeviceFromGroupTool.h"
#import "WN_YL_RequestTool.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define Margin 1
@interface DeviceSubController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,assign) CGFloat cellWidth;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) NSArray *deviceArray;
@property(nonatomic,strong) NSNumber *groupId;
@property(nonatomic,strong) DeviceFromGroupTool *deviceTool;
@end

@implementation DeviceSubController
-(instancetype)initWithGroupId:(NSNumber *)groupId{
    if (self = [super init]) {
        self.groupId = groupId;
    }
    return self;
}
-(void)sendRequest{
    WS(weakSelf);
    self.deviceTool = [DeviceFromGroupTool new];
    [self.deviceTool sendRequestToGetAllDeviceWithGroupId:self.groupId Response:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (arr) {
                
                weakSelf.deviceArray = arr;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
            }
            
        });
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequest];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 6;
    flowLayout.minimumLineSpacing = 6;
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    

    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.9951 green:0.995 blue:0.995 alpha:0.4];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.cellWidth = (Main_Screen_Width)/3;
    self.cellHeight = self.cellWidth*0.9;

    self.collectionView.contentSize = CGSizeMake(self.cellWidth*3, (self.deviceArray.count%3==0?self.deviceArray.count/3:self.deviceArray.count/3+1)*self.cellHeight);
    [self.view addSubview:_collectionView];
    _collectionView.frame = self.view.bounds;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeviceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DeviceCell"];
    

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionView.frame = self.view.bounds;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"DeviceSubController dealloc");

}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceCell" forIndexPath:indexPath];
    NSUInteger indexX = indexPath.row%3;
    NSUInteger indexY = indexPath.row/3;
    cell.frame = CGRectMake(indexX*self.cellWidth, indexY*self.cellHeight, self.cellWidth, self.cellHeight);
    DeviceInfo *info = self.deviceArray[indexPath.row];
    NSString *imageStr = info.picUrl;
    
    NSString *imageFixedStr = [[imageStr stringByDeletingPathExtension]stringByAppendingString:[NSString stringWithFormat:@"1.%@", [imageStr pathExtension]]];
    if ([imageFixedStr containsString:@"123.56.197.113"]) {
        imageFixedStr = [[imageFixedStr stringByReplacingOccurrencesOfString:@"http:/123.56.197.113/" withString:HTTP_HOST]stringByReplacingOccurrencesOfString:@"http://123.56.197.113/" withString:HTTP_HOST];
    }
    [cell.deviceImageView sd_setImageWithURL:[NSURL URLWithString:imageFixedStr]];
    cell.deviceNameLabel.text = info.thingName;
    collectionView.contentSize = CGSizeMake(cell.frame.size.width*3, cell.frame.size.height*(self.deviceArray.count%3==0?self.deviceArray.count/3:self.deviceArray.count/3+1));
    UIView *bgView = [[UIView alloc]initWithFrame:cell.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0.3637 green:0.6901 blue:0.6112 alpha:0.6];
    cell.selectedBackgroundView = bgView;
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
    DeviceInfo *info = self.deviceArray[indexPath.row];
    //判断是否为海康威视
    if ([info.templateId containsString:@"海康威视"]) {
        DeviceCameraController *dcc = [UIStoryboard storyboardWithName:@"DeviceCameraController" bundle:nil].instantiateInitialViewController;
        dcc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为车载盒子
    else if([info.templateId containsString:@"四海万联"]){
        
        DeviceCarBoxController *dcbc = [UIStoryboard storyboardWithName:@"DeviceCarBoxController" bundle:nil].instantiateInitialViewController;
        dcbc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcbc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为会呼吸的家
    else if([info.templateId containsString:@"领耀东方"]){
        DeviceBreathHouseController *dcbc = [UIStoryboard storyboardWithName:@"DeviceBreathHouseController" bundle:nil].instantiateInitialViewController;
        dcbc.deviceInfo = info;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcbc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    //判断是否为智能家居
    else if([info.templateId containsString:@"睿恩科技"]){
        DeviceHomeFurnishController *dcbc = [UIStoryboard storyboardWithName:@"DeviceHomeFurnishController" bundle:nil].instantiateInitialViewController;
        dcbc.deviceInfo = info;
        
        
        
        
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:dcbc];
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if (self.mainController) {
            [self.mainController presentViewController:navi animated:YES completion:nil];
        }
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)deviceArray {
	if(_deviceArray == nil) {
		_deviceArray = [NSArray array];
	}
	return _deviceArray;
}



@end
