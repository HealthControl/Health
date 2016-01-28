//
//  RiskAssessmentViewController.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskAssessmentViewController.h"
#import "RiskModel.h"
#import "BloodRequest.h"
#import "CustomButton.h"

@interface RiskAssessmentViewController () <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *riskTableView;
    NSMutableArray *dataArray;
    NSMutableDictionary *buttonDic;
    
    NSString *confirmDate;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIView *backView;
}

@end

@implementation RiskAssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buttonDic = [NSMutableDictionary dictionary];
    riskTableView.delegate = self;
    riskTableView.dataSource = self;
    dataArray = [NSMutableArray array];
    datePicker.maximumDate = [NSDate date];
    __weak typeof(self) weakSelf = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [weakSelf removeDatePicker];
    }];
    [backView addGestureRecognizer:tapGesture];
    
    [[BloodRequest singleton] getRiskContent:^{
        [weakSelf reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    datePicker.superview.frame = CGRectMake(0, riskTableView.bottom, datePicker.width, datePicker.height);
}

- (void)reloadData {
    [dataArray addObjectsFromArray:[BloodRequest singleton].riskContentArray];
    [riskTableView reloadData];
}

- (void)showPicker {
    [UIView animateWithDuration:0.25 animations:^{
        datePicker.superview.transform = CGAffineTransformMakeTranslation(0, -datePicker.height);
    }];
    backView.hidden = NO;
}

- (void)removeDatePicker {
    backView.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        datePicker.superview.transform = CGAffineTransformIdentity;
    }];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

- (void)btnSelect:(CustomButton *)btn {
    NSDictionary *btnData = btn.customObject;// [buttonDic valueForKey:btn.description];
    NSIndexPath *index = btnData[@"index"];
    if (!index) {
        return;
    }
    NSDictionary *dic = dataArray[index.section];
    NSString *contentKey;
    NSString *contentValue;
    if ([dic[@"child"] integerValue] > 0) {
        NSArray *sonArray = dic[@"son"];
        NSDictionary *sonDic = sonArray[0];
        NSArray *childArray = sonDic[@"option"];
        NSDictionary *childDic = nil;
        if (index.row < childArray.count+1) {
            childDic = childArray[index.row-1];
            contentKey = childDic[@"id"];
        } else {
            sonDic = sonArray[1];
            NSArray *childArray2 = sonDic[@"option"];
            childDic = childArray2[index.row - childArray.count-2];
            contentKey = childDic[@"id"];
        }
        contentValue = sonDic[@"id"];
    } else {
        NSArray *childArray = dic[@"option"];
        NSDictionary *childDic = childArray[index.row];
        contentKey = childDic[@"id"];
        contentValue = dic[@"id"];
    }
    
    NSString *savedValue = [[RiskModel singleton].contentDic objectForKey:contentValue];
    if (savedValue && [savedValue isEqualToString:contentKey]) {
        btn.selected = NO;
        [[RiskModel singleton].contentDic removeObjectForKey:contentValue];
    } else {
        btn.selected = YES;
        [[RiskModel singleton].contentDic setObject:contentKey forKey:contentValue];
    }
    
    [riskTableView reloadSection:index.section withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)valueChanged:(id)sender {
    confirmDate = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
    for (id obj in buttonDic.allKeys) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)obj;
            [riskTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            NSDictionary *dic = dataArray[indexPath.section];
            [[RiskModel singleton].contentDic setObject:confirmDate forKey:dic[@"id"]];
            return;
        }
    }
}

