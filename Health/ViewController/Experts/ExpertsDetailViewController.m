//
//  ExpertsDetailViewController.m
//  Health
//
//  Created by VickyCao on 11/21/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ExpertsDetailViewController.h"

@interface ExpertsDetailViewController () <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *detailTabelView;
}

@end

@implementation ExpertsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    detailTabelView.delegate = self;
    detailTabelView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifier = @"expertsInfo";
        } else {
            identifier = @"exptersDetail";
        }
    } else if (indexPath.section == 1) {
        identifier = @"referExperts";
    } else if (indexPath.section == 2) {
        identifier = @"referExperts";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

@end
