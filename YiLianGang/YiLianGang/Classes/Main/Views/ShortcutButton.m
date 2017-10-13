//
//  ShortcutButton.m
//  YiLianGang
//
//  Created by 张雨 on 2017/4/1.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "ShortcutButton.h"

@implementation ShortcutButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



//-(instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self createDelegateBtn];
//        [self addLongPressBtn];
//    }
//    return self;
//}

+(instancetype)buttonWithType:(UIButtonType)buttonType
{
    ShortcutButton *btn = [super buttonWithType:buttonType];
    [btn createDelegateBtn];
    //[btn addLongPressBtn];
    return btn;
}

-(void)createDelegateBtn
{
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(0, 0, 25, 25);
    delBtn.center = CGPointMake(15, 15);
//    button.backgroundColor = [UIColor yellowColor];
    [delBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(removeShortcut:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.hidden = YES;
    [self addSubview:delBtn];
}

-(void)addLongPressBtn
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouchedLongTime:)];
    longPress.minimumPressDuration = 1.5; //定义按的时间
    [self  addGestureRecognizer:longPress];
}

-(void)buttonTouchedLongTime:(UILongPressGestureRecognizer *)gesture
{
    NSString *str = [targDic objectForKey:@(ShortcutCustomEventsLongpress)];
    SEL action = NSSelectorFromString(str);
    [_target performSelector:action withObject:self];
}

-(void)removeShortcut:(UIButton *)sender
{    
    NSString *str = [targDic objectForKey:@(ShortcutCustomEventsRemove)];
    SEL action = NSSelectorFromString(str);
    [_target performSelector:action withObject:self];
    
}

-(void)addCustomTarget:(id)target action:(SEL)action events:(ShortcutCustomEvents)event
{
    _target = target;
    if (!targDic) {
        targDic = [[NSMutableDictionary alloc] init];
    }
    NSString *str = NSStringFromSelector(action);
    [targDic setObject:str forKey:@(event)];
}

-(void)hiddenDeleteBtn
{
    delBtn.hidden = YES;
}

-(void)showDeleteBtn
{
    delBtn.hidden = NO;
}

@end
