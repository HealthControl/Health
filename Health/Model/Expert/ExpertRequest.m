//
//  ExpertRequest.m
//  Health
//
//  Created by VickyCao on 11/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ExpertRequest.h"
#import "ExpertData.h"

static int expertsTag;
static int questionTag;
static int newsTag;

@implementation ExpertRequest

- (id)init
{
    self  = [super initWithDelegate:self];
    if (self) {
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static ExpertRequest *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ExpertRequest alloc] init];
    });
    
    return instance;
}

/**
 *  高级营养师
 */
- (void)getExpertsList:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Expert/lists/type/1";
    [self startPost:uri params:nil tag:&expertsTag];
}

/**
 *  专家咨询
 */
- (void)getExpertsQuestionList:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Expert/lists/type/2";
    [self startGet:uri tag:&questionTag];
}

/**
 *  糖友资讯
 */
- (void)getUserNewsList:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/News/lists";
    [self startPost:uri params:nil tag:&newsTag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
        if (tag == &expertsTag) {
            if (!self.expertsArray) {
                self.expertsArray = [NSMutableArray array];
            }
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dic in msg[@"data"]) {
                    ExpertData *data = [[ExpertData alloc] initWithDictionary:dic];
                    [self.expertsArray addObject:data];
                }
            }
            
        }else if(tag == &questionTag) {
            if (!self.questionArray) {
                self.questionArray = [NSMutableArray array];
            }
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dic in msg[@"data"]) {
                    ExpertData *data = [[ExpertData alloc] initWithDictionary:dic];
                    [self.questionArray addObject:data];
                }
            }
        } else if(tag == &newsTag) {
            if (!self.newsArray) {
                self.newsArray = [NSMutableArray array];
            }
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dic in msg[@"data"]) {
                    ExpertData *data = [[ExpertData alloc] initWithDictionary:dic];
                    [self.newsArray addObject:data];
                }
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
