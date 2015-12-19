//
//  ZhibiaoViewController.m
//  Health
//
//  Created by VickyCao on 12/14/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ZhibiaoViewController.h"
#import "BloodRequest.h"

@interface ZhibiaoViewController () {
    IBOutlet UILabel *normalLabel;
    IBOutlet UILabel *unNormalLabel;
    IBOutlet UILabel *highBloodLabel;
    IBOutlet UILabel *normalHighLabel;
    IBOutlet UILabel *normalLowLabel;
    IBOutlet UILabel *lowBloodLabel;
    IBOutlet UILabel *preLabel;
}

@end

@implementation ZhibiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BloodRequest singleton] getZhibiao:^{
        [self reloadView];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadView {
    NSDictionary *resultDic = [BloodRequest singleton].indicatorDic;
    normalLabel.text = [NSString stringWithFormat:@"%d", [resultDic[@"normal"] intValue]];
    unNormalLabel.text = [NSString stringWithFormat:@"%d", [resultDic[@"abnormal"] intValue]];
    highBloodLabel.text = [NSString stringWithFormat:@"%d", [resultDic[@"high"] intValue]];
    normalHighLabel.text = [NSString stringWithFormat:@"%d", [resultDic[@"normal_high"] intValue]];
    normalLowLabel.text = [NSString stringWithFormat:@"%d", [resultDic[@"normal_low"] intValue]];
    lowBloodLabel.text = [NSString stringWithFormat:@"%d", [resultDic[@"low"] intValue]];
    preLabel.text = resultDic[@"alert"];
}

@end
