//
//  WN_YL_BaseTabControllerInfo.h
//  YiLianGang
//
//  Created by Way_Lone on 16/7/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WN_YL_BaseTabControllerInfo : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIImage *selectedImage;
@property(nonatomic,strong) UIViewController *viewController;

-(instancetype)initWithTitle:(nullable NSString*)title image:(nullable UIImage*)image selectedImage:(nullable UIImage *)selectedImage viewController:(nullable UIViewController*)viewController;

@end
