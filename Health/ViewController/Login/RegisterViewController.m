//
//  RegisterViewController.m
//  Health
//
//  Created by antonio on 15/11/24.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIView+DTTextInput.h"
#import "LoginRequest.h"

@interface RegisterViewController () <UITextFieldDelegate>{
    IBOutlet UIScrollView *textScrollView;
    UIButton *sendCodeButton;
    NSMutableArray *textFieldArray;
    NSTimer *buttonTimer;
    float totalHeight;
    int time;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    textFieldArray = [NSMutableArray array];
    [self addIconImageView];
    [self addTextField];
    [self addContractButton];
    [self addRegisterButton];
    [self addLoginButton];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keybordresignFirstResponder)];
    [textScrollView addGestureRecognizer:tapGesture];
    time = 60;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self keybordresignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keybordresignFirstResponder {
    for (UITextField *f in textFieldArray) {
        [f resignFirstResponder];
    }
    textScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)addIconImageView {
    UIImage *image = [UIImage imageNamed:@"logoIcon"];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 18, image.size.width, image.size.height)];
    iconImageView.image = image;
    iconImageView.center = CGPointMake(self.view.width/2, iconImageView.center.y);
    [textScrollView addSubview:iconImageView];
}

- (void)addTextField {
    NSArray *titleArray = @[@"昵称", @"手机号码", @"验证码", @"邀请码", @"密码", @"确认密码"];
    totalHeight = 150;
    for (int i = 0; i < titleArray.count; i++) {
        UIView *view = [[UIView alloc] init];
        UITextField *field = [view textTitle:titleArray[i] frame:CGRectMake(25, totalHeight+i*10, self.view.width - 50, 40) superView:textScrollView type:0];
        if (i == 2) {
            field = [view textTitle:titleArray[i] frame:CGRectMake(25, totalHeight+i*10, self.view.width - 50, 40) superView:textScrollView type:1];
            field.frame = CGRectMake(field.left, field.top, field.width/2, field.height);
            sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            sendCodeButton.frame = CGRectMake(field.right, field.top, field.width, field.height);
            [sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            [sendCodeButton setTitleColor:rgb_color(229, 87, 87, 1) forState:UIControlStateNormal];
            [sendCodeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
            sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [field.superview addSubview:sendCodeButton];
        }
        if (i == 1 || i == 2 || i == 3) {
            field.keyboardType = UIKeyboardTypeNumberPad;
            if (i == 3) {
                field.placeholder = @"没有可忽略";
            }
        }
        if (i == 4 || i == 5) {
            field.secureTextEntry = YES;
        }
        field.delegate = self;
        [textFieldArray addObject:field];
        totalHeight += 40;
    }
}

- (void)sendCode {
    UITextField *phoneText = [textFieldArray objectAtIndex:1];
    if (phoneText.text.length == 0) {
        [self.view makeToast:@"手机号不能为空"];
        return;
    }
    [phoneText resignFirstResponder];
    NSDictionary *mobileDic = @{@"mobile":phoneText.text};
    [[LoginRequest singleton] sendSms:mobileDic complete:^{
        [self.view makeToast:@"验证码发送成功"];
        [self startTimer];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:@"验证码发送失败"];
    }];
}

- (void)addContractButton {
    UIButton *contractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contractButton.frame = CGRectMake(25, totalHeight+55, 273, 40);
    [contractButton setTitle:@"我已阅读并接受《平糖协议》" forState:UIControlStateNormal];
    [contractButton setTitleColor:rgb_color(153, 153, 153, 1) forState:UIControlStateNormal];
    contractButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [contractButton addTarget:self action:@selector(xieyiClick) forControlEvents:UIControlEventTouchUpInside];
    [textScrollView addSubview:contractButton];
    totalHeight = contractButton.bottom;
}

- (void)addRegisterButton {
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(0, totalHeight+28, self.view.width-50, 40);
    [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    registerButton.titleLabel.textColor = [UIColor whiteColor];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    registerButton.backgroundColor = rgb_color(229, 87, 87, 1);
    [registerButton addTarget:self action:@selector(registerButton) forControlEvents:UIControlEventTouchUpInside];
    registerButton.center = CGPointMake(self.view.width/2, registerButton.center.y);
    [textScrollView addSubview:registerButton];
    totalHeight = registerButton.bottom;
}

- (void)addLoginButton {
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, totalHeight+10, 135, 40);
    [loginButton setTitle:@"已有账号，直接登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:rgb_color(153, 153, 153, 1) forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginButton addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    loginButton.center = CGPointMake(self.view.width/2, loginButton.center.y);
    [textScrollView addSubview:loginButton];
    totalHeight = loginButton.bottom;
    textScrollView.contentSize = CGSizeMake(self.view.width, totalHeight+20);
}

- (void)loginButton {
    [self performSegueWithIdentifier:@"registerToLogin" sender:self];
}

- (void)registerButton {
    [self keybordresignFirstResponder];
    NSArray *tipsArray = @[@"昵称不能为空", @"手机号不能为空", @"验证码不能为空", @"", @"密码不能为空", @"确认密码不能为空"];
    for (int i = 0; i < textFieldArray.count; i++) {
        UITextField *textField = textFieldArray[i];
        if (textField.text.length == 0) {
            NSString *tipsStr = tipsArray[i];
            if (tipsStr.length > 0) {
                [self.view makeToast:tipsStr];
                return;
            }
        }
    }
    
//    username 昵称
//    mobile 手机号
//    code 手机验证码
//    invitecode 邀请码 选填
//    password 密码
    
    NSDictionary *dic = @{@"username":((UITextField *)textFieldArray[0]).text, @"mobile":((UITextField *)textFieldArray[1]).text, @"code":((UITextField *)textFieldArray[2]).text, @"invitecode":((UITextField *)textFieldArray[3]).text, @"password":((UITextField *)textFieldArray[4]).text};
    
    [[LoginRequest singleton] registerWithDictionary:dic complete:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

- (void)startTimer {
    sendCodeButton.enabled = NO;
    
    if (!buttonTimer) {
        buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateButtonTitle) userInfo:nil repeats:YES];
    }
}

- (void)updateButtonTitle {
    time--;
    if (time >= 0) {
        [sendCodeButton setTitle:[NSString stringWithFormat:@"%d秒后再次发送", time] forState:UIControlStateDisabled];
    } else {
        [self closeTimer];
    }
}

- (void)closeTimer {
    time = 60;
    sendCodeButton.enabled = YES;
    [sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [buttonTimer invalidate];
    buttonTimer = nil;
}

- (void)xieyiClick {
    [self performSegueWithIdentifier:@"zhucexieyi" sender:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    float offset = textField.superview.bottom - (self.view.height - 320) < 0? 0:textField.superview.bottom - (self.view.height - 320);
    textScrollView.contentOffset = CGPointMake(0, offset);
}

@end
