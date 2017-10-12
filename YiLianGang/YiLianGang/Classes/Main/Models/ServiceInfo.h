//
//  ServiceInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/25.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ServiceInfo : NSObject
@property(nonatomic,strong) NSString *serviceName;
@property(nonatomic,strong) UIImage *serviceImage;
@property(nonatomic,strong) UIViewController *presentController;
@end
