//
//  WeatherInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/9/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealTimeWeatherInfo.h"
@interface WeatherInfo : NSObject
/**温度：如：32*/
@property(nonatomic,strong) NSString *temp;
/**最低温度：如：29*/
@property(nonatomic,strong) NSString *minTemp;
/**最高温度：如：34*/
@property(nonatomic,strong) NSString *maxTemp;

/**天气，如：多云*/
@property(nonatomic,strong) NSString *weather;
/**质量，如：良*/
@property(nonatomic,strong) NSString *condition;
/**地址，如：北京*/
@property(nonatomic,strong) NSString *location;
/**图片序号，如：100*/
@property(nonatomic,strong) NSString *weatherIconNum;
/**日期，如：周一 06月06日*/
@property(nonatomic,strong) NSString *date;
/**url，如：http://123.56.197.113:8080/weather/*/
@property(nonatomic,strong) NSString *picURL;
/**实时天气*/
@property(nonatomic,strong) NSArray<RealTimeWeatherInfo*> *realTimeWeatherArray;
@end
