//
//  WOTShortcutView.m
//  YiLianGang
//
//  Created by 张雨 on 2017/10/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "WOTShortcutView.h"
#import "ShortcutTool.h"
#import "ShortcutButton.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+KR.h"


#define totoNumber 5  //总数据体量大于5的奇数 3的话会递归自己到崩溃
#define shortcutSpace 40 //图标间隔

@implementation WOTShortcutView 
{
    NSArray *mShortcutServiceList;
    CGFloat mScrollIconWidth;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadShortcutService];
    }
    return self;
}

-(void)loadShortcutService
{
    [self clearScrollViewSubviews];
    
    NSMutableArray *totoSerArr = [NSMutableArray new];
    
    ShortcutTool *tool = [ShortcutTool shareShortcutTool];
    mShortcutServiceList = [tool getAllShortcut];
    mScrollIconWidth = 75;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    
    for (int i = 0; i<totoNumber; i++) {
        [totoSerArr addObjectsFromArray:mShortcutServiceList];
    }
    
    int i = 0;
    for (NSString* pData in totoSerArr) {
        [self addData:pData i:i];
        i++;
    }
    CGFloat x = (totoSerArr.count/totoNumber) *(mScrollIconWidth)+(shortcutSpace/2);
    [self setContentOffset:CGPointMake(x, 0)];
   // UIImage *view = [[UIImage alloc] init];
    
}

-(void)addData:(NSString *)pData i:(int)i
{
    CGFloat x = i*(mScrollIconWidth+10)+shortcutSpace;
    
    ShortcutButton *pBackgroupView = [ShortcutButton buttonWithType:UIButtonTypeCustom];
    pBackgroupView.tag = 1000+i;
    NSLog(@"===%f",CGRectGetHeight(self.frame));
    [pBackgroupView setFrame:CGRectMake(x, 0, mScrollIconWidth, mScrollIconWidth)];
    
    pBackgroupView.center = CGPointMake(x, CGRectGetHeight(self.frame)/2);
    
    [pBackgroupView setImage:[UIImage imageNamed:pData] forState:UIControlStateNormal];
    [pBackgroupView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@选中",pData]] forState:UIControlStateHighlighted];
    [pBackgroupView addTarget:self action:@selector(clickService:) forControlEvents:UIControlEventTouchUpInside];
    [pBackgroupView addCustomTarget:self action:@selector(clickRemoveService:) events:ShortcutCustomEventsRemove];
    [pBackgroupView addCustomTarget:self action:@selector(logPressService:) events:ShortcutCustomEventsLongpress];
    pBackgroupView.serviceName = pData;
    [self addSubview:pBackgroupView];
    
    [self setContentSize: CGSizeMake(x + mScrollIconWidth, mScrollIconWidth)];
}

-(void)clearScrollViewSubviews
{
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
}

-(void)clickService:(ShortcutButton *)sender
{
    if ([sender.serviceName isEqualToString:@"门禁"]) {
//        [((HomePageController *)self.viewController) goToMaintenanceViewController];
        if ([self.shortcutViewDelegate respondsToSelector:@selector(JumpinterfaceWithButtonMessage:)]) {
            [self.shortcutViewDelegate JumpinterfaceWithButtonMessage:@"门禁"];
        }
    }
    else if ([sender.serviceName isEqualToString:@"维修"]) {
//        [((HomePageController *)self.viewController) goToPrintViewController];
        if ([self.shortcutViewDelegate respondsToSelector:@selector(JumpinterfaceWithButtonMessage:)]) {
            [self.shortcutViewDelegate JumpinterfaceWithButtonMessage:@"维修"];
        }
    }
    else if ([sender.serviceName isEqualToString:@"物业缴费"]) {
//        [((HomePageController *)self.viewController) goToDDController];
        if ([self.shortcutViewDelegate respondsToSelector:@selector(JumpinterfaceWithButtonMessage:)]) {
            [self.shortcutViewDelegate JumpinterfaceWithButtonMessage:@"物业缴费"];
        }
        
    }else if ([sender.serviceName isEqualToString:@"北菜园"])
    {
        if ([self.shortcutViewDelegate respondsToSelector:@selector(JumpinterfaceWithButtonMessage:)]) {
            [self.shortcutViewDelegate JumpinterfaceWithButtonMessage:@"北菜园"];
        }
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
    for (ShortcutButton *btn in self.subviews) {
        [btn showDeleteBtn];
    }
}

-(void)hiddenShortcutServiceBtnDeleBtn
{
    for (ShortcutButton *btn in self.subviews) {
        [btn hiddenDeleteBtn];
    }
}


-(void)goToTabBarWithIndex:(int)index{
//    [self.viewController.tabBarController.tabBar setHidden:NO];
//    [self.viewController.navigationController setNavigationBarHidden:NO];
//    self.viewController.tabBarController.selectedIndex=index;
}

#pragma mark - Scroll Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    CGFloat minX = (self.subviews.count/totoNumber) * (mScrollIconWidth)+(shortcutSpace/2);
    CGFloat maxX = (self.subviews.count-(self.subviews.count/totoNumber))*mScrollIconWidth;
    
    if (offset.x < minX) {
        offset.x = (minX+offset.x);
    }
    else if (offset.x > maxX) {
        offset.x = offset.x - minX;
    }
    [self setContentOffset:offset];
}

@end
