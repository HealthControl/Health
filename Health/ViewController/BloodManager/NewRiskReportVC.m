//
//  NewRiskReportVC.m
//  Health
//
//  Created by VickyCao on 1/23/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "NewRiskReportVC.h"
#import "BloodRequest.h"

@interface NewRiskReportVC () {
    IBOutlet UIWebView *webView;
}

@end

@implementation NewRiskReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    __weak typeof(self) weakSelf = self;
    [[BloodRequest singleton] getRiskReport:self.reportID complete:^{
        [weakSelf rebuiltData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)rebuiltData {
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[BloodRequest singleton].riskReportStr]]];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

@end
