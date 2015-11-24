//
//  RegisterViewController.m
//  Health
//
//  Created by antonio on 15/11/24.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () {
}

@end

@implementation RegisterViewController

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

- (UITextField *)textTitle:(NSString *)titleString frame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 23)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [view addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10, CGRectGetMinY(titleLabel.frame), CGRectGetWidth(view.frame) - CGRectGetMinX(textField.frame), 34)];
    [view addSubview:textField];
    
    [self.view addSubview:view];
    return textField;
}

@end
