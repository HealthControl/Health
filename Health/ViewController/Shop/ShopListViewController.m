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
#import "GoodsDetailViewController.h"

@interface GoodsCell : UITableViewCell {
    IBOutlet UIControl *goodsView1;
    IBOutlet UIControl *goodsView2;
    
    IBOutlet DTNetImageView *goodsImageView1;
    IBOutlet UILabel        *goodsPriceLabel1;
    IBOutlet UILabel        *goodsNameLabel1;
    
    IBOutlet DTNetImageView *goodsImageView2;
    IBOutlet UILabel        *goodsPriceLabel2;
    IBOutlet UILabel        *goodsNameLabel2;
    
    NSString                *selectID;
    
    NSArray                 *dataArray;
}

@property (nonatomic, copy) void (^onEvent)(NSString *goodsID);

- (void)cellForGoods:(NSArray *)goodsArray;

@end

@implementation GoodsCell

- (void)cellForGoods:(NSArray *)goodsArray {
    dataArray = [NSArray arrayWithArray:goodsArray];
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

- (IBAction)goodsSelect:(id)sender {
    GoodsList *list = [dataArray objectAtIndex:((UIControl *)sender).tag - 1];
    if (self.onEvent) {
        self.onEvent(list.id);
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
    
    IBOutlet UIView         *lineview1;
    IBOutlet UIView         *lineview2;
    IBOutlet UIView         *lineview3;
    
    BOOL cantouch;
}

@property (nonatomic, strong) NSString                *currentID;

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    goodsArray = [NSMutableArray array];
    self.title = @"商城";
    cantouch = NO;
    [[GoodsRequest singleton] getGoodsTypeAndcomplete:^{
        [self reloadTypeView];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
    [self reloadLineView:1];
}

- (void)reloadTypeView {
    cantouch = YES;
    NSArray *array = [NSArray arrayWithArray:[GoodsRequest singleton].goodsTypeArray];
    NSArray *viewArray = @[@{@"image":classImageView1, @"label":classNameLabel1}, @{@"image":classImageView2, @"label":classNameLabel2}, @{@"image":classImageView3, @"label":classNameLabel3}];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = viewArray[i];
        GoodsType *type = array[i];
        DTNetImageView *image = dic[@"image"];
        [image setImageWithUrlString:type.icon defaultImage:nil];
        UILabel *label = dic[@"label"];
        label.text = type.name;
    }
    GoodsType *firstType = array[0];
    [[GoodsRequest singleton] getGoodsList:firstType.id complete:^{
        [self reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadData {
    [goodsArray addObjectsFromArray:[GoodsRequest singleton].goodsListArray];
    [shopListTableView reloadData];
}

- (void)reloadLineView:(NSInteger)tag {
    UIColor *unselectColor = rgb_color(153, 153, 153, 1);
    UIColor *selectColor = rgb_color(229, 87, 87, 1);
    switch (tag) {
        case 1:
            lineview1.backgroundColor = selectColor;
            lineview2.backgroundColor = unselectColor;
            lineview3.backgroundColor = unselectColor;
            break;
        case 2:
            lineview1.backgroundColor = unselectColor;
            lineview2.backgroundColor = selectColor;
            lineview3.backgroundColor = unselectColor;
            break;
        case 3:
            lineview1.backgroundColor = unselectColor;
            lineview2.backgroundColor = unselectColor;
            lineview3.backgroundColor = selectColor;
            break;
        default:
            break;
    }
}

#pragma mark - IBAction
- (IBAction)classSelected:(id)sender {
    if (!cantouch) {
        return;
    }
    UIControl *controlView = (UIControl *)sender;
    [self reloadLineView:controlView.tag];
    [goodsArray removeAllObjects];
    [shopListTableView reloadData];
    __weak typeof(self) weakSelf = self;
    GoodsType *type = [[GoodsRequest singleton].goodsTypeArray objectAtIndex:(controlView.tag - 1)];
    [[GoodsRequest singleton] getGoodsList:type.id complete:^{
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
        __weak typeof(self) weakSelf = self;
        cell.onEvent = ^(NSString *goodsID) {
            weakSelf.currentID = goodsID;
            [weakSelf performSegueWithIdentifier:@"goodsDetail" sender:weakSelf];
            
        };
    }
   
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    GoodsDetailViewController *goodsDetailVC = [segue destinationViewController];
    goodsDetailVC.goodsId = self.currentID;
}

@end
