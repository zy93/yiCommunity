//
//  MyActivityIndicatorView.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//
#define kWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
#define MYCOLOR [UIColor blackColor]
#define TextColor [UIColor whiteColor]
#import "MyActivityIndicatorView.h"
@interface MyActivityIndicatorView()
@property(nonatomic,strong) UIColor *imageColor;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic,strong) NSString *textString;
@end
@implementation MyActivityIndicatorView
-(instancetype)initWithStr:(NSString *)str imageColor:(UIColor*)imageColor textColor:(UIColor*)textColor{
    if (self = [super init]) {
        self.imageColor = imageColor;
        self.textColor = textColor;
        self.textString = str;
        [self setUpView];
    }
    return self;
}
- (void)setUpView{
    
        self.frame = [UIScreen mainScreen].bounds;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(kWidth/2-50, KHeight/2-50+10, 100, 100)];
        // 菊花背景的大小
        
        // 菊花的背景色
        if (self.imageColor) {
            bgView.backgroundColor = self.imageColor;
        }else{
            bgView.backgroundColor = MYCOLOR;
        }
        bgView.layer.cornerRadius = 10;
        [self insertSubview:bgView atIndex:0];
        // 菊花的颜色和格式（白色、白色大、灰色）
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        // 在菊花下面添加文字
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(bgView.frame.origin.x+10, bgView.frame.origin.y+60, 80, 40)];
        if (self.textString) {
            label.text = self.textString;
        }else{
            label.text = @"loading...";
        }
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        if (self.textColor) {
            label.textColor = self.textColor;
        }else{
            label.textColor = TextColor;
        }
        [self addSubview:label];
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
