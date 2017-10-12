//
//  YLRegion.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLRegion : NSObject
@property(nonatomic,strong) NSString *cityId;
@property(nonatomic,strong) NSString *countyId;
@property(nonatomic,strong) NSString *countyName;
- (id)initWithDic:(NSDictionary *)dic;

@end
