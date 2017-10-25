//
//  WNPageView.m
//  ScrollPageView
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WNPageView.h"
#define SegementHeight 44
#define SegementLineHeight 3
#define SegementMargin 15
@interface WNPageView()<UIScrollViewDelegate>

@property(nonatomic,strong) NSArray *titleArr;
@property(nonatomic,strong) NSArray *controllers;

@property(nonatomic,strong) UIScrollView *pageScrollView;
@property(nonatomic,strong) UIScrollView *segmentScrollView;
@property(nonatomic,weak) UIViewController *viewController;

@property(nonatomic,assign) CGFloat segMaxX;

@end
@implementation WNPageView

-(instancetype)init{
    if (self = [super init]) {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.pageScrollView];//显示信息设备列表
    [self addSubview:self.segmentScrollView];
    
    
}

-(instancetype)initWithFrame:(CGRect)frame withNameArrayTitle:(NSArray *)titleArr controllers:(NSArray *)controllers delegate:(id<WNPageViewDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"测试view高度：%f",self.frame.size.height);

        self.currentPage = 0;
        self.segMaxX = 0;
        [self addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionOld context:nil];
        self.titleArr = titleArr;
        self.controllers = controllers;
        self.titleColor = [UIColor colorWithRed:0.1758 green:0.1757 blue:0.1758 alpha:1.0];
        self.titleSelectedColor = [UIColor blackColor];
        self.segementLineColor = [UIColor blackColor];
        self.segementBackgroundColor = [UIColor colorWithRed:0.9508 green:0.9507 blue:0.9507 alpha:1.0];
        self.pageViewBackgroundColor = [UIColor whiteColor];
        self.isSegementTapMakeControllerChangeAnimated = YES;
        self.delegate = delegate;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(titleArrayWithPageView:)]&&[self.delegate respondsToSelector:@selector(ControllersWithPageView:)]) {
                self.titleArr = [self.delegate titleArrayWithPageView:self];
                self.controllers = [self.delegate ControllersWithPageView:self];
            }
            if ([self.delegate respondsToSelector:@selector(settingsOfStyleWithPageView:)]) {
                [self.delegate settingsOfStyleWithPageView:self];
            }
        }
        [self awakeFromNib];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"currentPage"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
}

- (UIScrollView *)pageScrollView {
	if(_pageScrollView == nil) {
//        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SegementHeight, self.frame.size.width, self.frame.size.height-SegementHeight)];原
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SegementHeight, self.frame.size.width, self.frame.size.height-SegementHeight)];
        _pageScrollView.backgroundColor = self.pageViewBackgroundColor;
        for (int i = 0; i<self.controllers.count; i++) {
            UIViewController *vc = self.controllers[i];
            [self.viewController addChildViewController:vc];
            vc.view.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height-SegementHeight-50);
            [_pageScrollView addSubview:vc.view];
            NSLog(@"测试view高度：%f",self.frame.size.height);
            NSLog(@"测试高度：%f,%f",vc.view.frame.size.width,vc.view.frame.size.height);
        }
        //_pageScrollView.contentSize = CGSizeMake(self.controllers.count*self.frame.size.width, self.frame.size.height-SegementHeight);
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.scrollEnabled = YES;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        
        _pageScrollView.delegate = self;
    }
    return _pageScrollView;
}
-(void)setPageEnable:(BOOL)pageEnable{
    if (self.pageScrollView) {
        self.pageScrollView.scrollEnabled = pageEnable;
    }
}
#pragma mark ScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger pageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self setButtonLineAtIndex:pageIndex];
}
/**获取view的viewController*/
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

- (UIScrollView *)segmentScrollView {
	if(_segmentScrollView == nil) {
		_segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, SegementHeight)];
        CGFloat buttonX = 0;
        //标题
        _segmentScrollView.backgroundColor = self.segementBackgroundColor;
        for (int i = 0; i<self.titleArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            CGSize size = [button.titleLabel sizeThatFits:CGSizeMake(102, SegementHeight)];
//            CGFloat buttonWidth = ((NSString*)self.titleArr[i]).length*17+SegementMargin*2;
            CGFloat buttonWidth = size.width+SegementMargin*2;
            if (buttonWidth>102+SegementMargin*2) {
                buttonWidth=102+SegementMargin*2;
            }
            button.frame = CGRectMake(buttonX+SegementMargin, 0, buttonWidth-SegementMargin*2, SegementHeight-SegementLineHeight);
            
            button.tag = 200+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentScrollView addSubview:button];
            if (i==(int)(self.currentPage)) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(SegementMargin+buttonX, SegementHeight-SegementLineHeight, buttonWidth-SegementMargin*2, SegementLineHeight)];
                view.backgroundColor = self.segementLineColor;
                view.tag = 150;
                [_segmentScrollView addSubview:view];
            }
            buttonX = buttonX + buttonWidth;
        }
        _segmentScrollView.contentSize = CGSizeMake(buttonX, 0);
        self.segMaxX = buttonX;
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
    
    }
	return _segmentScrollView;
}
#pragma mark - 点击上面的默认分组，二层等
-(void)buttonClick:(UIButton*)button{
    if ((button.tag - 200) == (long)self.currentPage) {
        return;
    }
    
    [self setButtonLineAtIndex:(NSUInteger)(button.tag-200)];
    
    
    //滚动pageView
    [self.pageScrollView setContentOffset:CGPointMake(self.currentPage*self.frame.size.width, 0) animated:self.isSegementTapMakeControllerChangeAnimated];
}

-(void)setButtonLineAtIndex:(NSUInteger)index{
    self.currentPage = index;
    UIButton *button;
    for (UIView *view in _segmentScrollView.subviews) {
        if (![view isKindOfClass:[UIButton class]]&&view.tag == 150) {
            
            view.tag = 151;
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [view removeFromSuperview];
                });
            }];
        }
        if ([view isKindOfClass:[UIButton class]]&&view.tag == 200+index) {
            button = (UIButton*)view;
        }
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, SegementHeight-SegementLineHeight, button.frame.size.width, SegementLineHeight)];
    view.backgroundColor = self.segementLineColor;
    view.tag = 150;
    view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(view.frame.origin.x+view.frame.size.width/2>self.frame.size.width/2 && view.frame.origin.x+view.frame.size.width/2<self.segmentScrollView.contentSize.width-self.frame.size.width/2
               && self.segMaxX>self.frame.size.width){
                [self.segmentScrollView setContentOffset:CGPointMake(view.frame.origin.x-self.frame.size.width/2+view.frame.size.width/2, 0) animated:YES];
            
            }else if(view.frame.origin.x+view.frame.size.width/2<=self.frame.size.width/2 ){
                [self.segmentScrollView setContentOffset:CGPointMake(0,0) animated:YES];
            }else if(self.segMaxX<=self.frame.size.width){
                [self.segmentScrollView setContentOffset:CGPointMake(0,0) animated:YES];
            }else{
                [self.segmentScrollView setContentOffset:CGPointMake(self.segmentScrollView.contentSize.width-self.frame.size.width,0) animated:YES];
            }
        });
    }];
    [self.segmentScrollView addSubview:view];
    if ([self.delegate respondsToSelector:@selector(pageViewDidTurnToPageindex:)]) {
        [self.delegate pageViewDidTurnToPageindex:index];
    }
}
@end
