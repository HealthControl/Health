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
    sectionTitle = @[@"风险预警:", @"风险因素分析:", @"报告建议:", @"用药与治疗建议:", @"运动与饮食建议:"];
    __weak typeof(self) weakSelf = self;
    [[BloodRequest singleton] getWarning:^{
        [weakSelf rebuiltData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)rebuiltData {
    NSDictionary *reportDic = [BloodRequest singleton].warningDic;
    for (int i = 0; i < reportDic.allKeys.count; i++) {
        NSString *value = reportDic.allValues[i];
        NSDictionary *dic;
        if (i < sectionTitle.count) {
            dic = @{@"title":sectionTitle[i], @"data":value};
        } else {
            dic = @{@"title":@"", @"data":value};
        }
        [dataArray addObject:dic];
    }
    [reportTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifiter = @"reportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    NSDictionary *dic = dataArray[indexPath.section];
//    NSArray *reportArray = dic[@"data"];
    NSString *title = dic[@"data"];
    UILabel *label = [cell.contentView viewWithTag:1];
    label.text = title;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
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
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    UILabel *label = [cell.contentView viewWithTag:1];
    
    NSDictionary *dic = dataArray[indexPath.section];
    NSString *title = dic[@"data"];
//    label.text = title;
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
    float height = ([title heightForFont:[UIFont systemFontOfSize:14] width:self.view.width - 30])+40;
    return height;
}

//-(BOOL)navigationShouldPopOnBackButton{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    return YES;
//}

@end
