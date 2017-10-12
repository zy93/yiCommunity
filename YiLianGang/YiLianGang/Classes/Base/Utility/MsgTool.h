//
//  MsgTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/24.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgTool : NSObject
+(instancetype)sharedMsgTool;
@property(nonatomic,assign,readonly) NSUInteger newMsgNum;
-(void)setNewMsgNum:(NSUInteger)newMsgNum;
@end
