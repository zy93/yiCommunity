//
//  WN_YL_BaseModelTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/7/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WN_YL_BaseTabControllerInfo.h"
#import "WN_YL_BaseTabController.h"
@interface WN_YL_BaseModelTool : NSObject
@property(nonatomic,strong,readonly) NSMutableArray *baseControllerArray;
@property(nonatomic,strong,readonly) NSMutableArray *tabTitleArray;
@property(nonatomic,strong,readonly) NSMutableArray *tabImageArray;
@property(nonatomic,strong,readonly) NSMutableArray *tabSelectedImageArray;
@property(nonatomic,assign) NSUInteger selectIndex;
@property(nonatomic,strong) UIColor *tabBarBackGroundColor;
@property(nonatomic,strong) UIColor *tabTintColor;
@property(nonatomic,strong) UIColor *tabSelectTintColor;
@property(nonatomic,assign) BOOL isOnlyImage;
-(void)resetArr;
+(instancetype)sharedBaseModelTool;
-(void)addBaseTabControllerInfo:(WN_YL_BaseTabControllerInfo*)baseTabControllerInfo;

-(WN_YL_BaseTabController*)creatTabBarControllerWithArray:(NSArray<WN_YL_BaseTabControllerInfo*>*)array;




@end
