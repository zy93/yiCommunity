//
//  DeviceHeaderView.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeviceHeaderViewDelegate<NSObject>
-(void)deviceHeaderViewDidClickQRCodeScanButton;
@end
@interface DeviceHeaderView : UIView
@property(nonatomic,weak) id<DeviceHeaderViewDelegate> delegate;
@end
