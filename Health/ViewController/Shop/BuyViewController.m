//
//  BuyViewController.m
//  Health
//
//  Created by VickyCao on 12/12/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "BuyViewController.h"

@interface BuyViewController () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *buyTableView;
}
@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buyTableView.delegate = self;
    buyTableView.dataSource = self;
}

@end
