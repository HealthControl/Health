//
//  LoginData.h
//  Health
//
//  Created by antonio on 15/11/1.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import <jastor/jastor.h>
#import <Foundation/Foundation.h>

@interface LoginData : Jastor

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *regdate;
@property (nonatomic, strong) NSString *lastdate;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, strong) NSString *userpic;

@end

