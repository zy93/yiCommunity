//
//  RegisterInfoTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/4.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "RegisterInfoTool.h"
static RegisterInfoTool* registerInfoTool;
@interface RegisterInfoTool()<WN_YL_RequestToolDelegate>
@property(nonatomic,strong) WN_YL_RequestTool *countryRequest;
@property(nonatomic,strong) WN_YL_RequestTool *provinceRequest;
@property(nonatomic,strong) WN_YL_RequestTool *cityRequest;
@property(nonatomic,strong) WN_YL_RequestTool *regionRequest;

@property(nonatomic,strong) WN_YL_RequestTool *registerRequest;
@property(nonatomic,strong) WN_YL_RequestTool *protocolRequest;

@property(nonatomic,copy) RegisterBlock countryBlock;
@property(nonatomic,copy) RegisterBlock provinceBlock;
@property(nonatomic,copy) RegisterBlock cityBlock;
@property(nonatomic,copy) RegisterBlock regionBlock;
@property(nonatomic,copy) ProtocolBlock protocolBlock;
@property(nonatomic,copy) RegFinishBlock regFinishBlock;
@end
@implementation RegisterInfoTool
+(instancetype)sharedRegisterInfoTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registerInfoTool = [RegisterInfoTool new];
    });
    return registerInfoTool;
}
-(void)addRegisterCellInfo:(RegisterCellInfo*)info{
    [self.registerInfoArray addObject:info];
}
-(NSArray *)allRegisterInfoArray{
    
    self.registerInfoArray = [NSMutableArray new];
    RegisterCellInfo *info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请输入手机号";
    info.isPassword = NO;
    info.labelStr = @"手机号";
    info.type = TYPE_INPUT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请输入您的姓名";
    info.isPassword = NO;
    info.labelStr = @"姓名";
    info.type = TYPE_INPUT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请输入6-12个数字或字符";
    info.isPassword = YES;
    info.labelStr = @"密码";
    info.type = TYPE_INPUT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请再次输入相同密码";
    info.isPassword = YES;
    info.labelStr = @"重复密码";
    info.type = TYPE_INPUT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请选择国家";
    info.isPassword = NO;
    info.labelStr = @"国家";
    info.type = TYPE_SELECT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请选择省份";
    info.isPassword = NO;
    info.labelStr = @"省份";
    info.type = TYPE_SELECT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请选择城市";
    info.isPassword = NO;
    info.labelStr = @"城市";
    info.type = TYPE_SELECT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请选择区县";
    info.isPassword = NO;
    info.labelStr = @"区县";
    info.type = TYPE_SELECT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请输入小区名称";
    info.isPassword = NO;
    info.labelStr = @"社区";
    info.type = TYPE_INPUT;
    info.cellHeight = 44;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    info = [RegisterCellInfo new];
    info.textViewStr = @"";
    info.textViewPlaceHolder =@"请输入详细地址\n例如28号楼-5单元-505";
    info.isPassword = NO;
    info.labelStr = @"详细地址";
    info.type = TYPE_INPUT;
    info.cellHeight = 88;
    info.textViewColor = [UIColor clearColor];
    [self.registerInfoArray addObject:info];
    
    return [self.registerInfoArray copy];
}
-(void)sendRequestToGetAllCountry{
    self.countryRequest = [WN_YL_RequestTool new];
    [self.countryRequest sendGetRequestWithExStr:@"Service_Platform/country.do" andParam:nil];
    self.countryRequest.delegate = self;
    
}
-(void)sendRequestToGetAllCountryResponse:(RegisterBlock)block{
    self.countryBlock = block;
    [self sendRequestToGetAllCountry];
}
-(void)sendRequestToGetAllProvinceInCountry:(YLCountry *)country{
    if (country.countryId==nil) {
        return;
    }
    self.provinceRequest = [WN_YL_RequestTool new];
    NSString *requestExStr =[NSString stringWithFormat:@"Service_Platform/province/%@.do",country.countryId];
    [self.provinceRequest sendGetRequestWithExStr:requestExStr andParam:nil];
    self.provinceRequest.delegate = self;
    
}
-(void)sendRequestToGetAllProvinceInCountry:(YLCountry *)country response:(RegisterBlock)block{
    self.provinceBlock = block;
    [self sendRequestToGetAllProvinceInCountry:country];
}
-(void)sendRequestToGetAllCity:(YLProvince *)province{
    self.cityRequest = [WN_YL_RequestTool new];
    NSString *requestExStr =[NSString stringWithFormat:@"Service_Platform/city/%@.do",province.provinceId];
    [self.cityRequest sendGetRequestWithExStr:requestExStr andParam:nil];
    self.cityRequest.delegate = self;
    
}
-(void)sendRequestToGetAllCity:(YLProvince *)province response:(RegisterBlock)block{
    self.cityBlock = block;
    [self sendRequestToGetAllCity:province];
}
-(void)sendRequestToGetAllRegion:(YLCity *)city{
    self.regionRequest = [WN_YL_RequestTool new];
    NSString *requestExStr =[NSString stringWithFormat:@"Service_Platform/county/%@.do",city.cityId];
    [self.regionRequest sendGetRequestWithExStr:requestExStr andParam:nil];
    self.regionRequest.delegate = self;
    
}
-(void)sendRequestToGetAllRegion:(YLCity *)city response:(RegisterBlock)block{
    self.regionBlock = block;
    [self sendRequestToGetAllRegion:city];
}
-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.countryRequest) {
        NSArray *dataArr = dict[@"data"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            YLCountry *country = [[YLCountry alloc]initWithDic:dic];
            [mutaArr addObject:country];
        }
        if (self.countryDelegate) {
            [self.countryDelegate RegisterInfoToolDidGetCountryArr:[mutaArr copy]];
        }
        if (self.countryBlock) {
            self.countryBlock([mutaArr copy]);
            self.countryBlock = nil;
        }
    }else if (requestTool == self.provinceRequest){
        NSArray *dataArr = dict[@"data"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            YLProvince *province = [[YLProvince alloc]initWithDic:dic];
            [mutaArr addObject:province];
        }
        if (self.provinceDelegate) {
            [self.provinceDelegate RegisterInfoToolDidGetProvinceArr:[mutaArr copy]];
        }
        if (self.provinceBlock) {
            self.provinceBlock([mutaArr copy]);
        }
    
    }else if (requestTool == self.cityRequest){
        NSArray *dataArr = dict[@"data"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            YLCity *city = [[YLCity alloc]initWithDic:dic];
            [mutaArr addObject:city];
        }
        if (self.cityDelegate) {
            [self.cityDelegate RegisterInfoToolDidGetCityArr:[mutaArr copy]];
        }
        if (self.cityBlock) {
            self.cityBlock([mutaArr copy]);
        }
    }else if (requestTool == self.regionRequest){
        NSArray *dataArr = dict[@"data"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            YLRegion *region = [[YLRegion alloc]initWithDic:dic];
            [mutaArr addObject:region];
        }
        if (self.regionDelegate) {
            [self.regionDelegate RegisterInfoToolDidGetRegionArr:[mutaArr copy]];
        }
        if (self.regionBlock) {
            self.regionBlock([mutaArr copy]);
        }
    }
    
    else if(requestTool == self.registerRequest){
        if (self.regFinishBlock) {
            self.regFinishBlock(dict);
        }
        if ([self.regionDelegate respondsToSelector:@selector(RegisterDidRegisterSuccess:withDict:)]) {
            [self.registerDelegate RegisterDidRegisterSuccess:isSuccess withDict:(NSDictionary*)dict];
        }
    }
    else if (requestTool == self.protocolRequest){
        if (self.protocolBlock) {
            self.protocolBlock(dict);
        }
    }
}

-(void)sendRegisterRequestWithDict:(NSDictionary *)dict{
    self.registerRequest = [WN_YL_RequestTool new];
    [self.registerRequest sendPostJsonRequestWithExStr:@"Service_Platform/user/register/app.do" andParam:dict];
    
    self.registerRequest.delegate = self;
}
-(void)sendRegisterRequestWithDict:(NSDictionary *)dict response:(RegFinishBlock)block{
    self.regFinishBlock = block;
    [self sendRegisterRequestWithDict:dict];
}
#pragma mark 获取用户协议
-(void)sendRequestToGetUserProtocolHandler:(ProtocolBlock)block{
    self.protocolBlock = block;
    self.protocolRequest = [WN_YL_RequestTool new];
    [self.protocolRequest sendGetRequestWithExStr:@"Service_Platform/protocol/user.do" andParam:nil];
    self.protocolRequest.delegate = self;
}
- (NSMutableArray<RegisterCellInfo*> *)registerInfoArray {
    if(_registerInfoArray == nil) {
        _registerInfoArray = [[NSMutableArray<RegisterCellInfo*> alloc] init];
    }
    return _registerInfoArray;
}
@end
