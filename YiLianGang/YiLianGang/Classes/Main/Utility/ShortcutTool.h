//
//  ShortcutTool.h
//  YiLianGang
//
//  Created by 张雨 on 2017/4/1.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShortcutInfo.h"

@interface ShortcutTool : NSObject
{
    NSString *mUserPhone;
}

+(ShortcutTool *)shareShortcutTool;

-(NSArray *)getAllShortcut;
-(void)addShortcutByShortcutName:(NSString *)shortcutName;
-(void)removeShortcutByShortcutName:(NSString *)shortcutName;

@end
