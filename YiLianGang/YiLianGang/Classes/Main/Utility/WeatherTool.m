//
//  WeatherTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/9/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WeatherTool.h"
#import "WN_YL_RequestTool.h"
#import "LoginTool.h"
#import <CoreLocation/CoreLocation.h>

static WeatherTool *weatherTool;
@interface WeatherTool()<WN_YL_RequestToolDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong) WeatherInfo *info;
@property(nonatomic,strong) WN_YL_RequestTool *requestTool;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,copy) BLOCK block;

@end
@implementation WeatherTool
+(instancetype)sharedWeatherTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherTool = [WeatherTool new];

    });
    return weatherTool;
}
- (void)initializeLocationServiceWithResponse:(BLOCK)block{
    self.block = block;
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        NSString *city = [NSString string];
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            NSLog(@"%@\n",placemark.name);
            //获取城市
            city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
        // 还原Device 的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
        city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        city = [city stringByReplacingOccurrencesOfString:@"省" withString:@""];
        city = [city stringByReplacingOccurrencesOfString:@"区" withString:@""];
        self.block(city);
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
-(WeatherInfo *)getWeatherInfo{
    if (!_info) {
        _info = [WeatherInfo new];
    }
    return _info;
}
-(NSString *)city{
    if (!_city) {
        _city = @"北京";
    }
    return _city;
}
-(void)sendWeatherRequest{
    //TODO: 获取地址
    
    NSString *city = [self.city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.requestTool sendGetRequestWithExStr:@"Service_Platform/ios/weather.do" andParam:@{@"userId":[LoginTool sharedLoginTool].userID,@"city":city}];
    self.requestTool.delegate = self;
    
    
}
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.requestTool) {
        //NSLog(@"%@",dict);
        self.info.temp = dict[@"data"][@"now"][@"tmp"];
        self.info.minTemp = dict[@"data"][@"daily_forecast"][0][@"tmp"][@"min"];
        self.info.maxTemp = dict[@"data"][@"daily_forecast"][0][@"tmp"][@"max"];
        self.info.weather = dict[@"data"][@"now"][@"cond"][@"txt"];
        self.info.condition = dict[@"data"][@"api"][@"city"][@"qlty"];
        self.info.location = dict[@"data"][@"basic"][@"city"];
        self.info.weatherIconNum = dict[@"data"][@"now"][@"cond"][@"code"];
        self.info.date = [self getWeek];
        self.info.picURL = dict[@"pic_url"];
        NSArray *arr = dict[@"data"][@"daily_forecast"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            RealTimeWeatherInfo *info = [RealTimeWeatherInfo new];
            
        }
        self.info.realTimeWeatherArray = nil;
        
        [self.delegate weatherToolIsSuccess:isSuccess info:self.info];
    }
}

- (NSString*)getWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSString *weekStr = [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]];
    NSLog(@"星期:%@", weekStr);
    return weekStr;
}
- (WN_YL_RequestTool *)requestTool {
	if(_requestTool == nil) {
		_requestTool = [[WN_YL_RequestTool alloc] init];
	}
	return _requestTool;
}


- (WeatherInfo *)info {
	if(_info == nil) {
		_info = [[WeatherInfo alloc] init];
	}
	return _info;
}


@end
