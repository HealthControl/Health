//
//  RiskWeightVC.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskWeightVC.h"
#import "RiskModel.h"
#import "CustomRuleView.h"

@implementation RiskWeightVC {
    IBOutlet UIImageView *sexImageView;
    IBOutlet CustomRuleView *weightRuleView;
    IBOutlet UILabel *weightLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[RiskModel singleton].sex isEqualToString:@"1"]) {
        sexImageView.image = [UIImage imageNamed:@"male"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"female"];
    }
    
    [weightLabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [weightLabel.layer setBorderWidth:0.5f];
    
    weightRuleView.maximumValue = 200;
    weightRuleView.minimumValue = 0;
    weightRuleView.backImage = [UIImage imageNamed:@"tizhong"];
    weightRuleView.value = 50;
    weightLabel.text = [NSString stringWithFormat:@"%0.f",weightRuleView.value];
    __weak typeof(self) weakSelf = self;
    weightRuleView.onvalueChange = ^(float value) {
        [weakSelf sliderValueChange:value];
    };
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    [RiskModel singleton].weight = weightLabel.text;
}

- (void)sliderValueChange:(float)sender {
    weightLabel.text = [NSString stringWithFormat:@"%0.f",sender];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

@end
