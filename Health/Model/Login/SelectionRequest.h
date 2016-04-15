//
//  SelectionRequest.h
//  Health
//
//  Created by VickyCao on 12/18/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"

@interface AreaData : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *list;

@end

@interface SelectionRequest : SSBaseRequest

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) NSMutableArray *areaNameArray;

@property (nonatomic, strong) NSMutableArray *bloodTypeArray;
@property (nonatomic, strong) NSMutableArray *bloodTypeNameArray;

@property (nonatomic, strong) NSMutableArray *professionArray;
@property (nonatomic, strong) NSMutableArray *professionNameArray;

@property (nonatomic, strong) NSMutableArray *complicationArray;
@property (nonatomic, strong) NSMutableArray *complicationNameArray;




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
