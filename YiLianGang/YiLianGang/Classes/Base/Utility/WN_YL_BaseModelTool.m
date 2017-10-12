//
//  WN_YL_BaseModelTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/7/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WN_YL_BaseModelTool.h"
static WN_YL_BaseModelTool *baseModelTool;
@interface WN_YL_BaseModelTool()
@property(nonatomic,strong) NSMutableArray *baseControllerArray;
@property(nonatomic,strong) NSMutableArray *tabTitleArray;
@property(nonatomic,strong) NSMutableArray *tabImageArray;
@property(nonatomic,strong) NSMutableArray *tabSelectedImageArray;
@property(nonatomic,strong) WN_YL_BaseTabController *baseTabBarController;
@end
@implementation WN_YL_BaseModelTool
+(id)sharedBaseModelTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseModelTool = [[WN_YL_BaseModelTool alloc]init];
    });
    return baseModelTool;
}
-(void)resetArr{
    self.baseControllerArray = nil;
    self.tabTitleArray = nil;
    self.tabImageArray = nil;
    self.tabSelectedImageArray = nil;
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(self.baseTabBarController)));
    self.baseTabBarController = nil;
    
}
-(void)addBaseTabControllerInfo:(WN_YL_BaseTabControllerInfo *)baseTabControllerInfo{
    [self.baseControllerArray addObject:baseTabControllerInfo.viewController];
    [self.tabTitleArray addObject:baseTabControllerInfo.title];
    [self.tabImageArray addObject:baseTabControllerInfo.image];
    [self.tabSelectedImageArray addObject:baseTabControllerInfo.selectedImage];
    
}
-(WN_YL_BaseTabController*)creatTabBarControllerWithArray:(NSArray<WN_YL_BaseTabControllerInfo*>*)array{
    [self.baseControllerArray removeAllObjects];
    [self.tabTitleArray removeAllObjects];
    [self.tabImageArray removeAllObjects];
    [self.tabSelectedImageArray removeAllObjects];
    
    for (WN_YL_BaseTabControllerInfo *info in array) {
        [self addBaseTabControllerInfo:info];
    }
    self.baseTabBarController = [WN_YL_BaseTabController new];
    return self.baseTabBarController;
}
- (NSMutableArray *)baseControllerArray {
    if(_baseControllerArray == nil) {
        _baseControllerArray = [[NSMutableArray alloc] init];
    }
    return _baseControllerArray;
}

- (NSMutableArray *)tabTitleArray {
    if(_tabTitleArray == nil) {
        _tabTitleArray = [[NSMutableArray alloc] init];
    }
    return _tabTitleArray;
}

- (NSMutableArray *)tabImageArray {
    if(_tabImageArray == nil) {
        _tabImageArray = [[NSMutableArray alloc] init];
    }
    return _tabImageArray;
}
- (NSMutableArray *)tabSelectedImageArray {
    if(_tabSelectedImageArray == nil) {
        _tabSelectedImageArray = [[NSMutableArray alloc] init];
    }
    return _tabSelectedImageArray;
}
@end
