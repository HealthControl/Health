//
//  LoginRequest.h
//  Health
//
//  Created by antonio on 15/11/1.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"

@interface LoginRequest : SSBaseRequest

+ (instancetype)singleton;

// 注册
- (void) registerWithDictionary:(NSDictionary *)registerDic complete:(Complete)complete failed:(Failed)failed;

//登陆
-(void) loginWithDictionary:(NSDictionary *) loginDic complete:(Complete)complete failed:(Failed) failed;

//发送验证码
-(void) sendSms:(NSDictionary *) mobile complete:(Complete)complete failed:(Failed) failed;
//重置密码
- (void)resetpwd:(NSDictionary *)resetDic complete:(Complete)complete failed:(Failed) failed;
// 找回密码
- (void)findPwd:(NSDictionary *)findpwd complete:(Complete)complete failed:(Failed)failed;
@end