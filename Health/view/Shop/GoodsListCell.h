//
//  GoodsListCell.h
//  Health
//
//  Created by VickyCao on 11/27/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTNetImageView.h"

@interface GoodsListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet DTNetImageView *goodsImageView;

@property (nonatomic, weak) IBOutlet UILabel *goodsWeightLabel;
@property (nonatomic, weak) IBOutlet UILabel *goodsNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *goodsNumberLabel;

- (void)cellForGoods:(NSDictionary *)dic ;
@end
