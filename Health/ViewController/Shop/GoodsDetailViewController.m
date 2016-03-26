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
#import "BuyViewController.h"
#import "GoodsListViewController.h"
#import <MessageUI/MessageUI.h>

@interface GoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>{
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
    [dataArray addObjectsFromArray:@[@{@"【商品价格】":detail.price}, @{@"【商品规格】":detail.specification}, @{@"【商品介绍】":detail.newsDescription}, @{@"【详情描述】":detail.content}]];
    [goodsDetailTableView reloadData];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch ( result ) {
        case MessageComposeResultCancelled:
            [self.view makeToast:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self.view makeToast:@"发送失败"];
            break;
        case MessageComposeResultSent:
            [self.view makeToast:@"发送成功"];
            break;
        default:
            break;
    }
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

- (IBAction)addToChart:(id)sender {
    UIButton *t = (UIButton *)sender;
    NSDictionary *dic = @{@"userid": [UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"proid":self.goodsId, @"number":numberLabel.text};
    if (t.tag == 3) {
        // 进入购物车
        [self performSegueWithIdentifier:@"addToChart" sender:@(NO)];
        return;
    } else if (t.tag == 4) {
        // 找人代购
        if( [MFMessageComposeViewController canSendText] ){
            
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
            controller.messageComposeDelegate = self;
            controller.body = @"我已在平糖中已选好商品，请帮我付款";
            controller.title = @"平糖";
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            [self.view makeToast:@"设备没有短信功能"];
        }
    }
    
    [[GoodsRequest singleton] addToChart:dic complete:^{
        if (t.tag == 2) {
            // 加入购物车
            [GoodsRequest singleton].buyArray = nil;
            [self.view makeToast:@"加入成功"];
        } else if (t.tag == 1){
            // 立即购买
            [GoodsRequest singleton].buyArray = [NSMutableArray array];
            GoodsDetail *detail = [GoodsRequest singleton].goodsDetail;
            BuyDetail *buyDetail = [[BuyDetail alloc] init];
            buyDetail.id = detail.id;
            buyDetail.title = detail.title;
            buyDetail.price = [NSString stringWithFormat:@"%0.1f",[detail.price floatValue]*[numberLabel.text intValue]];
            buyDetail.number = [NSNumber numberWithInteger:[numberLabel.text integerValue]];
            buyDetail.specification = detail.specification;
            buyDetail.newsDescription = detail.newsDescription;
            
            buyDetail.thumb = detail.picture.count > 0?[detail.picture objectAtIndex:0]:@"";
            [[GoodsRequest singleton].buyArray addObject:buyDetail];
            [self performSegueWithIdentifier:@"lijigoumai" sender:self];
        }
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addToChart"]) {
        GoodsListViewController *listVC = [segue destinationViewController];
        listVC.isFromFav = [sender boolValue];
    }else if ([segue.identifier isEqualToString:@"lijigoumai"]) {
        BuyViewController *buyVC = [segue destinationViewController];
        buyVC.buyArray = [NSMutableArray arrayWithArray:[GoodsRequest singleton].buyArray];
    }
}

@end
