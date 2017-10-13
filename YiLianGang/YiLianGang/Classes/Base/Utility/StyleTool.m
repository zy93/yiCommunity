//
//  StyleTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/16.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "StyleTool.h"
static StyleTool* styleTool;
@implementation StyleTool
+(instancetype)sharedStyleTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!styleTool) {
            styleTool = [StyleTool new];
        }
    });
    return styleTool;
}
-(StyleInfo*)sessionSyle{
    static StyleInfo *styleInfo;
    if (!styleInfo) {
        styleInfo = [StyleInfo new];
    }
    styleInfo.welcomeImage = [UIImage imageNamed:@"开机图"];
    //styleInfo.welcomeColor = [UIColor colorWithRed:0.0431 green:0.5765 blue:0.4824 alpha:1.0];
    //styleInfo.naviColor = [UIColor colorWithRed:0.1068 green:0.8264 blue:0.62 alpha:1.0];
    styleInfo.welcomeColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1];
    styleInfo.naviColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1];
    styleInfo.logoImage = [UIImage imageNamed:@"icon_ylg"];
    styleInfo.tabBarColor = [UIColor colorWithRed:0.9882 green:0.9843 blue:0.9765 alpha:1.0];
    styleInfo.tabBarTintColor = [UIColor colorWithRed:0.1697 green:0.1826 blue:0.179 alpha:1.0];
   // styleInfo.tabBarTintColor = [UIColor colorWithRed:35.0f/255.0f green:124.0f/255.0f blue:223.0f/255.0f alpha:1];
    styleInfo.tabBarSelectTintColor = styleInfo.welcomeColor;
    
    styleInfo.segmentLineColor = [UIColor colorWithRed:0.1068 green:0.8264 blue:0.62 alpha:1.0];
    styleInfo.headerColor = [UIColor colorWithRed:0.1068 green:0.8264 blue:0.62 alpha:1.0];
    styleInfo.hightlightColor = [UIColor colorWithRed:0.1068 green:0.8264 blue:0.62 alpha:1.0];
    return styleInfo;
}

@end
