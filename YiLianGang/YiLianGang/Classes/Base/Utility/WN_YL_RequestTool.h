//
//  WN_YL_RequestTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/2.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//
//#define HTTP_HOST @"http://123.56.197.113:8080/"
#define HTTP_HOST @"http://www.e-harbour.net/"//登陆用到这个接口
#define HTTP_Service @"http://www.yiliangang.net:8012/"
#define HTTP_NEW @"http://192.168.38.233:8080/"
//#define HTTP_Service @"http://192.168.1.100:8080/"
#define SOCKET_HOST @"moblie.e-harbour.net:8999"
#define HTTP_CESHIService @"http://219.143.170.98:10011/"


#import <Foundation/Foundation.h>


@class WN_YL_RequestTool;
@protocol WN_YL_RequestToolDelegate<NSObject>
-(void)requestTool:(WN_YL_RequestTool*)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary*)dict;
@end


@interface WN_YL_RequestTool : NSObject

-(void)sendGetRequestWithExStr:(NSString*)exStr andParam:(NSDictionary<NSString*,NSString*>*)param;
-(void)sendPostRequestWithExStr:(NSString*)exStr andParam:(NSDictionary<NSString*,NSString*>*)param;
-(void)sendPostRequestWithUri:(NSString*)uri andParam:(NSDictionary<NSString*,NSString*>*)param;

-(void)sendPostJsonRequestWithExStr:(NSString*)exStr andParam:(NSDictionary<NSString*,NSString*>*)param;
@property(nonatomic,weak) id<WN_YL_RequestToolDelegate> delegate;
@end
