//
//  RiskWaistVC.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskWaistVC.h"
#import "RiskModel.h"
#import "CustomRuleView.h"

@implementation RiskWaistVC{
    IBOutlet UIImageView *sexImageView;
    IBOutlet UILabel *waistLabel;
    IBOutlet CustomRuleView *waistRuleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[RiskModel singleton].sex isEqualToString:@"1"]) {
        sexImageView.image = [UIImage imageNamed:@"male"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"female"];
    }
    
    [waistLabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [waistLabel.layer setBorderWidth:0.5f];
    
    waistRuleView.maximumValue = 6;
    waistRuleView.minimumValue = 0;
    waistRuleView.backImage = [UIImage imageNamed:@"yaowei"];
    waistRuleView.value = 2;
    waistLabel.text = [NSString stringWithFormat:@"%0.1f",waistRuleView.value];
    __weak typeof(self) weakSelf = self;
    waistRuleView.onvalueChange = ^(float value) {
        [weakSelf sliderValueChange:value];
    };
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    [RiskModel singleton].waist = waistLabel.text;
}

- (void)sliderValueChange:(float)sender {
    waistLabel.text = [NSString stringWithFormat:@"%0.1f",waistRuleView.value];
}


-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

@end
