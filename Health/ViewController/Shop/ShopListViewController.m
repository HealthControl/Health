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
    // 商品列表
    IBOutlet UITableView *shopListTableView;
    NSMutableArray *goodsArray;
    
    // 类型
    IBOutlet DTNetImageView *classImageView1;
    IBOutlet DTNetImageView *classImageView2;
    IBOutlet DTNetImageView *classImageView3;
    
    IBOutlet UILabel        *classNameLabel1;
    IBOutlet UILabel        *classNameLabel2;
    IBOutlet UILabel        *classNameLabel3;
}

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    goodsArray = [NSMutableArray array];
    self.title = @"商城";
    [[GoodsRequest singleton] getGoodsTypeAndcomplete:^{
        [self reloadTypeView];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadTypeView {
    NSArray *array = [NSArray arrayWithArray:[GoodsRequest singleton].goodsTypeArray];
    NSArray *viewArray = @[@{@"image":classImageView1, @"label":classNameLabel1}, @{@"image":classImageView2, @"label":classNameLabel2}, @{@"image":classImageView3, @"label":classNameLabel3}];
    for (int i = 0; i < array.count; i++) {
        if (viewArray.count > i+1) {
            NSDictionary *dic = viewArray[i];
            GoodsType *type = array[i];
            DTNetImageView *image = dic[@"image"];
            [image setImageWithUrlString:type.icon defaultImage:nil];
            UILabel *label = dic[@"label"];
            label.text = type.name;
        }
    }
}

- (void)reloadData {
    [goodsArray removeAllObjects];
    [goodsArray addObjectsFromArray:[GoodsRequest singleton].goodsListArray];
    [shopListTableView reloadData];
}

#pragma mark - IBAction
- (IBAction)classSelected:(id)sender {
    UIControl *controlView = (UIControl *)sender;
    __weak typeof(self) weakSelf = self;
    [[GoodsRequest singleton] getGoodsList:[NSString stringWithFormat:@"%d", (int)controlView.tag] complete:^{
        [weakSelf reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
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
