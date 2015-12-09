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
static int goodsTypeTag;
static int goodsDetailTag;
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

- (void)getGoodsTypeAndcomplete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Product/category";
    [self startPost:uri params:nil tag:&goodsTypeTag];
}

- (void)getGoodsDetailbyID:(NSString *)goodsID complete:(Complete)completeBlock failed:(Failed)failedBlock{
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = [NSString stringWithFormat:@"Api/Product/show"];
    [self startPost:uri params:@{@"id":goodsID} tag:&goodsDetailTag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
        if (tag == &goodsListTag) {
            if (!self.goodsListArray) {
                self.goodsListArray = [NSMutableArray array];
            }
            [self.goodsListArray removeAllObjects];
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dic in msg[@"data"]) {
                    GoodsList *data = [[GoodsList alloc] initWithDictionary:dic];
                    [self.goodsListArray addObject:data];
                }
            }
        } else if (tag == &goodsTypeTag) {
            if (!self.goodsTypeArray) {
                self.goodsTypeArray = [NSMutableArray array];
            }
            [self.goodsTypeArray removeAllObjects];
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dic in msg[@"data"]) {
                    GoodsType *goodsType = [[GoodsType alloc] initWithDictionary:dic];
                    [self.goodsTypeArray addObject:goodsType];
                }
            }
        } else if (tag ==  &goodsDetailTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.goodsDetail = [[GoodsDetail alloc] initWithDictionary:msg[@"data"]];
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
