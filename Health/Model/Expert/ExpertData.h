//
//  ExpertData.h
//  Health
//
//  Created by VickyCao on 11/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import <jastor/jastor.h>

@interface ExpertData : Jastor

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *position;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *headpic;
@property (nonatomic, strong)NSString *introduce;
@property (nonatomic, strong)NSString *hospital;

@end

// 咨询
@interface NewsData : Jastor

//@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *inputtime;
@property (nonatomic, strong)NSString *thumb;
@property (nonatomic, strong)NSString *title;

@end

// 提问
@interface QuestionData : Jastor

@end

@interface ExpertDetail : Jastor

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *position;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *headpic;
@property (nonatomic, strong)NSString *introduce;
@property (nonatomic, strong)NSString *hospital;
@property (nonatomic, strong)NSString *number;

@end