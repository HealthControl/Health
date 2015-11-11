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

@end

@interface RegisterData : Jastor

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *token;

@end
