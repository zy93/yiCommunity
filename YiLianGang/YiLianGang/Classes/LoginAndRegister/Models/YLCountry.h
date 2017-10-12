//
//  YLCountry.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLCountry : NSObject
@property(nonatomic,strong) NSString *countryId;
@property(nonatomic,strong) NSString *countryName;
- (id)initWithDic:(NSDictionary *)dic;
@end
