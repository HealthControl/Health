//
//  RiskReportVC.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskReportVC.h"
#import "BloodRequest.h"

@interface RiskReportVC () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *reportTableView;
    NSArray *sectionTitle;
    NSMutableArray *dataArray;
}

@end

@implementation RiskReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    reportTableView.delegate = self;
    reportTableView.dataSource = self;
    dataArray = [NSMutableArray array];
    sectionTitle = @[@"评估结论:", @"风险因素分析:", @"平糖为您制定以下目标:"];
    __weak typeof(self) weakSelf = self;
    [[BloodRequest singleton] getRiskReport:@"14" complete:^{
        [weakSelf rebuiltData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)rebuiltData {
    NSDictionary *reportDic =[BloodRequest singleton].riskReportDic;
    NSDictionary *dic1 = @{@"title":@"评估结论:",@"data":@[reportDic[@"conclusion"]]};
    NSDictionary *dic2 = @{@"title":@"风险因素分析:",@"data":@[[NSString stringWithFormat:@"不可控风险因素:%@",reportDic[@"uncontrollable"]], [NSString stringWithFormat:@"可控风险因素:%@",reportDic[@"controllable"]]]};
//    [NSString stringWithFormat:@"近期目标：%@",reportDic[@"goal_short"]];
    NSDictionary *dic3 = @{@"title":@"评估结论:",@"data":@[[NSString stringWithFormat:@"近期目标:%@",reportDic[@"goal_short"]], [NSString stringWithFormat:@"远期目标:%@",reportDic[@"goal_long"]]]};
    [dataArray addObject:dic1];
    [dataArray addObject:dic2];
    [dataArray addObject:dic3];
    [reportTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = dataArray[section];
    NSArray *array = dic[@"data"];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifiter = @"reportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    NSDictionary *dic = dataArray[indexPath.section];
    NSArray *reportArray = dic[@"data"];
    NSString *title = reportArray[indexPath.row];
    UILabel *label = [cell.contentView viewWithTag:1];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    //设置字体
    [attrString addAttribute:NSForegroundColorAttributeName value:rgb_color(51, 204, 204, 1) range:[title rangeOfString:@"不可控风险因素:"]];
    [attrString addAttribute:NSForegroundColorAttributeName value:rgb_color(51, 204, 204, 1) range:[title rangeOfString:@"可控风险因素:"]];
    [attrString addAttribute:NSForegroundColorAttributeName value:rgb_color(51, 204, 204, 1) range:[title rangeOfString:@"远期目标:"]];
    [attrString addAttribute:NSForegroundColorAttributeName value:rgb_color(51, 204, 204, 1) range:[title rangeOfString:@"近期目标:"]];
    
    label.attributedText = attrString;
    return cell;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = dataArray[section];
    return dic[@"title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:1];
    
    NSDictionary *dic = dataArray[indexPath.section];
    NSArray *reportArray = dic[@"data"];
    NSString *title = reportArray[indexPath.row];
    label.text = title;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return [title heightForFont:label.font width:label.width]+40;
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

@end
