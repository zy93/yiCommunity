//
//  RegisterCellInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"
typedef enum {
    TYPE_INPUT,
    TYPE_SELECT
} RTextViewType;

@interface RegisterCellInfo : NSObject
@property(nonatomic,strong) NSString *textViewStr;
@property(nonatomic,strong) NSString *textViewPlaceHolder;
@property(nonatomic,strong) NSString *labelStr;
@property(nonatomic,assign) BOOL isPassword;
@property(nonatomic,assign) RTextViewType type;
@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,strong) UIColor *textViewColor;
@end
