//
//  SelectUtil.h
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/21.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelctBlock)(NSInteger index,NSString *str);
@interface SelectUtil : NSObject
+(instancetype)sharedSelectUtil;
-(void)showSelectArray:(NSArray *)arr selectBlock:(SelctBlock)block;
@end
