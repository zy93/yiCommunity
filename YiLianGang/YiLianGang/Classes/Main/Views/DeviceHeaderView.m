//
//  DeviceHeaderView.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceHeaderView.h"

@implementation DeviceHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    
}
- (IBAction)clickQRcode:(id)sender {
    [self.delegate deviceHeaderViewDidClickQRCodeScanButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
