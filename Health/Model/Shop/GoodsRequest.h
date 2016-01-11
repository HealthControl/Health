//
//  GoodsRequest.h
//  Health
//
//  Created by VickyCao on 11/19/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"
#import "GoodsList.h"

@interface GoodsRequest : SSBaseRequest

@property (nonatomic, strong) NSMutableArray *goodsListArray;// 商品列表数组
@property (nonatomic, strong) NSMutableArray *goodsTypeArray;// 商品类型数组
@property (nonatomic, strong) GoodsDetail    *goodsDetail;
@property (nonatomic, strong) NSMutableArray *buyArray;
@property (nonatomic, strong) NSDictionary *addressDic;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSDictionary *orderDic;

+ (instancetype)singleton;

// 药物列表
- (void)getGoodsList:(NSString *)type complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 药品种类
- (void)getGoodsTypeAndcomplete:(Complete)completeBlock failed:(Failed)failedBlock;
// 药品详情
- (void)getGoodsDetailbyID:(NSString *)goodsID complete:(Complete)completeBlock failed:(Failed)failedBlock;

// 加入购物车
- (void)addToChart:(NSDictionary *)chartDic complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 获取购物车列表
- (void)getCharts:(Complete)completeBlock failed:(Failed)failedBlock;
/**
 *   添加地址
 */
- (void)addAddress:(NSDictionary *)addDic complete:(Complete)completeBlock failed:(Failed)failed;
- (void)postOrder:(NSDictionary *)orderDic complete:(Complete)completeBlock failed:(Failed)failed;
- (void)editAddress:(NSDictionary *)addDic complete:(Complete)completeBlock failed:(Failed)failed;
- (void)deleteAddress:(NSDictionary *)deleteDic complete:(Complete)completeBlock failed:(Failed)failed;
- (void)setDefaultsAddress:(NSString *)addressID complete:(Complete)completeBlock failed:(Failed)failed;
/**
 *  地址列表
 */
- (void)getAddress:(Complete)completeBlock failed:(Failed)failed;
// 加入收藏
- (void)addToFav:(NSDictionary *)favDic complete:(Complete)completeBlock failed:(Failed)failedBlock;
- (void)getFavs:(Complete)completeBlock failed:(Failed)failedBlock;
- (void)deleteCharts:(NSString *)goodsId isFromFav:(BOOL)isFromFav complete:(Complete)completeBlock failed:(Failed)failedBlock;
@end

