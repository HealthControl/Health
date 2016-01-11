//
//  RIskHeightVC.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RIskHeightVC.h"
#import "RiskModel.h"
#import "CustomRuleView.h"

@implementation RIskHeightVC {
    IBOutlet UIImageView *sexImageView;
    IBOutlet UILabel *heightLabel;
    
    IBOutlet CustomRuleView *heightRule;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[RiskModel singleton].sex isEqualToString:@"1"]) {
        sexImageView.image = [UIImage imageNamed:@"male"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"female"];
    }
    
    [heightLabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [heightLabel.layer setBorderWidth:0.5f];
    
    heightRule.transform = CGAffineTransformMakeRotation(M_PI*90);
    heightRule.maximumValue = 260;
    heightRule.minimumValue = 50;
    heightRule.backImage = [UIImage imageNamed:@"shengao"];
    heightRule.value = 170;
    heightLabel.text = [NSString stringWithFormat:@"%0.f",heightRule.value];
    heightRule.ruleDirction = RuleDirection_H;
    __weak typeof(self) weakSelf = self;
    heightRule.onvalueChange = ^(float value) {
        [weakSelf sliderValueChange:value];
    };
//    heightSlider.transform = CGAffineTransformMakeRotation(90);
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    [RiskModel singleton].height = heightLabel.text;
}

- (void)sliderValueChange:(float)sender {
    heightLabel.text = [NSString stringWithFormat:@"%0.f",heightRule.value];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

@end
