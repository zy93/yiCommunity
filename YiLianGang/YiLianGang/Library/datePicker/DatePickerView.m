//
//  DatePickerView.m
//  YNCCProduct
//
//  Created by YNKJMACMINI1 on 16/5/5.
//  Copyright © 2016年 YNKJMACMINI2. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    UIPickerView *picker;
    
}
@synthesize year,day,month,hour,min;
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        picker = [[UIPickerView alloc] initWithFrame:self.bounds];
        
        picker.delegate  = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = NO;
//        _currTextcolor = [UIColor colorWithRed:0.41 green:0.62 blue:0.79 alpha:1];
//        _otherTextcolor = [UIColor blackColor];
        [self addSubview:picker];
        
        
        _dayarr1 = [NSArray arrayWithObjects:@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil];
        _dayarr2 = [NSArray arrayWithObjects:@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil];
         _montharr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
        
        _hourarr = [NSArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
        _minarr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
     
        _yeararr = [[NSMutableArray alloc] initWithCapacity:0];
         _dataarr = [NSArray arrayWithObjects:_dayarr1,_dayarr2,_yeararr,_hourarr,_minarr, nil];
        //_dataarr = [NSArray arrayWithObjects:_dayarr1,_dayarr2,_yeararr, nil];
        NSDate * date = [NSDate date];
//        NSDate *date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date1];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        year = [[formatter stringFromDate:date] intValue];
        [formatter setDateFormat:@"MM"];
        month = [[formatter stringFromDate:date] intValue];
        [formatter setDateFormat:@"dd"];
        day = [[formatter stringFromDate:date] intValue];
        
        [formatter setDateFormat:@"HH"];
        hour = [[formatter stringFromDate:date] intValue];
        [formatter setDateFormat:@"mm"];
        min = [[formatter stringFromDate:date] intValue];
        
        for (int i = year-16; i<=year+1; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
//            NSLog(@"%@",str);
            [_yeararr addObject:str];
        }
       
        [picker selectRow:16 inComponent:0 animated:YES];
        [picker selectRow:month-1 inComponent:1 animated:YES];
        [picker selectRow:day-1 inComponent:2 animated:YES];
        
        [picker selectRow:hour-1 inComponent:3 animated:YES];
        [picker selectRow:min-1 inComponent:4 animated:YES];
     
    }
    return self;
}
#pragma mark - pickerview


-(void)selectedRow:(NSInteger)selectedyear month:(NSInteger)selectedmonth day:(NSInteger)selectedday hour:(NSInteger)selectedhour min:(NSInteger)selectedmin
{
    _selectedrow_year = 16;
    _selectedrow_month = selectedmonth;
    _selectedrow_day = selectedday-1;
    
    _selectedrow_hour = selectedhour;
    _selectedrow_min = selectedmin;
    
    [picker selectRow:_selectedrow_year inComponent:0 animated:YES];

    [picker selectRow:_selectedrow_month-1 inComponent:1 animated:YES];
    
    [picker selectRow:_selectedrow_day-1 inComponent:2 animated:YES];
    
    [picker selectRow:_selectedrow_hour-1 inComponent:3 animated:YES];
    [picker selectRow:_selectedrow_min-1 inComponent:4 animated:YES];
 
    
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return _dataarr.count;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component == 0)
    {
        return _yeararr.count;
    }
    else if(component == 1){
        
        return _montharr.count;
    }else if (component == 2) {
        //获得前二个滚轮的当前所选行的索引
        int row = (int)[picker selectedRowInComponent:0];
        int nowyear;
        if (_yeararr.count != 0) {
            nowyear = [[_yeararr objectAtIndex:row] intValue];
        }
     
        int nowmonth = (int)[picker selectedRowInComponent:1];
        if ((nowyear % 4 == 0 && nowyear % 100 !=0 )||(nowyear % 400 == 0)) {
            
            if (_dayarr2.count!=0){
                 return [[_dayarr2 objectAtIndex:nowmonth] intValue];
            }else {
                return 0;
            }
        }
        else
        {
            if (_dayarr1.count!=0) {
                return [[_dayarr1 objectAtIndex:nowmonth] intValue];
            } else{
                return 0;
            }
        
        }
        
        
    }
    else if (component == 3){
        return _hourarr.count;
    } else  {
        return _minarr.count;
    }
}

