//
//  DayChoiceController.h
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DayChoiceBlock) (NSArray *choice);
@interface DayChoiceController : UITableViewController
-(instancetype)initWithCompleteBlock:(DayChoiceBlock)block;
@end
