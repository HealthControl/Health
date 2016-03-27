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
@property (nonatomic, strong) NSString *riskReportStr;
@property (nonatomic, strong) NSString *todayBlood;
@property (nonatomic, strong) NSMutableDictionary *warningDic;
@property (nonatomic, strong) NSMutableArray *periodArray;
@property (nonatomic, strong) NSString *resultUrl;

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
// 预警与报告
- (void)getWarning:(Complete)completeBlock failed:(Failed)failed;

- (void)getperiod:(Complete)completeBlock failed:(Failed)failed;

- (void)getCalendar:(NSString *)date uid:(NSString *)uid complete:(Complete)completeBlock failed:(Failed)failed;
// 血糖测试结果
- (void)getTestResultUrlID:(NSString *)resultid complete:(Complete)completeBlock failed:(Failed)failed;
@end
