//
//  HomePageView.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/16.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "HomePageView.h"
/*
#import "HomePageController.h"
#import "MsgTool.h"
#import "WeatherTool.h"
#import "UIImageView+WebCache.h"
#import "ShortcutTool.h"
#import "LoginTool.h"
#import "ShortcutButton.h"
#import "MBProgressHUD+KR.h"

@class HomePageController;

#define totoNumber 5  //总数据体量大于5的奇数 3的话会递归自己到崩溃
*/

@interface HomePageView()
/*
@property (weak, nonatomic) IBOutlet UIButton *buttonLU;
@property (weak, nonatomic) IBOutlet UIButton *buttonLD;
@property (weak, nonatomic) IBOutlet UIButton *buttonRU;
@property (weak, nonatomic) IBOutlet UIButton *buttonRD;
@property (weak, nonatomic) IBOutlet UIButton *personalInfoButton;
@property (weak, nonatomic) IBOutlet UIImageView *yellowBallImageView;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
@property (weak, nonatomic) IBOutlet UILabel *msgNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureRange;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@property (nonatomic, assign) CGFloat mScrollIconWidth;

@property(nonatomic,weak) UIViewController *viewController;

@property(nonatomic,strong) WeatherTool *weatherTool;
*/
//新界面
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottonImageView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@end
@implementation HomePageView

