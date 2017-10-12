//
//  RealTimeWeatherInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/9/18.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealTimeWeatherInfo : NSObject
/**日期：如2016-09-18*/
@property(nonatomic,strong) NSString *dailyTime;

/**最高温度：如22*/
@property(nonatomic,strong) NSString *maxTemp;
/**最低温度：如15*/
@property(nonatomic,strong) NSString *minTemp;
/**日间温度图片数字：如100、300*/
@property(nonatomic,strong) NSString *dayPicNum;
/**夜间温度图片数字：如100、300*/
@property(nonatomic,strong) NSString *nightPicNum;



@end
