//
//  BloodInputResultViewController.m
//  Health
//
//  Created by VickyCao on 12/13/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "BloodInputResultViewController.h"
#import "BloodRequest.h"

@interface BloodInputResultViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *resultWebView;

@end

@implementation BloodInputResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [[BloodRequest singleton] getTestResultUrlID:self.resultID complete:^{
        [weakSelf.resultWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[BloodRequest singleton].resultUrl, [UserCentreData singleton].userInfo.userid]]]];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
    
    self.title = @"测量结果";
}


@end