/*
- (IBAction)clickMsgButton:(id)sender {
    [[MsgTool sharedMsgTool]setNewMsgNum:[MsgTool sharedMsgTool].newMsgNum+1];
}

- (IBAction)clickPersonalInfoButton:(id)sender {
    [self goToTabBarWithIndex:4];
}
- (IBAction)clickButtonLU:(id)sender {
    [self goToTabBarWithIndex:3];
}
- (IBAction)clickButtonLD:(id)sender {
    [self goToTabBarWithIndex:1];
}
- (IBAction)clickButtonRU:(id)sender {
    [self goToTabBarWithIndex:2];
}
- (IBAction)clickButtonRD:(id)sender {
    [self goToShopViewController];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    MsgTool *msgTool = [MsgTool sharedMsgTool];
//    [_mScrollView setBackgroundColor:[UIColor clearColor]];
    [msgTool addObserver:self forKeyPath:@"newMsgNum" options:NSKeyValueObservingOptionOld context:nil];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(_mScrollView.frame)+ CGRectGetHeight(_mScrollView.frame)/2+self.mScrollIconWidth/3, CGRectGetWidth(self.frame), 30)];
    [bgView setImage:[UIImage imageNamed:@"service_bg"]];
    [self addSubview:bgView];
    
    [self refreshWeather];
    [self loadShortcutService];
}

//add view
-(void)loadShortcutService
{
    [self clearScrollViewSubviews];

    NSMutableArray *totoSerArr = [NSMutableArray new];
    
    ShortcutTool *tool = [ShortcutTool shareShortcutTool];
    mShortcutServiceList = [tool getAllShortcut];
    
    
    for (int i = 0; i<totoNumber; i++) {
        [totoSerArr addObjectsFromArray:mShortcutServiceList];
    }
    
    int i = 0;
    for (NSString* pData in totoSerArr) {
        [self addData:pData i:i];
        i++;
    }
    CGFloat x = (totoSerArr.count/totoNumber) * (self.mScrollIconWidth)+30;
    [_mScrollView setContentOffset:CGPointMake(x, 0)];
    
}


-(void)dealloc {
    
}


-(void)addData:(NSString *)pData i:(int)i
{
    int space = 30;
    CGFloat x = i*(self.mScrollIconWidth+10)+space;
    
    ShortcutButton *pBackgroupView = [ShortcutButton buttonWithType:UIButtonTypeCustom];
    pBackgroupView.tag = 1000+i;
//    NSLog(@"===%f",CGRectGetHeight(_mScrollView.frame));
    [pBackgroupView setFrame:CGRectMake(x, 0, self.mScrollIconWidth, self.mScrollIconWidth)];
    pBackgroupView.center = CGPointMake(x, CGRectGetHeight(_mScrollView.frame)/2);
    [pBackgroupView setImage:[UIImage imageNamed:pData] forState:UIControlStateNormal];
    [pBackgroupView addTarget:self action:@selector(clickService:) forControlEvents:UIControlEventTouchUpInside];
    [pBackgroupView addCustomTarget:self action:@selector(clickRemoveService:) events:ShortcutCustomEventsRemove];
    [pBackgroupView addCustomTarget:self action:@selector(logPressService:) events:ShortcutCustomEventsLongpress];
    pBackgroupView.serviceName = pData;
    [_mScrollView addSubview:pBackgroupView];
    
    [_mScrollView setContentSize: CGSizeMake(x + self.mScrollIconWidth, self.mScrollIconWidth)];
}

-(void)clearScrollViewSubviews
{
    for (id view in _mScrollView.subviews) {
        [view removeFromSuperview];
    }
}


-(void)clickService:(ShortcutButton *)sender
{
    if ([sender.serviceName isEqualToString:@"报事报修"]) {
        [((HomePageController *)self.viewController) goToMaintenanceViewController];
    }
    else if ([sender.serviceName isEqualToString:@"云打印"]) {
        [((HomePageController *)self.viewController) goToPrintViewController];
    }
    else if ([sender.serviceName isEqualToString:@"丁丁停车"]) {
        [((HomePageController *)self.viewController) goToDDController];

    }
    
}

-(void)clickRemoveService:(ShortcutButton *)sender
{
    if (mShortcutServiceList.count <=3) {
        [MBProgressHUD showError:@"最少保留3个快捷操作"];
        return;
    }
    [[ShortcutTool shareShortcutTool] removeShortcutByShortcutName:sender.serviceName];
    [self loadShortcutService];
}

-(void)logPressService:(ShortcutButton *)sender
{
    //show
    for (ShortcutButton *btn in _mScrollView.subviews) {
        [btn showDeleteBtn];
    }
}

-(void)hiddenShortcutServiceBtnDeleBtn
{
    for (ShortcutButton *btn in _mScrollView.subviews) {
        [btn hiddenDeleteBtn];
    }
}



-(void)goToTabBarWithIndex:(int)index{
    [self.viewController.tabBarController.tabBar setHidden:NO];
    [self.viewController.navigationController setNavigationBarHidden:NO];
    self.viewController.tabBarController.selectedIndex=index;
    
}

-(void)goToShopViewController
{
    [((HomePageController *)self.viewController) goToShopViewController];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == [MsgTool sharedMsgTool] && [keyPath isEqualToString:@"newMsgNum"]) {
        NSLog(@"get new msg %ld",(long)([MsgTool sharedMsgTool].newMsgNum));
        self.msgNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[MsgTool sharedMsgTool].newMsgNum];
        if ([MsgTool sharedMsgTool].newMsgNum==0) {
            [self.msgNumLabel setHidden:YES];
            [self.yellowBallImageView setHidden:YES];
        }else{
            [self.msgNumLabel setHidden:NO];
            [self.yellowBallImageView setHidden:NO];
        }
    }
}
-(void)weatherToolIsSuccess:(BOOL)isSuccess info:(WeatherInfo *)info{
    if (!isSuccess) {
        NSLog(@"天气获取失败");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@℃",info.temp];
        NSString *picURL = [[info.picURL stringByAppendingString:info.weatherIconNum]stringByAppendingPathExtension:@"png"];
        NSURL *url = [NSURL URLWithString:picURL];
        [self.weatherImageView sd_setImageWithURL:url];
        self.temperatureRange.text = [NSString stringWithFormat:@"%@~%@℃",info.minTemp,info.maxTemp];
        self.weekLabel.text = info.date;
        self.weatherLabel.text = info.weather;
        self.weatherConditionLabel.text = info.condition;
        self.locationLabel.text = info.location;
    });
    
}
-(void)refreshWeather{
    [self.weatherTool initializeLocationServiceWithResponse:^(NSString *city) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.weatherTool.city = city;
            [self.weatherTool sendWeatherRequest];
            self.weatherTool.delegate = self;
        });
    }];
//    [self.weatherTool sendWeatherRequest];
//    self.weatherTool.delegate = self;
}

-(void)refreshService
{
    [self loadShortcutService];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**获取view的viewController*/
/*
- (UIViewController *)findViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (UIViewController *)viewController {
	if(_viewController == nil) {
		_viewController = [self findViewController];
	}
	return _viewController;
}

- (WeatherTool *)weatherTool {
	if(_weatherTool == nil) {
		_weatherTool = [WeatherTool sharedWeatherTool];
	}
	return _weatherTool;
}

-(CGFloat)mScrollIconWidth
{
    return (SCREEN_WIDTH/3)-(20*[YYUtil GetLengthAdaptRate]);
}

#pragma mark - Scroll Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    CGFloat minX = (_mScrollView.subviews.count/totoNumber) * (self.mScrollIconWidth)+(30*[YYUtil GetLengthAdaptRate]) ;
    CGFloat maxX = (_mScrollView.subviews.count-(_mScrollView.subviews.count/totoNumber))*self.mScrollIconWidth;
    
    if (offset.x < minX) {
        offset.x = (minX+offset.x);
    }
    else if (offset.x > maxX) {
        offset.x = offset.x - minX;
    }
    [_mScrollView setContentOffset:offset];
}
*/
#pragma mark - 新界面start



@end
