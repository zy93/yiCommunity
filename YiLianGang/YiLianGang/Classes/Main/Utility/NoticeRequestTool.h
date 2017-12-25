//
//  NoticeRequestTool.h
//  YiLianGang
//
//  Created by 编程 on 2017/11/9.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NoticeFinishBlock) (NSDictionary *dict);


@interface NoticeRequestTool : NSObject

@property (nonatomic, strong) NSNumber *stateNumber;

+(instancetype)sharedNoticeTool;

-(void)sendNoticeRequestWithResponse:(NoticeFinishBlock)block;

@end
