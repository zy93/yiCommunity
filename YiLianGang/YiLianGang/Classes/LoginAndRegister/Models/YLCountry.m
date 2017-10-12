//
//  YLCountry.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "YLCountry.h"

@implementation YLCountry
- (id)initWithDic:(NSDictionary *)dic

{
    
    self = [super init];
    
    if (self)
        
    {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }    
    
    return self; 
    
}


@end
