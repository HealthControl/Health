//
//  GoodListTableView.m
//  Health
//
//  Created by VickyCao on 11/27/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "GoodListTableView.h"
#import "GoodsListCell.h"

@interface GoodListTableView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation GoodListTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.dataSource = self;
    self.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"goodsCell";
    GoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45)];
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:selectButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithRed:229/255.0 green:87/255.0 blue:87/255.0 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:titleLabel];
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor colorWithRed:229/255.0 green:87/255.0 blue:87/255.0 alpha:1];
    priceLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:priceLabel];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:deleteButton];
    return view;
}

@end
