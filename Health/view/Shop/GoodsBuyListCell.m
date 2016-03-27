//
//  GoodsBuyListCell.m
//  Health
//
//  Created by VickyCao on 3/27/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "GoodsBuyListCell.h"
#import "GoodsRequest.h"
#import "DTNetImageView.h"

@interface GoodsBuyListCell () {
    IBOutlet UILabel            *nameLabel;
    IBOutlet UILabel            *singlePriceLabel;
    IBOutlet UIImageView        *thumImageView;
    IBOutlet UILabel            *guigeLabel;
    IBOutlet UILabel            *introLabel;
    IBOutlet UILabel            *numberLabel;
    
    IBOutlet UIButton           *selectButton;
    BuyDetail *_buyDetail;
}

@end

@implementation GoodsBuyListCell

- (void)cellForBuyDetail:(BuyDetail *)buyDetail {
    _buyDetail = buyDetail;
    
    nameLabel.text = buyDetail.title;
    singlePriceLabel.text = [NSString stringWithFormat:@"￥%@", buyDetail.price];
    [thumImageView setImageWithURL:[NSURL URLWithString:buyDetail.thumb] options:YYWebImageOptionProgressiveBlur];
    
    guigeLabel.text = [NSString stringWithFormat:@"商品规格:%@ ", buyDetail.specification];
    
    introLabel.text = [NSString stringWithFormat:@"商品介绍:%@ ", buyDetail.newsDescription];
    
    numberLabel.text = [NSString stringWithFormat:@"%d", [buyDetail.number intValue]];
}

- (IBAction)deleteGoods:(id)sender {
    [[GoodsRequest singleton] deleteCharts:_buyDetail.id isFromFav:self.isFav complete:^{
        if (self.onButtonPress) {
            NSDictionary *dic = @{@"event":@"delete",
                                  @"data":@(YES)
                                  };
            self.onButtonPress(dic);
        }
    } failed:^(NSString *state, NSString *errmsg) {
        if (self.onButtonPress) {
            NSDictionary *dic = @{@"event":@"delete",
                                  @"data":@(NO)
                                  };
            self.onButtonPress(dic);
        }
    }];
}

- (IBAction)selectButtonPressed:(id)sender {
    selectButton.selected = !selectButton.isSelected;
    _buyDetail.isSelected = selectButton.isSelected;
    if (self.onButtonPress) {
        NSDictionary *dic = @{@"event":@"select",
                              @"data":@(selectButton.isSelected)
                              };
        self.onButtonPress(dic);
    }
}

- (IBAction)addOrReduce:(id)sender {
    int number = [numberLabel.text intValue];
    NSInteger buttonTag = ((UIButton *)sender).tag;
    if (buttonTag == 1) {
        if (number > 1) {
            number--;
        } else {
            [self makeToast:@"个数不能小于1"];
        }
    } else {
        number++;
    }
    numberLabel.text = [NSString stringWithFormat:@"%d", number];
    _buyDetail.number = [NSNumber numberWithInt:[numberLabel.text intValue]];
    if (self.onButtonPress) {
        NSDictionary *dic = @{@"event":@"add",
                              @"data":_buyDetail
                              };
        self.onButtonPress(dic);
    }
}

@end
