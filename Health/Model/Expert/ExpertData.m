//
//  ExpertData.m
//  Health
//
//  Created by VickyCao on 11/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ExpertData.h"

@implementation ExpertData

@end

@implementation QuestionData

@end

@implementation NewsData

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsDescription":@"description"};
}

@end

@implementation ExpertDetail


@end

@implementation NewsDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsDescription":@"description", @"newsID":@"id"};
}

@end

@implementation CommentData

@end