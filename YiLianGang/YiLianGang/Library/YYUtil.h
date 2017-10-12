//
//  YYUtil.h
//  YongYuanDeLaoShe
//
//  Created by 张雨 on 2017/2/19.
//  Copyright © 2017年 cn.hanyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




#define black_33 0x333333
#define black_66 0x666666

#define blue_45 0x455cc7  //左侧
#define white_f2 0xf2f2f2 //背景
#define white_ff 0xffffff //缓冲

//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]





@interface YYUtil : NSObject

/**
 时间戳转时间

 @param timeInt 时间戳
 @return 时间
 */
+ (NSString *)timeWithTimeInterval:(NSTimeInterval)timeInt;
+ (NSString *)timeForYearWithTimeInterval:(NSTimeInterval)timeInt;
+ (NSString *)timeForMonthWithTimeInterval:(NSTimeInterval)timeInt;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

+(CGFloat) GetLengthAdaptRate;
/**
 计算文字范围

 @param text 文字内容
 @param boundSize 固定宽度的范围
 @param font 字体大小
 @return 文字范围
 */
+(CGRect)computeTextSize:(NSString *)text boundSize:(CGSize)boundSize textFont:(CGFloat)font;



/**
 上传图片到服务器

 @param strUrl <#strUrl description#>
 @param params <#params description#>
 @param dicImages <#dicImages description#>
 @param block <#block description#>
 @return <#return value description#>
 */
+(NSString *)PostImagesToServer:(NSString *)strUrl dicPostParams:(NSDictionary *)params dicImages:(NSMutableDictionary *)dicImages block:(void(^)(NSInteger httpCode, NSData *data))block;


@end
