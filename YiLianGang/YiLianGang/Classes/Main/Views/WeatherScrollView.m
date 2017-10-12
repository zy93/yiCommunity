//
//  WeatherScrollView.m
//  YiLianGang
//
//  Created by Way_Lone on 16/9/18.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WeatherScrollView.h"
#import "WeatherSubView.h"
@interface WeatherScrollView()
@property(nonatomic,strong) NSArray *weatherSubViewArr;

@end

@implementation WeatherScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
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

- (NSArray *)weatherSubViewArr {
	if(_weatherSubViewArr == nil) {
		_weatherSubViewArr = [[NSArray alloc] init];
	}
	return _weatherSubViewArr;
}

@end
