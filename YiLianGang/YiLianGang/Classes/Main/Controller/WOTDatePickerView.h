//
//  WOTDatePickerView.h
//  WOTWorkSpace
//
//  Created by 张姝枫 on 2017/7/11.
//  Copyright © 2017年 北京物联港科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTDatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIView *pickerView;


@property (nonatomic,copy) void (^cancelBlokc)();

@property (nonatomic,copy) void (^okBlock)(NSInteger year,NSInteger month,NSInteger day,NSInteger hour,NSInteger min);
//@property (nonatomic,copy) void (^okBlock)(NSInteger year,NSInteger month,NSInteger day);//将时分去掉
@end
