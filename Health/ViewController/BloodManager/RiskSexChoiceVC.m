//
//  RiskSexChoiceVC.m
//  Health
//
//  Created by VickyCao on 12/20/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "RiskSexChoiceVC.h"
#import "RiskModel.h"
#import "UIViewController+BackButtonHandler.h"

@implementation RiskSexChoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
}

- (IBAction)maleChoice:(id)sender {
    [RiskModel singleton].sex = @"1";
}

- (IBAction)femaleChoice:(id)sender {
    [RiskModel singleton].sex = @"2";
}

@end
