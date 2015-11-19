//
//  GoodsRequest.m
//  Health
//
//  Created by VickyCao on 11/19/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "GoodsRequest.h"
#import "GoodsList.h"

@implementation GoodsRequest

static int goodsListTag;

- (id)init
{
    self  = [super initWithDelegate:self];
    if (self) {
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static GoodsRequest *instance;
    dispatch_once(&onceToken, ^{
        instance = [[GoodsRequest alloc] init];
    });
    
    return instance;
}

- (void)getGoodsList:(NSString *)type complete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Product/lists";
    [self startPost:uri params:@{@"catid":type} tag:&goodsListTag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
        if (tag == &goodsListTag) {
            if (!self.goodsListArray) {
                self.goodsListArray = [NSMutableArray array];
            }
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dic in msg[@"data"]) {
                    GoodsList *data = [[GoodsList alloc] initWithDictionary:dic];
                    [self.goodsListArray addObject:data];
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