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
@property (nonatomic, strong) NSString *thumb;

@end

@interface GoodsType : Jastor

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *listorder;
@property (nonatomic, strong) NSString *status;

@end

@interface GoodsDetail : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *specification;
@property (nonatomic, strong) NSString *newsDescription;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray  *picture;

@end

@interface BuyDetail : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *specification;
@property (nonatomic, strong) NSString *newsDescription;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, assign) BOOL isSelected;

@end
