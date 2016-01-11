//
//  RiskModel.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskModel.h"

@implementation RiskModel

- (id)init
{
    self = [super init];
    if (self) {
        self.userid = [UserCentreData singleton].userInfo.userid;
        self.token = [UserCentreData singleton].userInfo.token;
        self.contentDic = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static RiskModel *instance;
    dispatch_once(&onceToken, ^{
        instance = [[RiskModel alloc] init];
    });
    
    return instance;
}


@end
