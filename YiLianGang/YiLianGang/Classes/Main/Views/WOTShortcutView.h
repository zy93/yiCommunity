//
//  WOTShortcutView.h
//  YiLianGang
//
//  Created by 张雨 on 2017/10/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WOTShortcutViewDelegate <NSObject>

-(void)JumpinterfaceWithButtonMessage:(NSString *)buttonMessage;

@end

@interface WOTShortcutView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak)id <WOTShortcutViewDelegate> shortcutViewDelegate;


@end
