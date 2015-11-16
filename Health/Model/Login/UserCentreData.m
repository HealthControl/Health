//
//  UserCentreData.m
//  Health
//
//  Created by antonio on 15/11/16.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "UserCentreData.h"

@implementation UserCentreData

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
        if (userDic) {
            self.userInfo = [[LoginData alloc] initWithDictionary:userDic];
            if (self.userInfo.token && self.userInfo.token.length > 0) {
                self.hasLogin = YES;
            } else {
                self.hasLogin = NO;
            }
        }
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static UserCentreData *instance;
    dispatch_once(&onceToken, ^{
        instance = [[UserCentreData alloc] init];
    });
    
    return instance;
}

@end
