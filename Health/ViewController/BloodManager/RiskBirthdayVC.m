//
//  RiskBirthdayVC.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskBirthdayVC.h"
#import "RiskModel.h"

@implementation RiskBirthdayVC {
    IBOutlet UIImageView *sexImageView;
    IBOutlet UIDatePicker *datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[RiskModel singleton].sex isEqualToString:@"1"]) {
        sexImageView.image = [UIImage imageNamed:@"male"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"female"];
    }
    datePicker.maximumDate = [NSDate date];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)next:(id)sender {
    [RiskModel singleton].birthday = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
}


- (IBAction)sliderValueChange:(id)sender {
//    waistLabel.text = [NSString stringWithFormat:@"%0.f",waistSlider.value];
    [RiskModel singleton].birthday = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}
@end
