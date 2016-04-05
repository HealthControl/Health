//
//  GoodsBuyListCell.h
//  Health
//
//  Created by VickyCao on 3/27/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuyDetail;
@interface GoodsBuyListCell : UITableViewCell

@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, assign) BOOL isFriends;
@property (nonatomic, copy) void (^onButtonPress) (id event);

- (void)cellForBuyDetail:(BuyDetail *)buyDetail;

@end

