//
//  BloodRequest.m
//  Health
//
//  Created by VickyCao on 12/13/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "BloodRequest.h"

@implementation BloodRequest

static int calendarTag;
static int inputTag;
static int trendTag;
static int indicatorTag;

- (id)init
{
    self  = [super initWithDelegate:self];
    if (self) {
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static BloodRequest *instance;
    dispatch_once(&onceToken, ^{
        instance = [[BloodRequest alloc] init];
    });
    
    return instance;
}

- (void)getCalendar:(NSString *)date complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSString *uri = @"Api/Bloodsugar/calendar";
//    [UserCentreData singleton].userInfo.token
    NSDictionary *postDic = @{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"date": date};
    [self startPost:uri params:postDic tag:&calendarTag];
}

- (void)postInputData:(NSDictionary *)inputDic complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSString *uri = @"Api/Bloodsugar/add";
    [self startPost:uri params:inputDic tag:&inputTag];
}

- (void)getTrend:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSString *uri = @"Api/Bloodsugar/trend";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&trendTag];
}

- (void)getZhibiao:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSString *uri = @"Api/Bloodsugar/indicator";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&indicatorTag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    NSLog(@"msg: %@", msg);
    if ([msg[@"status"] integerValue] == 1) {
        if (tag == &calendarTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.calendarURL = msg[@"data"];
            }
        } else if (tag == &inputTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.testResultDic = [NSDictionary dictionaryWithDictionary:msg[@"data"]];
            }
        } else if (tag == &trendTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.trendURL = msg[@"data"];
            }
        } else if (tag == &indicatorTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.indicatorDic = [NSDictionary dictionaryWithDictionary:msg[@"data"]];
            }
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
