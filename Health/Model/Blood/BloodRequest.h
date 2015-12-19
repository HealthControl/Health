//
//  BloodRequest.h
//  Health
//
//  Created by VickyCao on 12/13/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"

@interface BloodRequest : SSBaseRequest

@property (nonatomic, strong) NSString *calendarURL;
@property (nonatomic, strong) NSString *trendURL;
@property (nonatomic, strong) NSDictionary *testResultDic;
@property (nonatomic, strong) NSDictionary *indicatorDic;

+ (instancetype)singleton;

// 糖历
- (void)getCalendar:(NSString *)date complete:(Complete)completeBlock failed:(Failed)failed;
// 输入结果
- (void)postInputData:(NSDictionary *)inputDic complete:(Complete)completeBlock failed:(Failed)failed;
// 病情趋势
- (void)getTrend:(Complete)completeBlock failed:(Failed)failed;
// 指标
- (void)getZhibiao:(Complete)completeBlock failed:(Failed)failed;
@end
