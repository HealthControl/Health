//
//  RegisterViewController.m
//  Health
//
//  Created by antonio on 15/11/24.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIView+DTTextInput.h"

@interface RegisterViewController () {
    IBOutlet UIScrollView *textScrollView;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTextField];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTextField {
    
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
