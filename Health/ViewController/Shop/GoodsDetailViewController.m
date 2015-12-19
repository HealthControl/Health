//
//  GoodsDetailViewController.m
//  Health
//
//  Created by VickyCao on 12/1/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsRequest.h"
#import "SDCycleScrollView.h"

@interface GoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *goodsDetailTableView;
    IBOutlet SDCycleScrollView *cycleScrollView;
    IBOutlet UILabel *numberLabel;
    NSMutableArray *dataArray;
}

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    goodsDetailTableView.delegate = self;
    goodsDetailTableView.dataSource = self;
    dataArray = [[NSMutableArray alloc] init];
    [self loadRequest];
}

- (void)loadRequest {
    [[GoodsRequest singleton] getGoodsDetailbyID:self.goodsId complete:^{
        [self reloadView];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadView {
    GoodsDetail *detail = [GoodsRequest singleton].goodsDetail;
    cycleScrollView.imageURLStringsGroup = detail.picture;
    cycleScrollView.autoScrollTimeInterval = 5;
    [dataArray addObjectsFromArray:@[@{@"【药品价格】":detail.price}, @{@"【药品规格】":detail.specification}, @{@"【药品介绍】":detail.newsDescription}, @{@"【详情描述】":detail.content}]];
    [goodsDetailTableView reloadData];
}

- (IBAction)addOrReduce:(id)sender {
    int number = [numberLabel.text intValue];
    NSInteger buttonTag = ((UIButton *)sender).tag;
    if (buttonTag == 1) {
        if (number > 1) {
            number--;
        } else {
            [self.view makeToast:@"个数不能小于1"];
        }
    } else {
        number++;
    }
    numberLabel.text = [NSString stringWithFormat:@"%d", number];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    GoodsDetail *detail = [GoodsRequest singleton].goodsDetail;
    if (indexPath.row == 0) {
        identifier = @"goodsName";
    } else {
        identifier = @"goodsIntro";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.row == 0) {
        UILabel *label = [cell.contentView viewWithTag:1];
        label.text = detail.title;
    } else {
        UILabel *label1 = [cell.contentView viewWithTag:1];
        UILabel *label2 = [cell.contentView viewWithTag:2];
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row-1];
        label1.text = [dic.allKeys firstObject];
        label2.text = [dic.allValues firstObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:2];
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row - 1];
    NSString *text = [[dic allValues] firstObject];
    label.text = text;
    [cell setNeedsUpdateConstraints];
    
    [cell updateConstraintsIfNeeded];
    
    return [text heightForFont:label.font width:label.width] + 30;
}

@end
