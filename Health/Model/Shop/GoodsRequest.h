//
//  GoodsRequest.h
//  Health
//
//  Created by VickyCao on 11/19/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"

@interface GoodsRequest : SSBaseRequest

@property (nonatomic, strong) NSMutableArray *goodsListArray;// 商品列表数组
@property (nonatomic, strong) NSMutableArray *goodsTypeArray;// 商品类型数组

+ (instancetype)singleton;

// 药物列表
- (void)getGoodsList:(NSString *)type complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 药品种类
- (void)getGoodsTypeAndcomplete:(Complete)completeBlock failed:(Failed)failedBlock;
@end
