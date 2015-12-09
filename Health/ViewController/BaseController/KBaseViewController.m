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

@interface KBaseViewController ()

@end

@implementation KBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@ viewdidload", self);
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
