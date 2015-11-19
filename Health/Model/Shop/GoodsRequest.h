//
//  GoodsRequest.h
//  Health
//
//  Created by VickyCao on 11/19/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"

@interface GoodsRequest : SSBaseRequest

@property (nonatomic, strong) NSMutableArray *goodsListArray;

+ (instancetype)singleton;

- (void)getGoodsList:(NSString *)type complete:(Complete)completeBlock failed:(Failed)failedBlock;

@end
