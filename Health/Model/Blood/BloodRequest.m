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
static int getRiskContent;
static int postRiskContent;
static int getRiskReport;
static int getTodayBlood;
static int getWarning;
static int getPeriod;
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

- (void)getRiskContent:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSString *uri = @"Api/Evaluate/item";
    [self startPost:uri params:nil tag:&getRiskContent];
}

- (void)postRiskData:(NSDictionary *)postDic complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSString *uri = @"Api/Evaluate/submit";
    [self startPost:uri params:postDic tag:&postRiskContent];
}

- (void)getRiskReport:(NSString *)reportID complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSString *uri = @"Api/Evaluate/result";
    [self startPost:uri params:@{@"id":reportID, @"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&getRiskReport];
}

- (void)getTodayBloodComplete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Bloodsugar/newest" params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&getTodayBlood];
}

- (void)getWarning:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Bloodsugar/warning" params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&getWarning];
}

- (void)getperiod:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Bloodsugar/measure_period" params:nil tag:&getPeriod];
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
        } else if (tag == &getRiskContent) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.riskContentArray = [NSMutableArray array];
                [self.riskContentArray addObjectsFromArray:msg[@"data"]];
            }
        } else if (tag ==  &postRiskContent) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.reportID = msg[@"data"];
            }
        } else if (tag == &getRiskReport) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.riskReportStr = msg[@"data"];
            }
        } else if (tag == &getTodayBlood) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.todayBlood = [NSString stringWithFormat:@"%0.2f", [msg[@"data"] floatValue]];
            }
        } else if (tag == &getWarning) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.warningDic = [NSMutableDictionary dictionaryWithDictionary:msg[@"data"]];
            }
        } else if (tag == &getPeriod) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.periodArray = [NSMutableArray arrayWithArray:msg[@"data"]];
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
