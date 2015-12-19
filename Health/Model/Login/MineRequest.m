//
//  MineRequest.m
//  Health
//
//  Created by VickyCao on 12/9/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "MineRequest.h"

static int jifenTag;
static int commentTag;
static int friendsListTag;
static int deleteFriensTag;
static int addFriendsTag;
static int getProfileTag;

@implementation MineRequest

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
    static MineRequest *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MineRequest alloc] init];
    });
    
    return instance;
}

- (void)getJifen:(NSString *)userID complete:(Complete)completeBlock failed:(Failed)failedBlock {
    NSString *uri = @"Api/Member/point";
    _complete = completeBlock;
    _failed = failedBlock;
    [self startPost:uri params:@{@"userid":userID} tag:&jifenTag];
}

- (void)postDianping:(NSString *)content complete:(Complete)completeBlock failed:(Failed)failedBlock {
    NSString *uri = @"Api/other/comment";
    _complete = completeBlock;
    _failed = failedBlock;
    [self startPost:uri params:@{@"content":content} tag:&commentTag];
}

- (void)getFriendsListComplete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Friend/lists";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&friendsListTag];
}

- (void)addFriendsReletion:(NSString *)relation mobil:(NSString *)mobil complete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Friend/bind";
    
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"relation":relation, @"mobile":mobil} tag:&addFriendsTag];
    
}
// 删除亲友
- (void)deleteFriends:(NSString*)friendsID complete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/Friend/delete";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"id":friendsID} tag:&deleteFriensTag];
}

// 获取个人资料
- (void)getProfileComplete:(Complete)completeBlock failed:(Failed)failedBlock {
    _complete = completeBlock;
    _failed = failedBlock;
    NSString *uri = @"Api/member/info_show";
    [self startPost:uri params:@{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token} tag:&getProfileTag];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    if ([msg[@"status"] integerValue] == 1) {
        if (tag == &jifenTag) {
            
        } else if (tag == &commentTag) {
            
        } else if (tag == &friendsListTag) {
            self.friendsArray = [NSMutableArray array];
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                [self.friendsArray addObjectsFromArray:msg[@"data"]];
            }
        } else if (tag == &addFriendsTag) {
            
        } else if (tag == &deleteFriensTag) {
            
        } else if (tag == &getProfileTag) {
            if (![msg[@"data"] isKindOfClass:[NSNull class]]) {
                self.profileDic = msg[@"data"];
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
