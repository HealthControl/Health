//
//  FindPasswordViewController.m
//  Health
//
//  Created by VickyCao on 12/24/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "LoginRequest.h"

@interface FindPasswordViewController () {
    IBOutlet UITextField *phoneTextField;
    IBOutlet UITextField *codeTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *confirmTextField;
}

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.title = @"找回密码";
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [weakSelf hideKeybord];
    }];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)hideKeybord {
    [phoneTextField resignFirstResponder];
    [codeTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmTextField resignFirstResponder];
}

- (IBAction)submit:(id)sender {
    NSString *tips = @"";
    if (confirmTextField.text.length == 0) {
        tips = @"确认密码不能为空";
    }
    if (passwordTextField.text.length == 0) {
        tips = @"密码不能为空";
    }
    
    if (codeTextField.text.length == 0) {
        tips = @"验证码不能为空";
    }
    
    if (phoneTextField.text.length == 0) {
        tips = @"手机号不能为空";
    }
    if (tips.length > 0) {
        [self.view makeToast:tips];
        return;
    }
    
    if (![confirmTextField.text isEqualToString:passwordTextField.text]) {
        tips = @"密码不同";
        [self.view makeToast:tips];
        return;
    }
//    mobile
//    code
//    password
    [[LoginRequest singleton] findPwd:@{@"mobile":phoneTextField.text, @"code":codeTextField.text, @"password":passwordTextField.text} complete:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

- (IBAction)sendCode:(id)sender{
    if (phoneTextField.text.length == 0) {
        [self.view makeToast:@"手机号不能为空"];
    }
    [[LoginRequest singleton] sendSms:@{@"mobile":phoneTextField.text} complete:^{
        [self.view makeToast:@"发送成功"];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

@end
