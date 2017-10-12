//
//  WNLoadingToastView.m
//  Wuzhoubaochexian
//
//  Created by Way_Lone on 2017/2/13.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "WNLoadingToastView.h"

@implementation WNLoadingToastView
-(instancetype)initWithFrame:(CGRect)frame toastString:(NSString *)str backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = textColor;
        label.text = str;
        CGSize size = [label sizeThatFits:CGSizeMake(frame.size.width-40, CGFLOAT_MAX)];
        label.numberOfLines = 0;
        label.frame = CGRectMake(10, 10, size.width+20, size.height+20);
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        //容器view
        CGFloat conWidth = label.frame.size.width+20>100?label.frame.size.width+20:100;
        label.frame = CGRectMake((conWidth-label.frame.size.width)/2, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
        UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, conWidth, label.frame.size.height+60)];
        container.backgroundColor = backgroundColor;
        [container addSubview:label];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        indicator.frame = CGRectMake((container.frame.size.width-50)/2, container.frame.size.height-20-label.frame.size.height, 50, 50);
        [container addSubview:indicator];
        container.center = self.center;
        container.layer.cornerRadius = 5;
        container.layer.masksToBounds = YES;
        self.indicator = indicator;
        [indicator startAnimating];
        
        [self addSubview:container];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
