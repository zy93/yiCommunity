//
//  RegisterInfoTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterCellInfo.h"
#import "YLCity.h"
#import "YLRegion.h"
#import "YLCountry.h"
#import "YLProvince.h"
#import "WN_YL_RequestTool.h"
typedef void(^RegisterBlock) (NSArray* arr);
typedef void(^ProtocolBlock)(NSDictionary *dict);
typedef void(^RegFinishBlock) (NSDictionary *dict);
@protocol RegisterGetCountryDelegate<NSObject>
-(void)RegisterInfoToolDidGetCountryArr:(NSArray<YLCountry*>*)arr;
@end
@protocol RegisterGetProvinceDelegate<NSObject>
-(void)RegisterInfoToolDidGetProvinceArr:(NSArray<YLProvince*>*)arr;
@end
@protocol RegisterGetCityDelegate<NSObject>
-(void)RegisterInfoToolDidGetCityArr:(NSArray<YLCity*>*)arr;
@end
@protocol RegisterGetRegionDelegate<NSObject>
-(void)RegisterInfoToolDidGetRegionArr:(NSArray<YLRegion*>*)arr;
@end
@protocol RegisterDelegate<NSObject>
-(void)RegisterDidRegisterSuccess:(BOOL)isSuccess withDict:(NSDictionary*)dict;
@end

@interface RegisterInfoTool : NSObject
//单例
+(instancetype)sharedRegisterInfoTool;
@property(nonatomic,strong) NSMutableArray<RegisterCellInfo*> *registerInfoArray;
-(void)addRegisterCellInfo:(RegisterCellInfo*)info;
-(NSArray*)allRegisterInfoArray;
//请求获取国家
-(void)sendRequestToGetAllCountry;
-(void)sendRequestToGetAllCountryResponse:(RegisterBlock)block;
//请求获取省份
-(void)sendRequestToGetAllProvinceInCountry:(YLCountry*)country;
-(void)sendRequestToGetAllProvinceInCountry:(YLCountry*)country response:(RegisterBlock)block;
//请求获取城市
-(void)sendRequestToGetAllCity:(YLProvince*)province;
-(void)sendRequestToGetAllCity:(YLProvince*)province response:(RegisterBlock)block;
//请求获取区县
-(void)sendRequestToGetAllRegion:(YLCity*)city;
-(void)sendRequestToGetAllRegion:(YLCity*)city response:(RegisterBlock)block;


//注册
-(void)sendRegisterRequestWithDict:(NSDictionary*)dict;
-(void)sendRegisterRequestWithDict:(NSDictionary*)dict response:(RegFinishBlock)block;

//获取协议
-(void)sendRequestToGetUserProtocolHandler:(ProtocolBlock)block;

@property(nonatomic,weak) id<RegisterGetCountryDelegate> countryDelegate;
@property(nonatomic,weak) id<RegisterGetProvinceDelegate> provinceDelegate;
@property(nonatomic,weak) id<RegisterGetCityDelegate> cityDelegate;
@property(nonatomic,weak) id<RegisterGetRegionDelegate> regionDelegate;
@property(nonatomic,weak) id<RegisterDelegate> registerDelegate;

@property(nonatomic,copy) RegisterBlock registerBlock;
@end
