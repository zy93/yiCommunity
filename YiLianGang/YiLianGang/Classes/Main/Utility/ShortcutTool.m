//
//  ShortcutTool.m
//  YiLianGang
//
//  Created by 张雨 on 2017/4/1.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "ShortcutTool.h"
#import "LoginTool.h"

@implementation ShortcutTool

+(ShortcutTool *)shareShortcutTool
{
    static ShortcutTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ShortcutTool alloc] init];
    });
    return tool;
}

-(NSArray *)getAllShortcut
{
    mUserPhone = [LoginTool sharedLoginTool].userTel;
    NSArray *allShortcut = [[NSUserDefaults standardUserDefaults] objectForKey:mUserPhone];
    if (allShortcut.count <=0) {
        allShortcut = [self createDefaultsShortcut];
    }
    
    return allShortcut;
}

-(void)addShortcutByShortcutName:(NSString *)shortcutName
{
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:mUserPhone] mutableCopy];
    [arr addObject:shortcutName];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:mUserPhone];
}

-(void)removeShortcutByShortcutName:(NSString *)shortcutName
{
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:mUserPhone] mutableCopy];
    [arr removeObject:shortcutName];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:mUserPhone];
}

-(NSArray *)createDefaultsShortcut
{
    NSArray * defAllShortcut = @[@"报事报修",@"云打印",@"丁丁停车"];
    //
    [[NSUserDefaults standardUserDefaults] setValue:defAllShortcut forKey:mUserPhone];
    return defAllShortcut;
}

@end
