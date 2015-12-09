//
//  GoodsDetailViewController.m
//  Health
//
//  Created by VickyCao on 12/1/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsRequest.h"

@interface GoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *goodsDetailTableView;
}

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    goodsDetailTableView.delegate = self;
    goodsDetailTableView.dataSource = self;
    [self loadRequest];
}

- (void)loadRequest {
    [[GoodsRequest singleton] getGoodsDetailbyID:self.goodsId complete:^{
        [goodsDetailTableView reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    GoodsDetail *detail = [GoodsRequest singleton].goodsDetail;
    switch (indexPath.row) {
        case 0:
            identifier = @"goodsName";
            break;
        case 1:
            identifier = @"goodsName";
            break;
        case 2:
        case 3:
        case 4:
        case 5:
            identifier = @"goodsIntro";
            break;
        case 6:
            identifier = @"goodsNumber";
            break;
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            UILabel *label = [cell.contentView viewWithTag:1];
            label.text = detail.title;
        }
            break;
        case 2: {
            UILabel *label1 = [cell.contentView viewWithTag:1];
            UILabel *label2 = [cell.contentView viewWithTag:2];
            label1.text = @"【药品价格】";
            label2.text = detail.price;
            
        }
        case 3:
        {
            UILabel *label1 = [cell.contentView viewWithTag:1];
            UILabel *label2 = [cell.contentView viewWithTag:2];
            label1.text = @"【药品规格】";
            label2.text = detail.specification;
            
        }
        case 4:
        {
            UILabel *label1 = [cell.contentView viewWithTag:1];
            UILabel *label2 = [cell.contentView viewWithTag:2];
            label1.text = @"【药品介绍】";
//            label2.text = detail.description;
            
        }
        case 5:
        {
            UILabel *label1 = [cell.contentView viewWithTag:1];
            UILabel *label2 = [cell.contentView viewWithTag:2];
            label1.text = @"【详情描述】";
            label2.text = detail.content;
            
        }
            break;
        case 6:
            identifier = @"goodsNumber";
            break;
        default:
            break;
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
