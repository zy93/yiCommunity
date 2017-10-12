//
//  WNToastView.m
//  Wuzhoubaochexian
//
//  Created by Way_Lone on 2017/2/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "WNToastView.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface WNToastView()
//@property(nonatomic,strong) NSString *str;
//@property(nonatomic,strong) UIColor *backgroundColor;
//@property(nonatomic,strong) UIColor *textColor;

@property(nonatomic,strong) NSTimer *timer;
@end

@implementation WNToastView
-(instancetype)initWithFrame:(CGRect)frame toastString:(NSString *)str disappearTime:(CGFloat)time backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = textColor;
        label.backgroundColor = backgroundColor;
        label.text = str;
        CGSize size = [label sizeThatFits:CGSizeMake(frame.size.width-40, CGFLOAT_MAX)];
        label.numberOfLines = 0;
        label.frame = CGRectMake(0, 0, size.width+20, size.height+20);
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        label.center = self.center;
        [self addSubview:label];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(disappearToast) userInfo:nil repeats:NO];
    }
    return self;
}
-(void)disappearToast{
    WS(weakSelf);
    [weakSelf.timer invalidate];

    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self disappearToast];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
