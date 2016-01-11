//
//  ChoiseAddressViewController.m
//  Health
//
//  Created by VickyCao on 12/26/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ChoiseAddressViewController.h"
#import "GoodsRequest.h"
#import "ModifyAddressViewController.h"
#import "CustomButton.h"

@interface ChoiseAddressViewController() <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *addressTableView;
    NSMutableArray *dataArray;
}

@end

@implementation ChoiseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    addressTableView.delegate = self;
    addressTableView.dataSource = self;
    [addressTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self doRequest];
}

- (void)doRequest {
    [dataArray removeAllObjects];
    [[GoodsRequest singleton] getAddress:^{
        [dataArray addObjectsFromArray:[GoodsRequest singleton].addressArray];
        [addressTableView reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)setDefaults:(id)sender {
    NSDictionary *dic = ((CustomButton *)sender).customObject;
    [[GoodsRequest singleton] setDefaultsAddress:dic[@"id"] complete:^{
        [self.view makeToast:@"设置成功"];
        [self doRequest];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"addressListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UILabel *label1 = [cell.contentView viewWithTag:1];
    UILabel *label2 = [cell.contentView viewWithTag:2];
    CustomButton *customButton = [cell.contentView viewWithTag:3];
    [customButton addTarget:self action:@selector(setDefaults:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    customButton.customObject = dic;
    if ([dic[@"isdefault"] boolValue]) {
        [customButton setBackgroundColor:rgb_color(229, 87, 87, 1)];
    } else {
        [customButton setBackgroundColor:rgb_color(51, 51, 51, 1)];
    }
    label1.text = [NSString stringWithFormat:@"%@   %@", dic[@"name"], dic[@"mobile"]];
    label2.text = [NSString stringWithFormat:@"%@", dic[@"address"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = dataArray[indexPath.row];
    [GoodsRequest singleton].addressDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if (self.select) {
        self.select();
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = dataArray[indexPath.row];
    [self performSegueWithIdentifier:@"modify" sender:dic];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ModifyAddressViewController *modifyVC = [segue destinationViewController];
    modifyVC.select = self.select;
    modifyVC.addressDic = (NSDictionary *)sender;
}

@end
