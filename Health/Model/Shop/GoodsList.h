//
//  GoodsList.h
//  Health
//
//  Created by VickyCao on 11/19/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "Jastor.h"

@interface GoodsList : Jastor

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *picture;

@end

//id: "1",
//name: "分类1",
//icon: "http://cdn-img.easyicon.net/png/11367/1136760.gif",
//listorder: "0",
//status: "1"

@interface GoodsType : Jastor

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *listorder;
@property (nonatomic, strong) NSString *status;

@end
