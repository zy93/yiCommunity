//
//  WNPageView.h
//  ScrollPageView
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WNPageView;
@protocol WNPageViewDelegate<NSObject>
@optional
/**设置pageview，可不用*/
-(NSArray*)titleArrayWithPageView:(WNPageView*)pageView;
-(NSArray*)ControllersWithPageView:(WNPageView*)pageView;
/**设置pageview属性*/
-(void)settingsOfStyleWithPageView:(WNPageView*)pageView;
/**翻到了第几页*/
-(void)pageViewDidTurnToPageindex:(NSUInteger)index;
@end
@interface WNPageView : UIView

-(instancetype)initWithFrame:(CGRect)frame withNameArrayTitle:(NSArray*)titleArr controllers:(NSArray*)controllers  delegate:(id<WNPageViewDelegate>)delegate;
@property(nonatomic,weak) id<WNPageViewDelegate> delegate;

/**一些设置*/
@property(nonatomic,assign) NSUInteger currentPage;
@property(nonatomic,strong) UIColor *titleColor;
@property(nonatomic,strong) UIColor *titleSelectedColor;
@property(nonatomic,strong) UIColor *segementLineColor;
@property(nonatomic,assign) BOOL isSegementTapMakeControllerChangeAnimated;

@property(nonatomic,strong) UIColor *segementBackgroundColor;
@property(nonatomic,strong) UIColor *pageViewBackgroundColor;

-(void)setPageEnable:(BOOL)pageEnable;

@end
