//
//  ExpertData.h
//  Health
//
//  Created by VickyCao on 11/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import <jastor/jastor.h>

@interface ExpertData : NSObject

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *position;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *headpic;
@property (nonatomic, strong)NSString *introduce;
@property (nonatomic, strong)NSString *hospital;

@end

// 咨询
@interface NewsData : NSObject

@property (nonatomic, strong)NSString *newsDescription;
@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *inputtime;
@property (nonatomic, strong)NSString *thumb;
@property (nonatomic, strong)NSString *title;

@end

// 提问
@interface QuestionData : NSObject

@end

@interface ExpertDetail : NSObject

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *position;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *headpic;
@property (nonatomic, strong)NSString *introduce;
@property (nonatomic, strong)NSString *hospital;
@property (nonatomic, strong)NSString *number;

@end

@interface NewsDetail : NSObject

@property (nonatomic, strong) NSString *newsID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *newsDescription;
@property (nonatomic, strong) NSNumber *inputtime;
@property (nonatomic, strong) NSString *content;

@end

@interface CommentData : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isreply;
@property (nonatomic, strong) NSString *reply;
@property (nonatomic, strong) NSString *replytime;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *expertid;
@property (nonatomic, strong) NSString *picture;

@end