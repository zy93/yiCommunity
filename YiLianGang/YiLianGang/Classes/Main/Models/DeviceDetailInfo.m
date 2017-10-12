//
//  DeviceDetailInfo.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceDetailInfo.h"
@interface DeviceDetailInfo()
@property(nonatomic,strong) DeviceInfo *deviceInfo;
@end
@implementation DeviceDetailInfo
-(instancetype)initWithDeviceInfo:(DeviceInfo *)deviceInfo{
    if (self = [super init]) {
        self.deviceInfo = deviceInfo;
    }
    return self;
}
-(NSString *)infoName{
    if (!_infoName) {
        _infoName = self.deviceInfo.thingName;
    }
    return _infoName;
}
-(NSString *)infoImageUrlStr{
    if (!_infoImageUrlStr) {
        NSString *imageStr = self.deviceInfo.picUrl;
        NSString *imageFixedStr = [[[imageStr stringByDeletingPathExtension]stringByAppendingString:@"1"] stringByAppendingPathExtension:[imageStr pathExtension]];
        
        _infoImageUrlStr = imageFixedStr;
    }
    return _infoImageUrlStr;
}
-(NSString *)infoDetailTypeName{
    if (!_infoDetailTypeName) {
        
        NSString *detailStr = [self.deviceInfo.templateId stringByReplacingOccurrencesOfString:@"model//" withString:@""];
        NSString *detailTypeStr = [detailStr lastPathComponent];
        _infoDetailTypeName = detailTypeStr;
    }
    return _infoDetailTypeName;
}
-(NSString *)infoDetailName{
    if (!_infoDetailName) {
        NSString *detailStr = [self.deviceInfo.templateId stringByReplacingOccurrencesOfString:@"model//" withString:@""];
        detailStr = [[detailStr stringByDeletingLastPathComponent]stringByReplacingOccurrencesOfString:@"/" withString:@" "];
        _infoDetailName = detailStr;
    }
    return _infoDetailName;
}
@end
