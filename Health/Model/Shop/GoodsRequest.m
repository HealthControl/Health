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
static int addChartTag;
static int getChartTag;
static int addFavTag;
static int getFavTag;
static int addAddressTag;
static int editAddressTag;
static int postOrderTag;
static int getAddressTag;
static int deleteAddressTag;
static int deleteChartsTag;
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

- (void)addToChart:(NSDictionary *)chartDic complete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Cart/add";
    [self startPost:uri params:chartDic tag:&addChartTag];
}

- (void)getCharts:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Cart/lists";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&getChartTag];
}

- (void)deleteCharts:(NSString *)goodsId isFromFav:(BOOL)isFromFav complete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = isFromFav?@"Api/Product/favorite_delete": @"Api/Cart/delete";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"id":goodsId} tag:&deleteChartsTag];
}

- (void)addToFav:(NSDictionary *)favDic complete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Product/favorite_add";
    [self startPost:uri params:favDic tag:&addFavTag];
}

- (void)getFavs:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Product/favorite_lists";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&getFavTag];
}

- (void)addAddress:(NSDictionary *)addDic complete:(Complete)completeBlock failed:(Failed)failed{
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Address/add" params:addDic tag:&addAddressTag];
}

- (void)editAddress:(NSDictionary *)addDic complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Address/edit" params:addDic tag:&editAddressTag];
}

- (void)postOrder:(NSDictionary *)orderDic complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Order/add" params:orderDic tag:&postOrderTag];
}

- (void)getAddress:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Address/lists" params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&getAddressTag];
}

- (void)deleteAddress:(NSDictionary *)deleteDic complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    [self startPost:@"Api/Address/delete" params:deleteDic tag:&deleteAddressTag];
}

- (void)setDefaultsAddress:(NSString *)addressID complete:(Complete)completeBlock failed:(Failed)failed {
    _complete = completeBlock;
    _failed = failed;
    NSDictionary *dic = @{@"id":addressID, @"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token};
    [self startPost:@"Api/Address/setdefault" params:dic tag:&deleteAddressTag];
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
                self.goodsDetail = [GoodsDetail modelWithDictionary:msg[@"data"]];
            }
        } else if (tag == &getChartTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.buyArray = [NSMutableArray array];
                for (NSDictionary *dic in msg[@"data"]) {
                    BuyDetail *buydetail = [BuyDetail modelWithDictionary:dic];
                    [self.buyArray addObject:buydetail];
                }
            }
        } else if (tag == &addAddressTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.addressDic = [NSDictionary dictionaryWithDictionary: msg[@"data"]];
            }
        } else if (tag == &getAddressTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.addressArray = [NSMutableArray array];
                for (NSDictionary *dic in msg[@"data"]) {
                    [self.addressArray addObject:dic];
                }
            }
        } else if (tag == &getFavTag) {
            self.buyArray = [NSMutableArray array];
            for (NSDictionary *dic in msg[@"data"]) {
                BuyDetail *buydetail = [BuyDetail modelWithDictionary:dic];
                [self.buyArray addObject:buydetail];
            }
        } else if (tag == &postOrderTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.orderDic = [NSDictionary dictionaryWithDictionary:msg[@"data"]];
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
