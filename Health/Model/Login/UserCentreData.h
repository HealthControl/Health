//
//  UserCentreData.h
//  Health
//
//  Created by antonio on 15/11/16.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import <jastor/jastor.h>
#import "LoginData.h"

@interface UserCentreData : Jastor

@property (nonatomic, strong) LoginData *userInfo;
@property (nonatomic, assign) BOOL hasLogin;

+ (instancetype)singleton;

@end
