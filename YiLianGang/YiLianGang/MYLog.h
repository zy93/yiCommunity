//
//  MYLog.h
//  zhaoshangtong
//
//  Created by Way_Lone on 16/9/7.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#ifndef MYLog_h
#define MYLog_h
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif
#endif /* MYLog_h */
