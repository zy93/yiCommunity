//
//  StyleTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/16.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StyleInfo.h"
@interface StyleTool : NSObject
+(instancetype)sharedStyleTool;
@property(nonatomic,strong) StyleInfo *styleInfo;

-(StyleInfo*)sessionSyle;

@end
