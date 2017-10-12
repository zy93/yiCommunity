//
//  WeatherTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/9/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfo.h"
typedef void(^BLOCK) (NSString *city);
@protocol WeatherToolDelegate<NSObject>
-(void)weatherToolIsSuccess:(BOOL)isSuccess info:(WeatherInfo*)info;
@end

@interface WeatherTool : NSObject
+(instancetype)sharedWeatherTool;
-(WeatherInfo*)getWeatherInfo;
-(void)sendWeatherRequest;
- (void)initializeLocationServiceWithResponse:(BLOCK)block;
@property(nonatomic,weak) id<WeatherToolDelegate> delegate;
@property(nonatomic,strong,readonly) WeatherInfo *info;
@property(nonatomic,strong) NSString *city;

@end
