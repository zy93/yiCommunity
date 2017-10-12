//
//  WN_YL_BaseTabControllerInfo.m
//  YiLianGang
//
//  Created by Way_Lone on 16/7/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WN_YL_BaseTabControllerInfo.h"
@interface WN_YL_BaseTabControllerInfo()

@end

@implementation WN_YL_BaseTabControllerInfo
-(instancetype)initWithTitle:(nullable NSString*)title image:(nullable UIImage*)image selectedImage:(nullable UIImage *)selectedImage viewController:(nullable UIViewController*)viewController{
    self = [super init];
    self.title = title;
    self.image = image;
    self.selectedImage = selectedImage;
    self.viewController = viewController;
    return self;
}

@end
