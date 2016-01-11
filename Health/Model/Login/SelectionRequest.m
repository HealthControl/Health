//
//  SelectionRequest.m
//  Health
//
//  Created by VickyCao on 12/18/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SelectionRequest.h"

static int getAreaTag;
static int getBloodTypeTag;
static int getProfessionTag;
static int getComplicationTag;

@implementation SelectionRequest

- (id)init
{
    self  = [super initWithDelegate:self];
    if (self) {
        //        self.examReport = [[ExamReportData alloc] init];
        //        self.examReport.configArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static SelectionRequest *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SelectionRequest alloc] init];
    });
    
    return instance;
}

// 获取地区
- (void)getAreaComplete:(Complete)compleBlock {
    _complete = compleBlock;
    [self startPost:@"Api/Member/area" params:nil tag:&getAreaTag];
}
// BloodType
- (void)bloodTypeComplete:(Complete)compleBlock {
    _complete = compleBlock;
    [self startPost:@"Api/Member/type" params:nil tag:&getBloodTypeTag];
}
// 职业
- (void)professionTypeComplete:(Complete)compleBlock {
    _complete = compleBlock;
    [self startPost:@"Api/Member/profession" params:nil tag:&getProfessionTag];
}
// 并发症
- (void)complicationComplete:(Complete)compleBlock {
    _complete = compleBlock;
    [self startPost:@"Api/Member/complication" params:nil tag:&getComplicationTag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
        if (tag == &getAreaTag) {
            self.areaArray = [NSMutableArray array];
            self.areaNameArray = [NSMutableArray array];
            [self.areaArray addObjectsFromArray:msg[@"data"]];
            for (NSDictionary *dic in msg[@"data"]) {
                [self.areaNameArray addObject:dic[@"value"]];
            }
        } else if (tag == &getBloodTypeTag) {
            self.bloodTypeArray = [NSMutableArray array];
            self.bloodTypeNameArray = [NSMutableArray array];
            [self.bloodTypeArray addObjectsFromArray:msg[@"data"]];
            for (NSDictionary *dic in msg[@"data"]) {
                [self.bloodTypeNameArray addObject:dic[@"value"]];
            }
        } else if (tag == &getProfessionTag) {
            self.professionArray = [NSMutableArray array];
            self.professionNameArray = [NSMutableArray array];
            [self.professionArray addObjectsFromArray:msg[@"data"]];
            for (NSDictionary *dic in msg[@"data"]) {
                [self.professionNameArray addObject:dic[@"value"]];
            }
        } else if (tag == &getComplicationTag) {
            self.complicationArray = [NSMutableArray array];
            self.complicationNameArray = [NSMutableArray array];
            [self.complicationArray addObjectsFromArray:msg[@"data"]];
            for (NSDictionary *dic in msg[@"data"]) {
                [self.complicationNameArray addObject:dic[@"value"]];
            }
        }
    
        _complete();
    }
}

@end
