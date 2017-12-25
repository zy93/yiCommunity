//
//  NoticeRequestTool.m
//  YiLianGang
//
//  Created by 编程 on 2017/11/9.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "NoticeRequestTool.h"
#import "WN_YL_RequestTool.h"


static NoticeRequestTool *noticeRequestToo;

@interface NoticeRequestTool ()<WN_YL_RequestToolDelegate>

@property (nonatomic,copy) NoticeFinishBlock block;
@property (nonatomic, strong) WN_YL_RequestTool *noticeRequest;
@end
@implementation NoticeRequestTool

+(instancetype)sharedNoticeTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noticeRequestToo = [NoticeRequestTool new];
    });
    return noticeRequestToo;
}

-(void)sendNoticeRequestWithResponse:(NoticeFinishBlock)block
{
    self.block = block;
    self.noticeRequest = [WN_YL_RequestTool new];
    self.noticeRequest.delegate = self;
    [self.noticeRequest sendPostRequestWithUri:@"ylgPlatform/Proclamation/findByState" andParam:@{@"state":@1}];
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.noticeRequest) {
        if (self.block) {
            self.block(dict);
        }
    }
}



@end
