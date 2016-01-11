//
//  RiskSexConfirmVC.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskSexConfirmVC.h"
#import "RiskModel.h"

@implementation RiskSexConfirmVC {
    IBOutlet UIButton *sexButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sexButton.enabled = NO;
    if ([[RiskModel singleton].sex isEqualToString:@"1"]) {
        [sexButton setImage:[UIImage imageNamed:@"male"] forState:UIControlStateDisabled];
    } else {
        [sexButton setImage:[UIImage imageNamed:@"female"] forState:UIControlStateDisabled];
    }
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
