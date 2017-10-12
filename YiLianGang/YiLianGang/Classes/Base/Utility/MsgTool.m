//
//  MsgTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/24.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "MsgTool.h"
static MsgTool *msgTool;
@interface MsgTool()
@property(nonatomic,assign) NSUInteger newMsgNum;
@end
@implementation MsgTool
+(instancetype)sharedMsgTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!msgTool) {
            msgTool = [[MsgTool alloc]init];
            [msgTool setNewMsgNum:0];
        }
    });
    return msgTool;
}
-(void)setNewMsgNum:(NSUInteger)newMsgNum{
    _newMsgNum = newMsgNum;
}
@end
