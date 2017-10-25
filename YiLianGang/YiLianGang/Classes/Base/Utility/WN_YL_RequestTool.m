//
//  WN_YL_RequestTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/2.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//http://www.e-harbour.net/
#import "WN_YL_RequestTool.h"

@implementation WN_YL_RequestTool

/**
 *  发送get请求
 *
 *  @param exStr 请求的地址（不加前面ip地址，只需要后面的，如http://123.56.197.113:8080/Service_Platform/country.do，只需要写 Service_Platform/country.do）
 *  @param param 请求的参数
 */

-(void)sendGetRequestWithExStr:(NSString*)exStr andParam:(NSDictionary<NSString*,NSString*>*)param{
    NSMutableString *urlStr = [[HTTP_HOST stringByAppendingString:exStr] mutableCopy];
    if (param.count>0) {
        [urlStr appendString:@"?"];
        NSArray *keyArr = param.allKeys;
        for (int i=0; i < keyArr.count; i++) {
            
            NSString *key = keyArr[i];
//            NSString *value = [param[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = param[key];
            [urlStr appendString:key];
            [urlStr appendString:@"="];
            [urlStr appendString:[NSString stringWithFormat:@"%@",value]];
            if (i<keyArr.count-1) {
                [urlStr appendString:@"&"];
            }
        }
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)safe = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof (safe)strongSelf = safe;
        if (error == nil) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"delegate %@",self.delegate);
            if ([dict[@"error_code"] intValue] == 0) {
                [strongSelf.delegate requestTool:self isSuccess:YES dict:dict];
            }else{
                [strongSelf.delegate requestTool:self isSuccess:NO dict:nil];
            }
            NSLog(@"%@",dict);
            
        }else{
            [strongSelf.delegate requestTool:self isSuccess:NO dict:nil];
        }
    }];
    [dataTask resume];
    
}

-(void)sendPostRequestWithUri:(NSString*)uri andParam:(NSDictionary<NSString*,NSString*>*)param
{
    NSLog(@"参数：%@",param);
    NSMutableString *urlStr = [[HTTP_Service stringByAppendingString:uri] mutableCopy];
    NSMutableString *str = [NSMutableString new];
    if (param.count>0) {
        NSArray *keyArr = param.allKeys;
        for (int i=0; i < keyArr.count; i++) {
            NSString *key = keyArr[i];
            //NSString *value = [param[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = param[key];
            [str appendString:key];
            [str appendString:@"="];
            [str appendString:[NSString stringWithFormat:@"%@",value]];
            if (i<keyArr.count-1) {
                [str appendString:@"&"];
            }
        }
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    //发送请求
//    //发送同步请求，在主线程执行
//    //    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        //            if (error == nil) {
//        
//        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        if (dict) {
//            [self.delegate requestTool:self isSuccess:YES dict:dict];
//        }else{
//            [self.delegate requestTool:self isSuccess:NO dict:nil];
//        }
//        NSLog(@"%@",dict);
//        //
//        //            }
//        //            else {
//        //                [self.delegate requestTool:self isSuccess:NO dict:nil];
//        //            }
//    }];
//    
//    [connection start];
    
    
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                [self.delegate requestTool:self isSuccess:YES dict:dict];
            }else{
                [self.delegate requestTool:self isSuccess:NO dict:nil];
            }
            NSLog(@"测试121%@",dict);
            
        }else{
            [self.delegate requestTool:self isSuccess:NO dict:nil];
        }
        
        
    }];
    [dataTask resume];
}



-(void)sendPostRequestWithExStr3:(NSString*)exStr andParam:(NSDictionary<NSString*,NSString*>*)param{
    NSString *urlStr = [HTTP_HOST stringByAppendingString:exStr];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    //参数的集合的所有key的集合
    NSArray *keys= [param allKeys];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
    
    
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"scanimage"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[param objectForKey:key]];
        }
    }
    
    
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dict);
        
        if (dict[@"success"]) {
            NSLog(@"%@",dict[@"success"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if(dict[@"data"]){
                    
                    
                }else{
                    
                }
            });
        }else {
            NSLog(@"%@",dict[@"error"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        
        
    }];
    [dataTask resume];
}
/**字典转json*/
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(void)sendPostJsonRequestWithExStr:(NSString*)exStr andParam:(NSDictionary<NSString*,NSString*>*)param{
    NSString *urlStr = [HTTP_HOST stringByAppendingString:exStr];
    NSString *str = [self dictionaryToJson:param];
    //str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
//    str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@""];
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                [self.delegate requestTool:self isSuccess:YES dict:dict];
            }else{
                [self.delegate requestTool:self isSuccess:NO dict:nil];
            }
            NSLog(@"%@",dict);
            
        }else{
            [self.delegate requestTool:self isSuccess:NO dict:nil];
        }
        
        
    }];
    [dataTask resume];
}

-(void)sendPostRequestWithExStr:(NSString*)exStr andParam:(NSDictionary<NSString*,NSString*>*)param{
    NSString *urlStr = [HTTP_HOST stringByAppendingString:exStr];
    NSMutableString *str = [NSMutableString new];
    if (param.count>0) {
        NSArray *keyArr = param.allKeys;
        for (int i=0; i < keyArr.count; i++) {
            NSString *key = keyArr[i];
            //NSString *value = [param[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = param[key];
            [str appendString:key];
            [str appendString:@"="];
            [str appendString:[NSString stringWithFormat:@"%@",value]];
            if (i<keyArr.count-1) {
                [str appendString:@"&"];
            }
        }
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"------data:%@", data);
            if (dict) {
                [self.delegate requestTool:self isSuccess:YES dict:dict];
            }else{
                [self.delegate requestTool:self isSuccess:NO dict:nil];
                NSLog(@"http response not dic：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
            NSLog(@"http response：%@",dict);
            
        }else{
            [self.delegate requestTool:self isSuccess:NO dict:nil];
            NSLog(@"http request error：%@",error);
        }
        
        
    }];
    [dataTask resume];
}

@end
