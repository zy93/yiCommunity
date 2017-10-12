//
//  ShortcutButton.h
//  YiLianGang
//
//  Created by 张雨 on 2017/4/1.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ShortcutCustomEvents) {
    ShortcutCustomEventsRemove          = 1 << 0,  //删除动作
    ShortcutCustomEventsLongpress        = 1 << 1,  //长按动作
};


@interface ShortcutButton : UIButton
{
    NSMutableDictionary *targDic;
    __weak id  _target;
    UIButton *delBtn;
}

@property (nonatomic, strong) NSString *serviceName;

-(void)addCustomTarget:(nullable id)target action:(nullable SEL)action events:(ShortcutCustomEvents)event;
-(void)hiddenDeleteBtn;
-(void)showDeleteBtn;

@end
