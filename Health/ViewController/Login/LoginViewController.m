//
//  LoginViewController.m
//  Health
//
//  Created by antonio on 15/11/21.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//


#import "LoginViewController.h"
#import "LoginRequest.h"

@interface LoginViewController () {
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)login{
    
    NSString *userName = userNameTextField.text;
    NSString * password = passwordTextField.text;
    
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    [loginDic setObject:userName forKey:@"loginname"];
    [loginDic setObject:password forKey:@"password"];
    
    [[LoginRequest singleton] loginWithDictionary:loginDic complete:^{
        NSLog(@"login success!");
    } failed:^(NSString *state, NSString *errmsg){
        NSLog(@"login fail!");
    }];
    

    
     
     
     
}

@end
