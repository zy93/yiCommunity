//
//  ServiceView.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/24.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ServiceViewDelegate<NSObject>
-(void)serviceViewDidLongpressIndex:(NSInteger)index;
-(void)serviceViewDidSelectIndex:(NSInteger)index;
@end
@interface ServiceView : UIView
@property(nonatomic,weak) id<ServiceViewDelegate> delegate;
@property (nonatomic, assign) BOOL isPro;

-(NSArray *)getAllService;
@end
