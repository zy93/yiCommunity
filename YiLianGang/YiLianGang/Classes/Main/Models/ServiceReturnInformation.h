//
//  ServiceReturnInformation.h
//  YiLianGang
//
//  Created by 编程 on 2017/10/20.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceReturnInformation : NSObject

@property (nonatomic, strong)NSDictionary *returnInfoDictionary;

+(instancetype)sharedReturnInfo;

@end
