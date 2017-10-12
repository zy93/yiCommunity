//
//  SelectView.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/5.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectView;
@protocol SelectViewDelegate<NSObject>
-(void)selectView:(SelectView*)selectView didSelectRow:(NSUInteger)row string:(NSString*)str;
@end
@interface SelectView : UIView
+(instancetype)selectViewWithTableListArray:(NSArray *)listArr dictIdentify:(NSString*)identify withFrame:(CGRect)frame;
@property(nonatomic,weak) id<SelectViewDelegate> selectDelegate;
@end
