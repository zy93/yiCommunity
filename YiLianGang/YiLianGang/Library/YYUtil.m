//
//  YYUtil.m
//  YongYuanDeLaoShe
//
//  Created by 张雨 on 2017/2/19.
//  Copyright © 2017年 cn.hanyan. All rights reserved.
//

#import "YYUtil.h"
#import "UIDevice+Resolutions.h"
@implementation YYUtil


+ (NSString *)timeWithTimeInterval:(NSTimeInterval)timeInt
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInt/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)timeForYearWithTimeInterval:(NSTimeInterval)timeInt
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInt/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)timeForMonthWithTimeInterval:(NSTimeInterval)timeInt
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInt/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC+8"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+(CGFloat) GetLengthAdaptRate
{
    CGFloat rate = 1;
    if([[UIDevice currentDevice] resolution]==UIDeviceResolution_iPhoneRetina4 ||
       [[UIDevice currentDevice] resolution]==UIDeviceResolution_iPhoneRetina35)
    {
        rate = 320/375.0;
    }
    if([[UIDevice currentDevice] resolution]==UIDeviceResolution_iPhoneRetina47)
    {
        rate = 1;
        
        //rate = 0.91;
    }
    else if([[UIDevice currentDevice] resolution]==UIDeviceResolution_iPhoneRetina55)
    {
        rate = 414/375.0;
        //rate = 1.18;
    }
    /*else if(([[UIDevice currentDevice] resolution]==UIDeviceResolution_iPhoneRetina4||[[UIDevice currentDevice] resolution]==UIDeviceResolution_iPhoneRetina35) && [BUSystemVersion SystemVersionGreaterThanOrEqualTo:8.0] && (![BUSystemVersion SystemVersionGreaterThanOrEqualTo:8.1]))
     {
     //rate = 375.0/414.0;
     rate = 320.0/414.0;
     rate = 1;
     }*/
    else if([[UIDevice currentDevice] resolution]==UIDeviceResolution_iPadRetina )
    {
        return 768.0/320.0;
    }
    else if([[UIDevice currentDevice] resolution]==UIDeviceResolution_iPadStandard)
    {
        return 768.0/320.0;
    }
    return rate;
}

+(CGRect)computeTextSize:(NSString *)text boundSize:(CGSize)boundSize textFont:(CGFloat)font
{
    if (strIsEmpty(text)) {
        text = @"  ";
    }
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    NSRange range = NSMakeRange(0, text.length);
    NSDictionary *dic = [s attributesAtIndex:0 effectiveRange:&range];
    CGRect rect = [text boundingRectWithSize:boundSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return rect;
}

+(NSString *)PostImagesToServer:(NSString *)strUrl dicPostParams:(NSDictionary *)params dicImages:(NSMutableDictionary *)dicImages block:(void(^)(NSInteger httpCode, NSData *data))block
{
    
    NSString * res;
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    //NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image;//=[params objectForKey:@"pic"];
    //得到图片的data
    //NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++) {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        //if(![key isEqualToString:@"pic"]) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //[body appendString:@"Content-Transfer-Encoding: 8bit"];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        //}
    }
    ////添加分界线，换行
    //[body appendFormat:@"%@\r\n",MPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    
//    //循环加入上选择的设备
//    for(int i = 0; i< [deviceIds count] ; i++){
//        //要上传的图片
//        NSString *deviceId = deviceIds[i];
//        //得到图片的data
//        NSData* data =  [deviceId dataUsingEncoding:NSUTF8StringEncoding];
//        NSMutableString *imgbody = [[NSMutableString alloc] init];
//        //添加分界线，换行
//        [imgbody appendFormat:@"%@\r\n",MPboundary];
//        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"Alias\";  \r\n"];
//        //声明上传文件的格式
//        [imgbody appendFormat:@"Content-Type=\"text\"; charset=utf-8\r\n\r\n"];
//        
//        NSLog(@"选择的设备id：%@", deviceId);
//        
//        //将body字符串转化为UTF8格式的二进制
//        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
//        //将image的data加入
//        [myRequestData appendData:data];
//        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
    
    //循环加入上传图片
    keys = [dicImages allKeys];
    for(int i = 0; i< [keys count] ; i++){
        //要上传的图片
        image = [dicImages objectForKey:[keys objectAtIndex:i ]];
        //得到图片的data
        NSData* data =  UIImageJPEGRepresentation(image, 0.0);
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        //此处循环添加图片文件
        //添加图片信息字段
        //声明pic字段，文件名为boris.png
        //[body appendFormat:[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"File\"; filename=\"%@\"\r\n", [keys objectAtIndex:i]]];
        
        ////添加分界线，换行
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpg\"\r\n", [keys objectAtIndex:i]];
        //声明上传文件的格式
        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
        
        NSLog(@"上传的图片：%d  %@", i, [keys objectAtIndex:i]);
        
        //将body字符串转化为UTF8格式的二进制
        //[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    //[request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //设置接受response的data
    NSData *mResponseData;
    NSError *err = nil;
    mResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSInteger code = 200;
    
    if(mResponseData == nil){
        NSLog(@"err code : %@", [err localizedDescription]);
        code = err.code;
    }
    res = [[NSString alloc] initWithData:mResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"服务器返回：%@", res);
    if (block) {
        block(code, mResponseData);
    }
    return res;
}

@end
