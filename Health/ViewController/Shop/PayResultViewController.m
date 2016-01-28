//
//  PayResultViewController.m
//  Health
//
//  Created by VickyCao on 11/27/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "PayResultViewController.h"

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)payAgain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanGoods:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
