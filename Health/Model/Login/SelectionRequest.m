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
    [self getUrl:@"Api/Member/area" tag:getAreaTag complete:compleBlock];
}
// BloodType
- (void)bloodTypeComplete:(Complete)compleBlock {
    [self getUrl:@"Api/Member/type" tag:getBloodTypeTag complete:compleBlock];
}
// 职业
- (void)professionTypeComplete:(Complete)compleBlock {
    [self getUrl:@"Api/Member/profession" tag:getProfessionTag complete:compleBlock];
}
// 并发症
- (void)complicationComplete:(Complete)compleBlock {
    [self getUrl:@"Api/Member/complication" tag:getComplicationTag complete:compleBlock];
}

- (void)getUrl:(NSString *)url tag:(int)tag complete:(Complete)complBlock {
    _complete = complBlock;
    [self startPost:url params:nil tag:&tag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *dic in msg[@"data"]) {
            [self.dataArray addObject:dic[@"value"]];
        }
        _complete();
    }
}

@end
