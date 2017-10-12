//
//  Header.h
//  Demo
//
//  Created by 编程 on 2017/10/10.
//  Copyright © 2017年 wxd. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define UIColorHEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SIZE_SCALE_IPHONE6(x)   (x * ([UIScreen mainScreen].bounds.size.width / 375))
#define PRODUCTNAMEPRO @"沃特德"
#define PRODUCTDESCPRO @"直饮水"
#endif /* Header_h */

#import "Masonry.h"
#import "JSONKit.h"
