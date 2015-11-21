//
//  ExpertRequest.h
//  Health
//
//  Created by VickyCao on 11/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"
#import "ExpertData.h"

@interface ExpertRequest : SSBaseRequest

@property (nonatomic, strong)NSMutableArray *expertsArray;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)NSMutableArray *newsArray;
@property (nonatomic, strong)ExpertDetail *expertsDetail;

+ (instancetype)singleton;

/**
 *  高级营养师
 */
- (void)getExpertsList:(Complete)completeBlock failed:(Failed)failedBlock;

/**
 *  专家咨询
 */
- (void)getExpertsQuestionList:(Complete)completeBlock failed:(Failed)failedBlock;

/**
 *  糖友资讯
 */
- (void)getUserNewsList:(Complete)completeBlock failed:(Failed)failedBlock;

/**
 *  专家详情
 */
- (void)getExpertDetail:(NSString *)doctorID complete:(Complete)completeBlock failed:(Failed)failedBlock;

@end
