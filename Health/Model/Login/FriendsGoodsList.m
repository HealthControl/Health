//
//  FriendsGoodsList.m
//  Health
//
//  Created by VickyCao on 4/6/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "FriendsGoodsList.h"
#import "GoodsRequest.h"

static int friendsPaylist;

@implementation FriendsGoodsList

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
    static FriendsGoodsList *instance;
    dispatch_once(&onceToken, ^{
        instance = [[FriendsGoodsList alloc] init];
    });
    
    return instance;
}

- (void)getPayListMobile:(NSString *)mobile complete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSDictionary *dic = @{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"mobile":mobile};
    [self startPost:@"Api/Friend/pay_lists" params:dic tag:&friendsPaylist];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
       if (tag == &friendsPaylist) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                if ([msg[@"status"] boolValue]) {
                    self.payList = [NSMutableArray array];
                    for (NSDictionary *dic in msg[@"data"]) {
                        BuyDetail *detail = [BuyDetail modelWithDictionary:dic];
                        [self.payList addObject:detail];
                    }
                } else {
                    _failed(msg[@"error"], msg[@"msg"]);
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
