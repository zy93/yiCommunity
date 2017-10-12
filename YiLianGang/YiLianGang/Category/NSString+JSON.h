//
//  NSString+JSON.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

@end
