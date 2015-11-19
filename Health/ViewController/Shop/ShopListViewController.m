//
//  ShopListViewController.m
//  Health
//
//  Created by VickyCao on 11/18/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ShopListViewController.h"
#import "DTNetImageView.h"
#import "GoodsRequest.h"
#import "GoodsList.h"

@interface GoodsCell : UITableViewCell {
    IBOutlet UIView *goodsView1;
    IBOutlet UIView *goodsView2;
    
    IBOutlet DTNetImageView *goodsImageView1;
    IBOutlet UILabel        *goodsPriceLabel1;
    IBOutlet UILabel        *goodsNameLabel1;
    
    IBOutlet DTNetImageView *goodsImageView2;
    IBOutlet UILabel        *goodsPriceLabel2;
    IBOutlet UILabel        *goodsNameLabel2;
}

- (void)cellForGoods:(NSArray *)goodsArray;

@end

@implementation GoodsCell

- (void)cellForGoods:(NSArray *)goodsArray {
    GoodsList *list1 = goodsArray[0];
    [goodsImageView1 setImageWithUrl:[NSURL URLWithString:list1.picture] defaultImage:nil];
    goodsPriceLabel1.text = list1.price;
    goodsNameLabel1.text = list1.title;
    
    if (goodsArray.count > 1) {
        goodsView2.hidden = NO;
        GoodsList *list2 = goodsArray[1];
        [goodsImageView2 setImageWithUrl:[NSURL URLWithString:list2.picture] defaultImage:nil];
        goodsPriceLabel2.text = list2.price;
        goodsNameLabel2.text = list2.title;
    } else {
        goodsView2.hidden = YES;
    }
}

@end

@interface ShopListViewController() <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *shopListTableView;
    NSMutableArray *goodsArray;
}

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    goodsArray = [NSMutableArray array];
    self.title = @"商城";
    __weak typeof(self) weakSelf = self;
    [[GoodsRequest singleton] getGoodsList:@"0" complete:^{
        [weakSelf reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadData {
    [goodsArray addObjectsFromArray:[GoodsRequest singleton].goodsListArray];
    [shopListTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (goodsArray.count%2 == 0) {
        return goodsArray.count/2;
    }
    return goodsArray.count/2+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifiter = @"GoodsCell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    if (goodsArray.count > 0) {
        NSRange range;
        if ((indexPath.row + 1)* 2 > goodsArray.count) {
            range = NSMakeRange(indexPath.row*2, 1);
        } else {
            range = NSMakeRange(indexPath.row * 2, 2);
        }
        
        [cell cellForGoods:[goodsArray subarrayWithRange:range]];
    }
   
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

@end
