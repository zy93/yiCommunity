//
//  LoginTool.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LoginFinishBlock) (NSDictionary *dict);

@protocol LoginToolDelegate<NSObject>
-(void)loginToolDidLogin:(BOOL)isSuccess withDict:(NSDictionary*)dict;
@end

@interface LoginTool : NSObject
+(instancetype)sharedLoginTool;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSString *community;
@property(nonatomic,strong) NSString *userTel;

@property (nonatomic, assign) BOOL isManager; //是否是物业

-(void)setUserIDWithOriginDict:(NSDictionary*)dict;
//登录请求
-(void)sendLoginRequest;
-(void)sendLoginRequestWithResponse:(LoginFinishBlock)block;


//物业登录
-(void)sendManagerLoginRequestWithUserName:(NSString *)userN pass:(NSString *)pass Response:(LoginFinishBlock)block;
@property(nonatomic,weak) id<LoginToolDelegate> delegate;

@end
