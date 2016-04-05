//
//  FriendsDetailViewController.m
//  Health
//
//  Created by VickyCao on 1/10/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "FriendsDetailViewController.h"
#import "MineRequest.h"
#import "DTNetImageView.h"
#import "GoodsBuyListCell.h"
#import "GoodsList.h"
#import "BuyViewController.h"

@interface UserinfoCell : UITableViewCell {
    IBOutlet DTNetImageView *userHeaderImageView;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *relationLabel;
    IBOutlet UILabel *timeLabel;
}

@end

@implementation UserinfoCell

- (void)cellForDic:(NSDictionary *)dic {
    userNameLabel.text = dic[@"username"];
    relationLabel.text = dic[@"relation"];
    timeLabel.text = dic[@"updatedate"];
    [userHeaderImageView setImageWithUrl:[NSURL URLWithString:dic[@"userpic"]] defaultImage:nil];
}

@end

@interface UserBloodCell : UITableViewCell {
    IBOutlet UILabel *yesterdayLabel;
    IBOutlet UILabel *todayLabel;
    IBOutlet UILabel *averageLabel;
}

@end

@implementation UserBloodCell

- (void)cellForDic:(NSDictionary *)dic {
    yesterdayLabel.text = [NSString stringWithFormat:@"%@mmol/L", dic[@"bloodsugar_yesterday"]];
    todayLabel.text = [NSString stringWithFormat:@"%@mmol/L", dic[@"bloodsugar_today"]];
    averageLabel.text = [NSString stringWithFormat:@"%@mmol/L", dic[@"bloodsugar_week"]];
}

@end

@interface FriendsDetailViewController() <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *friendsDetailTableView;
    IBOutlet UIButton *totalButton;
    
    NSMutableArray *buyTotalArray;
}

@property (nonatomic, strong) NSMutableArray *payArray;

@end

@implementation FriendsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    friendsDetailTableView.delegate = self;
    friendsDetailTableView.dataSource = self;
    
    buyTotalArray = [NSMutableArray array];
    self.payArray = [NSMutableArray array];
    friendsDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[MineRequest singleton] getFriendsBlood:self.friendsDic[@"mobile"] complete:^{
        [friendsDetailTableView reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
    [self reloadData];
    [totalButton setTitle:@"实付: 0.00" forState:UIControlStateNormal];
}

- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    [[MineRequest singleton] getPayListMobile:self.friendsDic[@"mobile"] complete:^{
        if ([MineRequest singleton].payList&&[MineRequest singleton].payList.count > 0) {
            [weakSelf.payArray removeAllObjects];
            [weakSelf.payArray addObjectsFromArray:[MineRequest singleton].payList];
            [friendsDetailTableView reloadData];
        }
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)getTotal {
    float total = 0;
    [buyTotalArray removeAllObjects];
    for (BuyDetail *d in self.payArray) {
        if (d.isSelected) {
            total += [d.number intValue]*[d.price floatValue];
            [buyTotalArray addObject:d];
        }
    }
    NSLog(@"total :%@",[NSString stringWithFormat:@"实付: %0.2f",total]);
    [totalButton setTitle:[NSString stringWithFormat:@"实付:￥ %0.2f",total] forState:UIControlStateDisabled];
    //    self.totalLabel.text = [NSString stringWithFormat:@"实付: %0.2f",total];
}

- (void)deleteData:(id)data {
    BuyDetail *detail = data[@"data"];
    @weakify(self)
    [[MineRequest singleton] deleteFriendsGoods:self.friendsDic[@"mobile"] proid:detail.id complete:^{
        @strongify(self)
        [self reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        @strongify(self)
        [self.view makeToast:errmsg];
    }];
}

- (IBAction)toBuy:(id)sender {
    if (buyTotalArray.count > 0) {
        [self performSegueWithIdentifier:@"favToBuy" sender:self];
    } else {
        [self.view makeToast:@"请选择要购买的产品"];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_payArray.count > 0) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
        case 1:
            row = 1;
            break;
        case 2:
            row = _payArray.count;
            break;
        default:
            break;
    }
    return row;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"代付";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 205;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"";
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            identifier = @"userinfoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [(UserinfoCell *)cell cellForDic:[MineRequest singleton].friendsBloodUrl];
            break;
        case 1:
            identifier = @"userbloodCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [(UserBloodCell *)cell cellForDic:[MineRequest singleton].friendsBloodUrl];
            break;
        case 2:{
            identifier = @"goodslistCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            ((GoodsBuyListCell *)cell).isFriends = YES;
            [(GoodsBuyListCell *)cell cellForBuyDetail:self.payArray[indexPath.row]];
            
            __weak typeof(self) weakSelf = self;
            ((GoodsBuyListCell *)cell).onButtonPress = ^(id data) {
                NSString *event = ((NSDictionary *)data)[@"event"];
                if ([event isEqualToString:@"delete"]) {
                    [weakSelf deleteData:data];
                }  else if ([event isEqualToString:@"select"]) {
                    [weakSelf getTotal];
                }
            };
        }
            break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case 0:
        case 1:
            height = 5;
            break;
        case 2:
            height = 25;
            break;
        default:
            break;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0.01f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"favToBuy"]) {
        BuyViewController *buyVC = [segue destinationViewController];
        buyVC.buyArray = [NSMutableArray arrayWithArray:buyTotalArray];
    }
}

@end
