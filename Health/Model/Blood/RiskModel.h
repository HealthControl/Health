//
//  RiskModel.h
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskModel : NSObject

@property (nonatomic, strong) NSString              *userid;
@property (nonatomic, strong) NSString              *token;
@property (nonatomic, strong) NSString              *sex;
@property (nonatomic, strong) NSString              *height;
@property (nonatomic, strong) NSString              *weight;
@property (nonatomic, strong) NSString              *waist;
@property (nonatomic, strong) NSString              *birthday;
@property (nonatomic, strong) NSString              *content;
@property (nonatomic, strong) NSMutableDictionary   *contentDic;
+ (instancetype)singleton;

@end
