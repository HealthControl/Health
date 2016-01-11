//
//  MineRequest.h
//  Health
//
//  Created by VickyCao on 12/9/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "SSBaseRequest.h"
#import "UserInfo.h"

@interface MineRequest : SSBaseRequest

+ (instancetype)singleton;

@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (nonatomic, strong) NSMutableDictionary *profileDic;
@property (nonatomic, strong) UserInfo            *profileInfo;
@property (nonatomic, strong) NSString *jifen;
@property (nonatomic, strong) NSString *friendsBloodUrl;
// 获取积分
- (void)getJifen:(NSString *)userID complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 我的点评
- (void)postDianping:(NSString *)content complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 获取亲友列表
- (void)getFriendsListComplete:(Complete)completeBlock failed:(Failed)failedBlock;
// 添加亲友
- (void)addFriendsReletion:(NSString *)relation mobil:(NSString *)mobil complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 删除亲友
- (void)deleteFriends:(NSString*)friendsID complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 获取个人资料
- (void)getProfileComplete:(Complete)completeBlock failed:(Failed)failedBlock;

// 获取革新信息
- (void)getMyInfo:(Complete)completeBlock failed:(Failed)failedBlock;
- (void)postProfile:(NSDictionary *)postData complete:(Complete)completeBlock failed:(Failed)failedBlock;
// 上传头像
- (void)uploadHeadImage:(UIImage *)image complete:(Complete)completeBlock failed:(Failed)failedBlock;

- (void)getxieyiComplete:(Complete)completeBlock failed:(Failed)failedBlock;

- (void)getFriendsBlood:(NSString *)mobile complete:(Complete)completeBlock failed:(Failed)failedBlock;
@end
