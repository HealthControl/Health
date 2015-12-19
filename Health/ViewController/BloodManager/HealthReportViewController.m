//
//  HealthReportViewController.m
//  Health
//
//  Created by antonio on 15/11/19.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "HealthReportViewController.h"

@interface HealthReportViewController ()

@end

@implementation HealthReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    NSInteger buttonTag = ((UIControl *)sender).tag;
    NSString *identifier = @"";
    switch (buttonTag) {
        case 1:
            
            break;
        case 2:
            identifier = @"trendidentifer";
            break;
        case 3:
            identifier = @"zhibiao";
            break;
        default:
            break;
    }
    if (identifier) {
        [self performSegueWithIdentifier:identifier sender:self];
    }
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
