//
//  ExpertsDetailViewController.m
//  Health
//
//  Created by VickyCao on 11/21/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ExpertsDetailViewController.h"
#import "ExpertRequest.h"
#import "DTNetImageView.h"

@interface ExpertsDetailViewController () <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *detailTabelView;
    IBOutlet UITextView *submitTextView;
}

@end

@implementation ExpertsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    detailTabelView.delegate = self;
    detailTabelView.dataSource = self;
    [[ExpertRequest singleton] getExpertDetail:self.doctorID complete:^{
        [detailTabelView reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [submitTextView resignFirstResponder];
    }];
    [detailTabelView addGestureRecognizer:gesture];
}

- (void)commitComment {
    if (submitTextView.text.length == 0) {
        [submitTextView resignFirstResponder];
        [self.view makeToast:@"请输入内容"];
        return;
    }
    [[ExpertRequest singleton] postComment:submitTextView.text expertID:@"" complete:^{
        [self.view makeToast:@"提问成功"];
        submitTextView.text = @"";
        [submitTextView resignFirstResponder];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            
        case 1:
            return 1;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        ExpertDetail *detail = [ExpertRequest singleton].expertsDetail;
        if (indexPath.row == 0) {
            identifier = @"expertsInfo";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            DTNetImageView *headerView = [cell.contentView viewWithTag:1];
            UILabel *nameLabel = [cell.contentView viewWithTag:2];
            UILabel *titleLabel = [cell.contentView viewWithTag:3];
            UILabel *IDLabel = [cell.contentView viewWithTag:4];
            [headerView setImageWithUrlString:detail.headpic defaultImage:nil];
            nameLabel.text = detail.name;
            titleLabel.text = detail.title;
            IDLabel.text = [NSString stringWithFormat:@"医生编码: %@", detail.number];
        } else {
            identifier = @"expertsDetail";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *introLabel = [cell.contentView viewWithTag:1];
            introLabel.text = detail.introduce;
        }
    } else if (indexPath.section == 1) {
        identifier = @"referExperts";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UITextView *textView = [cell.contentView viewWithTag:1];
        if (!submitTextView) {
            submitTextView = textView;
            [submitTextView.layer setBorderColor:[rgb_color(153, 153, 153, 1) CGColor]];
            [submitTextView.layer setBorderWidth:0.5f];
            [submitTextView.layer setCornerRadius:5];
        } else {
            textView = submitTextView;
        }
        
        UIButton *button = [cell.contentView viewWithTag:2];
        [button addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchUpInside];
    } else if (indexPath.section == 2) {
        identifier = @"referExperts";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return 100;
            } else {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                UILabel *label = [cell.contentView viewWithTag:1];
                ExpertDetail *detail = [ExpertRequest singleton].expertsDetail;
                label.text = detail.introduce;

                [cell setNeedsUpdateConstraints];
                [cell updateConstraintsIfNeeded];
                return [detail.introduce heightForFont:label.font width:label.width]+60;
            }
        }
        case 1:
            return 216;
        case 2:
            break;
        default:
            break;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (void)detailView:(BOOL)isForHeight {
    
}

@end
