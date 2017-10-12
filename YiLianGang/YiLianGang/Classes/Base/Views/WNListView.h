//
//  WNListView.h
//  MenuTest
//
//  Created by Way_Lone on 16/9/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ListBlock) (NSUInteger index);
@interface WNListView : UIView
+(instancetype)listViewWithArrayStr:(NSArray*)strArr acordingFrameInScreen:(CGRect)frame superView:(UIView*)superView clickResponse:(ListBlock)listBlock;
@property(nonatomic,copy) ListBlock listBlock;
@property(nonatomic,strong) NSArray *listArr;
@property(nonatomic,assign) CGRect frameAcording;
@property(nonatomic,strong) UIColor *listBackgroundColor;
@end
