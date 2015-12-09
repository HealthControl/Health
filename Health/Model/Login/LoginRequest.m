//
//  LoginRequest.m
//  Health
//
//  Created by antonio on 15/11/1.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "LoginRequest.h"
#import "LoginData.h"
#import "UserCentreData.h"

@implementation LoginRequest

static int registerTag;
static int loginTag;
static int sendSmsTag;

- (id)init
{
    self  = [super initWithDelegate:self];
    if (self) {
        //        self.examReport = [[ExamReportData alloc] init];
        //        self.examReport.configArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static LoginRequest *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LoginRequest alloc] init];
    });
    
    return instance;
}

- (void) registerWithDictionary:(NSDictionary *)registerDic complete:(Complete)complete failed:(Failed)failed {
    _complete = complete;
    _failed = failed;
    
    NSString *uri = [NSString stringWithFormat:@"Api/Member/register"];
    [self startPost:uri params:registerDic tag:&registerTag];
}

-(void) loginWithDictionary:(NSDictionary *) loginDic complete:(Complete)complete failed:(Failed) failed {
    _complete = complete;
    _failed = failed;
    
    NSString *uri = [NSString stringWithFormat:@"Api/Member/login"];
    [self startPost:uri params:loginDic tag:&loginTag];

}

-(void) sendSms:(NSDictionary *) mobile complete:(Complete)complete failed:(Failed) failed {
    _complete = complete;
    _failed = failed;
    NSString *uri = [NSString stringWithFormat:@"Api/Member/sendsms"];
    [self startPost:uri params:mobile tag:&sendSmsTag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
        if (tag == &registerTag) {
            // 保存用户信息
            LoginData *loginData = [[LoginData alloc] initWithDictionary:msg[@"data"]];
            UserCentreData *userCentre = [UserCentreData singleton];
            userCentre.userInfo = loginData;
            userCentre.hasLogin = YES;
            [[NSUserDefaults standardUserDefaults] setObject:msg[@"data"] forKey:@"userData"];
            NSLog(@"%@", loginData);
        }else if(tag == &loginTag){
            // 保存用户信息
            LoginData *loginData = [[LoginData alloc] initWithDictionary:msg[@"data"]];
            UserCentreData *userCentre = [UserCentreData singleton];
            userCentre.userInfo = loginData;
            userCentre.hasLogin = YES;
            [[NSUserDefaults standardUserDefaults] setObject:msg[@"data"] forKey:@"userData"];
            NSLog(@"%@", loginData);
        }
        _complete();
    } else {
        _failed(msg[@"error"], msg[@"msg"]);
    }
}

/**
 请求失败时-调用
 */
-(void)getError:(NSDictionary *)msg tag:(int *)tag {
    _failed(msg[@"error"], @"网络访问错误");
}

@end
