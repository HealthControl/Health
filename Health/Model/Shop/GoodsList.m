//
//  GoodsList.m
//  Health
//
//  Created by VickyCao on 11/19/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "GoodsList.h"

@implementation GoodsList

@end

@implementation GoodsType

@end

@implementation GoodsDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsDescription":@"description"};
}

@end
@implementation BuyDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsDescription":@"description"};
}

@end