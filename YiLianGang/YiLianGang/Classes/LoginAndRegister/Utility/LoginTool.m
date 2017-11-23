//
//  LoginTool.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "LoginTool.h"
#import "WN_YL_RequestTool.h"
#import "NSString+JSON.h"
static LoginTool *loginTool;
@interface LoginTool()<WN_YL_RequestToolDelegate>
@property(nonatomic,strong) WN_YL_RequestTool *loginRequest;
@property(nonatomic,copy) LoginFinishBlock block;
@end
@implementation LoginTool

+(instancetype)sharedLoginTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginTool = [LoginTool new];
    });
    return loginTool;
}

-(void)sendLoginRequest{
    self.loginRequest = [WN_YL_RequestTool new];
    self.loginRequest.delegate = self;
    [self.loginRequest sendPostRequestWithExStr:@"Service_Platform/user/login.do" andParam:@{@"tel":self.userName,@"password":self.password}];
    //[self.loginRequest sendPostRequestWithExStr:@"KP/user/user_validationUser" andParam:@{@"tel":self.userName,@"password":self.password}];

}


-(void)sendLoginRequestWithResponse:(LoginFinishBlock)block{
    self.block = block;
    [self sendLoginRequest];
}


-(void)sendManagerLoginRequestWithUserName:(NSString *)userN pass:(NSString *)pass Response:(LoginFinishBlock)block
{
    self.loginRequest = [WN_YL_RequestTool new];
    self.loginRequest.delegate = self;
    self.block = block;
    self.userTel = userN;
    self.userName = userN;
    NSString *alias = [NSString stringWithFormat:@"%@A",userN];
    [self.loginRequest sendPostRequestWithUri:@"WY/user/user_validationUser" andParam:@{@"Phone":userN,@"Password":pass,@"alias":alias}];
}

-(void)requestTool:(WN_YL_RequestTool *)requestTool isSuccess:(BOOL)isSuccess dict:(NSDictionary *)dict{
    if (requestTool == self.loginRequest) {
        [self.delegate loginToolDidLogin:isSuccess withDict:(NSDictionary*)dict];
        if (self.block) {
            self.block(dict);
        }
    
    }
}

-(void)setUserIDWithOriginDict:(NSDictionary *)dict{
    NSDictionary *userIdDict;
    if([(dict[@"data"]) isKindOfClass:[NSDictionary class]]){
        userIdDict = dict[@"data"];
    }else{
        NSString *str =dict[@"data"];
        userIdDict = [NSString parseJSONStringToNSDictionary:str] ;
        
    }
    [LoginTool sharedLoginTool].userID =[NSString stringWithFormat:@"%@",userIdDict[@"userId"]];
    [LoginTool sharedLoginTool].community = [NSString stringWithFormat:@"%@",userIdDict[@"community"]];
    [LoginTool sharedLoginTool].userTel = [NSString stringWithFormat:@"%@",userIdDict[@"userTel"]];
}
@end
