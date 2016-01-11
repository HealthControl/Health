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
@property (nonatomic, strong) NSMutableArray *riskContentArray;
@property (nonatomic, strong) NSString *reportID;
@property (nonatomic, strong) NSMutableDictionary *riskReportDic;
@property (nonatomic, strong) NSString *todayBlood;

+ (instancetype)singleton;

// 糖历
- (void)getCalendar:(NSString *)date complete:(Complete)completeBlock failed:(Failed)failed;
// 输入结果
- (void)postInputData:(NSDictionary *)inputDic complete:(Complete)completeBlock failed:(Failed)failed;
// 病情趋势
- (void)getTrend:(Complete)completeBlock failed:(Failed)failed;
// 指标
- (void)getZhibiao:(Complete)completeBlock failed:(Failed)failed;
// 获取风险内容
- (void)getRiskContent:(Complete)completeBlock failed:(Failed)failed;
// 提交风险
- (void)postRiskData:(NSDictionary *)postDic complete:(Complete)completeBlock failed:(Failed)failed;
// 风险报告
- (void)getRiskReport:(NSString *)reportID complete:(Complete)completeBlock failed:(Failed)failed;
// 今天的血糖
- (void)getTodayBloodComplete:(Complete)completeBlock failed:(Failed)failed;
@end
