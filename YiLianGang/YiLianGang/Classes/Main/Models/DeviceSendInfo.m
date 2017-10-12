//
//  DeviceSendInfo.m
//  YiLianGang
//
//  Created by Way_Lone on 16/9/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceSendInfo.h"

@implementation DeviceSendInfo
-(NSString *)ProduceTime{
    if (_ProduceTime== nil) {
        _ProduceTime = [NSString new];
    }
    return _ProduceTime;
}
-(NSString *)localID{
    if (_localID== nil) {
        _localID = [NSString new];
    }
    return _localID;
}
-(NSString *)model{
    if (_model== nil) {
        _model = [NSString new];
    }
    return _model;
}
-(NSString *)producer{
    if (_producer== nil) {
        _producer = [NSString new];
    }
    return _producer;
}
-(NSString *)type{
    if (_type== nil) {
        _type = [NSString new];
    }
    return _type;
}
-(NSString *)userId{
    if (_userId== nil) {
        _userId = [NSString new];
    }
    return _userId;
}
-(NSString *)thingName{
    if (_thingName== nil) {
        _thingName = [NSString new];
    }
    return _thingName;
}
-(NSString *)groupId{
    if (_groupId== nil) {
        _groupId = [NSString new];
    }
    return _groupId;
}
-(NSString *)country{
    if (_country== nil) {
        _country = [NSString new];
    }
    return _country;
}
-(NSString *)province{
    if (_province== nil) {
        _province = [NSString new];
    }
    return _province;
}
-(NSString *)city{
    if (_city== nil) {
        _city = [NSString new];
    }
    return _city;
}
-(NSString *)county{
    if (_county== nil) {
        _county = [NSString new];
    }
    return _county;
}
-(NSString *)community{
    if (_community== nil) {
        _community = [NSString new];
    }
    return _community;
}
-(NSString *)detailLocation{
    if (_detailLocation== nil) {
        _detailLocation = [NSString new];
    }
    return _detailLocation;
}
@end
