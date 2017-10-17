//
//  JudgmentTime.m
//  ConstraintDemo
//
//  Created by 编程 on 2017/9/25.
//  Copyright © 2017年 wxd. All rights reserved.
//

#import "JudgmentTime.h"

@implementation JudgmentTime

-(BOOL)judgementTimeWithYear:(NSInteger) year month:(NSInteger)month day:(NSInteger)day
{
    NSDate * date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    BOOL isValidYear = [[formatter stringFromDate:date] intValue] > year;
    [formatter setDateFormat:@"MM"];
    BOOL isValidMonth1 = [[formatter stringFromDate:date] intValue] > month;
    BOOL isValidMonth2 = [[formatter stringFromDate:date] intValue] == month;
    [formatter setDateFormat:@"dd"];
    BOOL isValidDay = [[formatter stringFromDate:date] intValue] > day;
    if (isValidYear) {
        return NO;
    }
    if (isValidMonth1) {

        return NO;
    }
    if (isValidMonth2 && isValidDay) {
        return NO;
    }
    return YES;
}

//比较两个日期的大小
-(BOOL)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate = [formatter dateFromString:aDate];
    NSDate *toDate = [formatter dateFromString:bDate];
    NSLog(@"%@,%@",fromDate,toDate);
    NSComparisonResult result = [fromDate compare:toDate];
    if (result==NSOrderedSame)
    {
        return YES;
    }else if (result==NSOrderedAscending)
    {
        return YES;
    }else if (result==NSOrderedDescending)
    {
        return NO;
    }
    return NO;
    
}

//计算两个时间的字符串的相隔几天
-(NSInteger)numberOfDaysWithFromDate:(NSString *)fromDateString toDate:(NSString *)toDateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate = [formatter dateFromString:fromDateString];
    NSDate *toDate = [formatter dateFromString:toDateString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents    *comp = [calendar components:NSCalendarUnitDay
                                            fromDate:fromDate
                                              toDate:toDate
                                             options:NSCalendarWrapComponents];
    return comp.day+1;
    
}
@end
