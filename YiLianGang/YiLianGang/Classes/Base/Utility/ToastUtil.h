//
//  ToastUtil.h
//  Wuzhoubaochexian
//
//  Created by Way_Lone on 2017/2/12.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToastUtil : NSObject
+(void)showToast:(NSString*)str;
+(void)showLoadingToast:(NSString*)str;
+(void)unShowLoading;
@end