#pragma mark - UIPickerViewDelegate
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *mycom1 = [[UILabel alloc] init];
    mycom1.textAlignment = NSTextAlignmentCenter;
    mycom1.backgroundColor = [UIColor clearColor];
    
    mycom1.frame = CGRectMake(0, 0, self.frame.size.width/5.0, 50);

    [mycom1 setFont:[UIFont boldSystemFontOfSize:18]];
    if(component == 0)
    {
        if (row == _selectedrow_year || row == 16) {
            mycom1.textColor = [UIColor colorWithRed:0.41 green:0.62 blue:0.79 alpha:1];
           
        } else {
            mycom1.textColor = _otherTextcolor;
        }
        mycom1.text = [NSString stringWithFormat:@"%@年",[_yeararr objectAtIndex:row]];
       // NSLog(@"测试：%@",mycom1.text);
    }
    else if(component == 1){
        if (row+1 == _selectedrow_month || row+1 == month){
            mycom1.textColor = [UIColor colorWithRed:0.41 green:0.62 blue:0.79 alpha:1];
        } else {
            mycom1.textColor = _otherTextcolor;
        }
        mycom1.text = [NSString stringWithFormat:@"%02ld月",row+1];
       
    }else if(component == 2){
        if (row+1 == _selectedrow_day || row+1 == day){
            mycom1.textColor = [UIColor colorWithRed:0.41 green:0.62 blue:0.79 alpha:1];
        } else {
            mycom1.textColor = _otherTextcolor;
        }
        if (row == 0) {
            mycom1.text = [NSString stringWithFormat:@"all"];
        }else {
            mycom1.text = [NSString stringWithFormat:@"%02ld日",row+1];
        }
        
    }
    
    else if (component == 3){
        
        if (row == _selectedrow_hour || row == hour){
            mycom1.textColor = [UIColor colorWithRed:0.41 green:0.62 blue:0.79 alpha:1];
        } else {
            mycom1.textColor = _otherTextcolor;
        }
        mycom1.text = [NSString stringWithFormat:@"%02ld时",row];
        
    } else {
        
        if (row == _selectedrow_min || row == min){
            mycom1.textColor = [UIColor colorWithRed:0.41 green:0.62 blue:0.79 alpha:1];
        } else {
            mycom1.textColor = _otherTextcolor;
        }
        mycom1.text = [NSString stringWithFormat:@"%02ld分",row];
        
    }
    
    return mycom1;
}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return self.frame.size.width/5.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component == 1)
    {
        //当第一个滚轮发生变化时,刷新第二个滚轮的数据
        [picker reloadComponent:2];
        //让刷新后的第二个滚轮重新回到第一行
        //[picker selectRow:0 inComponent:2 animated:YES];
    }
    int rowy;
    int rowm;
    int rowd;
    
    int rowh;
    int rowmm;
    
    if (_yeararr.count != 0) {
        rowy = (int)[picker selectedRowInComponent:0];
        year = [[_yeararr objectAtIndex:rowy] intValue];
        
        _selectedrow_year = rowy;
    }
    if (_montharr.count != 0){
        rowm = (int)[picker selectedRowInComponent:1];
        month = (int)rowm+1;
        _selectedrow_month = rowm+1;
    }
    if (_dayarr1.count!=0 && _dayarr2.count!=0){
       rowd = (int)[picker selectedRowInComponent:2];
       day = (int)rowd+1;
        _selectedrow_day = rowd+1;
    }
    
    if (_hourarr.count!=0){
        rowh = (int)[picker selectedRowInComponent:3];
        hour = (int)rowh;
        _selectedrow_hour = rowh+1;
    }
    if (_minarr.count!=0){
        rowmm = (int)[picker selectedRowInComponent:4];
        min = (int)rowmm;
        _selectedrow_min = rowmm+1;
    }
    
    [picker reloadAllComponents];
}


-(void)reloadPickerView{
    [picker reloadAllComponents];
}



@end


