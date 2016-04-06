//
//  FriendsGoodsList.h
//  Health
//
//  Created by VickyCao on 4/6/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"

@interface FriendsGoodsList : SSBaseRequest

@property (nonatomic, strong) NSMutableArray *payList;

+ (instancetype)singleton;

- (void)getPayListMobile:(NSString *)mobile complete:(Complete)completeBlock failed:(Failed)failedBlock;
@end
