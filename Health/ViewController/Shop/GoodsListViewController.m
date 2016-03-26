//
//  GoodsListViewController.m
//  Health
//
//  Created by VickyCao on 1/1/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsRequest.h"
#import "DTNetImageView.h"
#import "BuyViewController.h"

@interface GoodsBuyListCell : UITableViewCell {
    IBOutlet UILabel            *nameLabel;
    IBOutlet UILabel            *singlePriceLabel;
    IBOutlet UIImageView        *thumImageView;
    IBOutlet UILabel            *guigeLabel;
    IBOutlet UILabel            *introLabel;
    IBOutlet UILabel            *numberLabel;
    
    IBOutlet UIButton           *selectButton;
    BuyDetail *_buyDetail;
}

@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, copy) void (^onButtonPress) (id event);

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

@interface GoodsListViewController () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *goodsListTableView;
    NSMutableArray *dataArray;
    
    IBOutlet UIButton *totalButton;
    
    NSMutableArray *buyTotalArray;
}

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    buyTotalArray = [[NSMutableArray alloc] init];
    goodsListTableView.delegate = self;
    goodsListTableView.dataSource = self;
    
    if (self.isFromFav) {
        // 收藏列表
        [[GoodsRequest singleton] getFavs:^{
            [self reloadData];
        } failed:^(NSString *state, NSString *errmsg) {
            
        }];
        self.title = @"收藏";
    } else {
        // 购物车列表
        [[GoodsRequest singleton] getCharts:^{
            [self reloadData];
        } failed:^(NSString *state, NSString *errmsg) {
            
        }];
        self.title = @"购物车";
    }
}

- (void)reloadData {
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:[GoodsRequest singleton].buyArray];
    [goodsListTableView reloadData];
    [self getTotal];
}

- (void)getTotal {
    float total = 0;
    [buyTotalArray removeAllObjects];
    for (BuyDetail *d in [GoodsRequest singleton].buyArray) {
        if (d.isSelected) {
            total += [d.number intValue]*[d.price floatValue];
            [buyTotalArray addObject:d];
        }
    }
    NSLog(@"total :%@",[NSString stringWithFormat:@"实付: %0.2f",total]);
    [totalButton setTitle:[NSString stringWithFormat:@"实付:￥ %0.2f",total] forState:UIControlStateDisabled];
//    self.totalLabel.text = [NSString stringWithFormat:@"实付: %0.2f",total];
}

- (void)addToarray:(BuyDetail *)detail {
    if (detail.isSelected) {
        [buyTotalArray addObject:detail];
    } else {
        [buyTotalArray removeObject:detail];
    }
}

- (IBAction)toBuy:(id)sender {
    if (buyTotalArray.count > 0) {
        [self performSegueWithIdentifier:@"favToBuy" sender:self];
    } else {
        [self.view makeToast:@"请选择要购买的产品"];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"goodslistCell";
    GoodsBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    BuyDetail *detail = [dataArray objectAtIndex:indexPath.row];
    cell.isFav = self.isFromFav;
    [cell cellForBuyDetail:detail];
    
    __weak typeof(self) weakSelf = self;
    cell.onButtonPress = ^(id data) {
        NSString *event = ((NSDictionary *)data)[@"event"];
        if ([event isEqualToString:@"delete"]) {
            [weakSelf reloadData];
        } else if ([event isEqualToString:@"add"]) {
            
//            [weakSelf addToarray:(BuyDetail *)(data[@"data"])];
            [weakSelf getTotal];
        } else if ([event isEqualToString:@"select"]) {
            [weakSelf getTotal];
        }
    };
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"favToBuy"]) {
        BuyViewController *buyVC = [segue destinationViewController];
        buyVC.buyArray = [NSMutableArray arrayWithArray:buyTotalArray];
    }
}

@end
