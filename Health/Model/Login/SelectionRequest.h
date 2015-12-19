//
//  SelectionRequest.h
//  Health
//
//  Created by VickyCao on 12/18/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"

@interface SelectionRequest : SSBaseRequest

@property (nonatomic, strong) NSMutableArray *dataArray;

+ (instancetype)singleton;

// 获取地区
- (void)getAreaComplete:(Complete)compleBlock;
// BloodType
- (void)bloodTypeComplete:(Complete)compleBlock;
// 职业
- (void)professionTypeComplete:(Complete)compleBlock;
// 并发症
- (void)complicationComplete:(Complete)compleBlock;

@end
