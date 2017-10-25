//
//  DatePickerView.h
//  YNCCProduct
//
//  Created by YNKJMACMINI1 on 16/5/5.
//  Copyright © 2016年 YNKJMACMINI2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic)int year;
@property(nonatomic)int month;
@property(nonatomic)int day;
@property(nonatomic)int hour;
@property(nonatomic)int min;

@property(nonatomic)NSInteger selectedrow_year;
@property(nonatomic)NSInteger selectedrow_month;
@property(nonatomic)NSInteger selectedrow_day;
@property(nonatomic)NSInteger selectedrow_hour;
@property(nonatomic)NSInteger selectedrow_min;
@property(nonatomic)NSArray *dataarr;
@property(nonatomic)NSArray *dayarr1;
@property(nonatomic)NSArray *dayarr2;
@property(nonatomic)NSArray *montharr;
@property(nonatomic)NSArray *hourarr;
@property(nonatomic)NSArray *minarr;
@property(nonatomic)NSMutableArray *yeararr;
@property(nonatomic,assign)UIColor *currTextcolor;
@property(nonatomic,assign)UIColor *otherTextcolor;
//@property(nonatomic,assign)NSInteger currentmonth;
//@property(nonatomic,assign)NSInteger currentday;


- (void)reloadPickerView;

-(void)selectedRow:(NSInteger)selectedyear month:(NSInteger)selectedmonth day:(NSInteger)selectedday hour:(NSInteger)selectedhour min:(NSInteger)selectedmin;
@end
