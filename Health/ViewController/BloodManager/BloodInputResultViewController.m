//
//  BloodInputResultViewController.m
//  Health
//
//  Created by VickyCao on 12/13/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "BloodInputResultViewController.h"

@interface BloodInputResultViewController () {
    IBOutlet UILabel *timelLabel;
    IBOutlet UILabel *mmLabel;
    IBOutlet UILabel *resultLabel;
    IBOutlet UIView  *bottomView;
}

@end

@implementation BloodInputResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.resultDic[@"addtime"] floatValue]];
    timelLabel.text = [date stringWithFormat:@"MM月dd日   HH:mm"];
    mmLabel.text = self.resultDic[@"value"];
    resultLabel.text = self.resultDic[@"reminder"];
//    resultLabel.text = [self result:mmLabel.text];
    [bottomView.layer setBorderWidth:0.5f];
    [bottomView.layer setBorderColor:[rgb_color(204, 204, 204, 1) CGColor]];
}

- (NSString *)result:(NSString *)value {
    NSString *result = @"正常";
    float floatValue = [value floatValue];
    if (floatValue < 4) {
        result = @"偏低";
    }
    if (floatValue > 6) {
        result = @"偏高";
    }
    return result;
}

@end
