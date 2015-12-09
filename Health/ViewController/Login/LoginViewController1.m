//
//  LoginViewController1.m
//  Health
//
//  Created by VickyCao on 12/8/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "LoginViewController1.h"

@interface LoginViewController1 () {
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registerButton;
}

@end

@implementation LoginViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [loginButton.layer setCornerRadius:5];
    [loginButton.layer setBorderWidth:0.5f];
    [loginButton.layer setBorderColor:[rgb_color(229, 87, 87, 1) CGColor]];
    
    [registerButton.layer setCornerRadius:5];
    [registerButton.layer setBorderWidth:0.5f];
    [registerButton.layer setBorderColor:[rgb_color(229, 87, 87, 1) CGColor]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
