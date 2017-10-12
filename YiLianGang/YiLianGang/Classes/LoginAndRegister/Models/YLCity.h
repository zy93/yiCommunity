//
//  YLCity.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLCity : NSObject
@property(nonatomic,strong) NSString *provinceId;
@property(nonatomic,strong) NSString *cityId;
@property(nonatomic,strong) NSString *cityName;
- (id)initWithDic:(NSDictionary *)dic;

@end
