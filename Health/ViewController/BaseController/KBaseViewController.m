//
//  KBaseViewController.m
//  Health
//
//  Created by antonio on 15/10/21.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "KBaseViewController.h"
#import "LoginData.h"
#import "UserCentreData.h"
#import "GuideViewController.h"
#import "MYIntroductionView.h"
#import "AppDelegate.h"

@interface KBaseViewController ()<MYIntroductionDelegate>

@end

@implementation KBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@ viewdidload", self);
//    self.view.backgroundColor = rgb_color(238, 238, 238, 1);
    if (![[self.navigationController.viewControllers firstObject] isKindOfClass:[self class]]) {
        [self addBackButton];
    }
}

- (void)addBackButton {
    UIImage *backButtonImage = [[UIImage imageNamed:@"backButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
   // 将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(10, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0.0f, 0.0f, 40, 40);
//    UIImage *backImage = [UIImage imageNamed:@"backButton"];
//    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
//    [leftButton setImage:backImage forState:UIControlStateNormal];
//    
//    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationController.navigationItem.backBarButtonItem = leftButtonItem;
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//弹出登陆页
-(void)showLoginVC
{
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
    if (userInfoDic && userInfoDic.allKeys.count > 0) {
        LoginData *loginData = [[LoginData alloc] initWithDictionary:userInfoDic];
        UserCentreData *userCentre = [UserCentreData singleton];
        userCentre.userInfo = loginData;
        userCentre.hasLogin = YES;
    } else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *loginNav = [sb instantiateViewControllerWithIdentifier:@"loginNavi"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}

- (void)showGuideView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:[UIApplication sharedExtensionApplication].appVersion];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GuideViewController *guide = [sb instantiateViewControllerWithIdentifier:@"guide"];
    [self presentViewController:guide animated:YES completion:nil];
    
    __weak typeof(self) weakSelf= self;
    guide.onEvent = ^() {
        [weakSelf showLoginVC];
    };
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