- (void)submit {
    NSMutableString *str = [NSMutableString stringWithString:@""];
    if ([RiskModel singleton].contentDic.allKeys.count > 0) {
        for (NSString *keys in [RiskModel singleton].contentDic.allKeys) {
            [str appendFormat:@"%@,%@;", keys, [[RiskModel singleton].contentDic objectForKey:keys]];
        }
        [str replaceCharactersInRange:NSMakeRange(str.length-1, 1) withString:@""];
        [RiskModel singleton].content = str;
    }
    
    NSDictionary *postDic = (NSDictionary *)[[RiskModel singleton] modelToJSONObject];
    [[BloodRequest singleton] postRiskData:postDic complete:^{
        [self performSegueWithIdentifier:@"getResult" sender:self];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataArray.count == section) {
        return 1;
    }
    NSDictionary *dic = dataArray[section];
    if ([dic[@"child"] integerValue] > 0) {
        if (![dic[@"son"] isKindOfClass:[NSNull class]]) {
            NSArray *sonArray = dic[@"son"];
            NSInteger total = sonArray.count;
            for (NSDictionary *dic in sonArray) {
                if (![dic[@"option"] isKindOfClass:[NSNull class]]) {
                    NSArray *childArray = dic[@"option"];
//                    total+=ceilf(childArray.count/2.0);
                    total+=childArray.count;
                }
            }
            return total;
        }
    } else {
        if (![dic[@"option"] isKindOfClass:[NSNull class]]) {
            NSArray *childArray = dic[@"option"];
            NSInteger total = 0;
            total+=childArray.count;
//            total+=ceilf(childArray.count/2.0);
            return total;
        } else {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == dataArray.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"commitcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    NSString *identifiter = @"radiosingle";
    NSDictionary *dic = dataArray[indexPath.section];
    if ([dic[@"child"] integerValue] > 0) {
        NSArray *sonArray = dic[@"son"];
        NSDictionary *sonDic = sonArray[0];
        NSArray *childArray = sonDic[@"option"];
        if (indexPath.row == 0 || indexPath.row == childArray.count+1) {
            identifiter = @"titleCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
            UILabel *label = [cell.contentView viewWithTag:1];
            label.text = sonDic[@"title"];
            return cell;
        } else {
            NSDictionary *childDic = nil;
            if (indexPath.row < childArray.count+1) {
                childDic = childArray[indexPath.row-1];
            } else {
                sonDic = sonArray[1];
                NSArray *childArray2 = sonDic[@"option"];
                childDic = childArray2[indexPath.row - childArray.count-2];
            }
            
            cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
            CustomButton *btn = [cell.contentView viewWithTag:1];
            [btn setTitle:childDic[@"title"] forState:UIControlStateNormal];
            NSString *value = [[RiskModel singleton].contentDic objectForKey:sonDic[@"id"]];
            if (value && [value isEqualToString:childDic[@"id"]]) {
                btn.selected = YES;
            } else {
                btn.selected = NO;
            }
            [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
            btn.customObject =  @{@"data": childDic, @"index":indexPath};
//            [buttonDic setObject:@{@"data": childDic, @"index":indexPath} forKey:btn.description];
            
            return cell;
        }
//        cell
    } else {
        if ([dic[@"option"] isKindOfClass:[NSNull class]]) {
            identifiter = @"titleCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
            UILabel *label = [cell.contentView viewWithTag:1];
            if (confirmDate && ![confirmDate isEqualToString:@""]) {
                label.text = confirmDate;
            } else {
                label.text = @"请选择";
            }
            [buttonDic setObject:dic forKey:indexPath];
            return cell;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
        CustomButton *btn = [cell.contentView viewWithTag:1];
        NSArray *childArray = dic[@"option"];
        NSDictionary *childDic = childArray[indexPath.row];
        [btn setTitle:childDic[@"title"] forState:UIControlStateNormal];
        NSString *value = [[RiskModel singleton].contentDic objectForKey:dic[@"id"]];
        if (value && [value isEqualToString:childDic[@"id"]]) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
        [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.customObject = @{@"data": childDic, @"index":indexPath};
//        [buttonDic setObject:@{@"data": childDic, @"index":indexPath} forKey:btn.description];
//        btn.customOBJ = @{@"data": childDic, @"index":indexPath};
        
    }
    return cell;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == dataArray.count) {
        return nil;
    }
    NSDictionary *dic = dataArray[section];
    return dic[@"title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == dataArray.count) {
        return 0.01f;
    }
    NSDictionary *dic = dataArray[section];
    NSString *title = dic[@"title"];
    return [title heightForFont:[UIFont systemFontOfSize:15] width:self.view.width - 30]+10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == dataArray.count) {
        [self submit];
        return;
    }
    NSDictionary *dic = dataArray[indexPath.section];
    if ([dic[@"child"] integerValue] == 0) {
        if ([dic[@"option"] isKindOfClass:[NSNull class]]) {
            [self showPicker];
        }
    }
}

@end
