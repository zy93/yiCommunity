//
//  DeviceEditController.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/31.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceEditController : UIViewController


-(instancetype)initWithText:(NSString*)str withPlaceholder:(NSString*)placeholder withFinishBlock:(void (^)(NSString *text))block;
@end
