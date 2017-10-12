//
//  YLProvince.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLProvince : NSObject
@property(nonatomic,strong) NSString *countryId;
@property(nonatomic,strong) NSString *provinceId;
@property(nonatomic,strong) NSString *provinceName;
- (id)initWithDic:(NSDictionary *)dic;

@end
