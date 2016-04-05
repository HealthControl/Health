//
//  ShouSuoViewController.m
//  Health
//
//  Created by 朵朵 on 16/4/6.
//  Copyright © 2016年 vickycao1221. All rights reserved.
//

#import "ShouSuoViewController.h"
#import "CustomRuleView.h"
#import "RiskModel.h"

@interface ShouSuoViewController () {
    IBOutlet UIImageView *sexImageView;
    IBOutlet UILabel *waistLabel;
    IBOutlet CustomRuleView *waistRuleView;
}

@end

@implementation ShouSuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[RiskModel singleton].sex isEqualToString:@"1"]) {
        sexImageView.image = [UIImage imageNamed:@"male"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"female"];
    }
    
//    [waistLabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
//    [waistLabel.layer setBorderWidth:0.5f];
    
    waistRuleView.maximumValue = 200;
    waistRuleView.minimumValue = 10;
    waistRuleView.backImage = [UIImage imageNamed:@"shuzhang"];
    waistRuleView.value = 90;
    waistLabel.text = [NSString stringWithFormat:@"%0.0f",waistRuleView.value];
    __weak typeof(self) weakSelf = self;
    waistRuleView.onvalueChange = ^(float value) {
        [weakSelf sliderValueChange:value];
    };
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    [RiskModel singleton].systolic = waistLabel.text;
}

- (void)sliderValueChange:(float)sender {
    waistLabel.text = [NSString stringWithFormat:@"%0.0f",waistRuleView.value];
}


-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
