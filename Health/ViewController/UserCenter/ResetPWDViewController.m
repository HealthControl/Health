//
//  ResetPWDViewController.m
//  Health
//
//  Created by VickyCao on 12/9/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ResetPWDViewController.h"
#import "LoginRequest.h"
#import "UserCentreData.h"

@interface ResetPWDViewController () {
    IBOutlet UITextField *oldTextField;
    IBOutlet UITextField *newTextField;
    IBOutlet UITextField *confirmField;
}

@end

@implementation ResetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
}

- (IBAction)commitButton:(id)sender {
    NSString *toastString = @"";
    if (oldTextField.text.length == 0) {
        toastString = @"老密码不能为空";
    }
    if (newTextField.text.length == 0) {
        toastString = @"新密码不能为空";
    }
    if (confirmField.text.length == 0) {
        toastString = @"确认密码不能为空";
    }
    if ([newTextField.text isEqualToString:confirmField.text]) {
        toastString = @"密码不一致";
    }
    if (toastString.length > 0) {
        [self.view makeToast:toastString];
        return;
    }
    
    NSDictionary *dic = @{@"userid":[UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"password":oldTextField.text, @"newpassword": newTextField.text};
    [[LoginRequest singleton] resetpwd:dic complete:^{
        [self.view makeToast:@"重置成功"];
        oldTextField.text = @"";
        newTextField.text = @"";
        confirmField.text = @"";
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view  makeToast:errmsg];
    }];
}

@end
