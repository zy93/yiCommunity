//
//  WOTDatePickerView.m
//  WOTWorkSpace
//
//  Created by 张姝枫 on 2017/7/11.
//  Copyright © 2017年 北京物联港科技发展有限公司. All rights reserved.
//

#import "WOTDatePickerView.h"
#import "DatePickerView.h"
@interface WOTDatePickerView()

@property(nonatomic,strong)DatePickerView *dataPicker;

@end

@implementation WOTDatePickerView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _dataPicker = [[DatePickerView alloc]initWithFrame:CGRectMake(10,0, self.pickerView.frame.size.width-20, self.pickerView.frame.size.height)];
    
    [self.pickerView addSubview:_dataPicker];
}

- (IBAction)cancelAction:(id)sender {
    
    if (_cancelBlokc) {
        self.cancelBlokc();
    }
    
}


- (IBAction)okAction:(id)sender {
   
    if (_okBlock) {
        self.okBlock(_dataPicker.year,_dataPicker.month, _dataPicker.day,_dataPicker.hour,_dataPicker.min);
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
