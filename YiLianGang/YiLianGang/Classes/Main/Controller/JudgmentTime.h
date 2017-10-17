//
//  JudgmentTime.h
//  ConstraintDemo
//
//  Created by 编程 on 2017/9/25.
//  Copyright © 2017年 wxd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JudgmentTime : NSObject

/**
判断选择的时间是在当前时间之前还是之后

 @param year 年
 @param month 月
 @param day 日
 @return 比较值
 */
-(BOOL)judgementTimeWithYear:(NSInteger) year month:(NSInteger)month day:(NSInteger)day;

/**
 比较开始时间和结束时间两个时间的大小

 @param aDate 开始时间
 @param bDate 结束时间
 @return 比较值
 */
-(BOOL)compareDate:(NSString*)aDate withDate:(NSString*)bDate;


/**
 计算两个时间之间相隔几天

 @param fromDateString 开始时间
 @param toDateString 结束时间
 @return 计算之后的值
 */
-(NSInteger)numberOfDaysWithFromDate:(NSString *)fromDateString toDate:(NSString *)toDateString;

@end
