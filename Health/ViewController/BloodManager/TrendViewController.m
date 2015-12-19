//
//  TrendViewController.m
//  Health
//
//  Created by VickyCao on 12/14/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "TrendViewController.h"
#import "BloodRequest.h"

@interface TrendViewController() {
    IBOutlet UIWebView *webView;
}

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BloodRequest singleton] getTrend:^{
        [self reloadWebView];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadWebView {
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[BloodRequest singleton].trendURL]]];
}

@end
