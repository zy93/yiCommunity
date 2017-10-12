//
//  DeviceRelationBaseView.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/19.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceRelationBaseView.h"

@implementation DeviceRelationBaseView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.on = NO;
    
}
-(DeviceInfo *)deviceInfo{
    if (!_deviceInfo) {
        _deviceInfo = self.infoBlock();
    }
    return _deviceInfo;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
