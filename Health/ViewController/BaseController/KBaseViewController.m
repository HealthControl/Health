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
#import <StoreKit/StoreKit.h>

@interface KBaseViewController ()<MYIntroductionDelegate, SKStoreProductViewControllerDelegate>

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

- (void)evaluate{

    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"1078140724"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(1) forKey:@"launchtime"];
    }];
}

- (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

// 根据使用时间判断是否登录
- (void)getUseTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval lastTime = [[defaults objectForKey:@"launchtime"] doubleValue];
    if (lastTime && lastTime == 1) {
        // 已评价或者拒绝
        return;
    } else {
        NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:lastTime];
        NSDate *nowDate = [NSDate date];
        NSInteger interval = ABS([self getDaysFrom:oldDate To:nowDate]);
        if (interval > 1) {
            [self showCommentAlert];
        }
    }
    
}

- (void)showCommentAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"评价平糖" message:@"感谢您陪伴平糖成长的每一天，给我们留言评分吧，我们会努力做得更好！" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"去评价" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self evaluate];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"稍后提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"launchtime"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"残忍拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(1) forKey:@"launchtime"];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
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
        
        
        if (!((AppDelegate*)[UIApplication sharedExtensionApplication].delegate).hasShow) {
            [self showCommentAlert];
            ((AppDelegate*)[UIApplication sharedExtensionApplication].delegate).hasShow = YES;
        }
        return;
        [self getUseTime];
        
    } else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *loginNav = [sb instantiateViewControllerWithIdentifier:@"loginNavi"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}

- (void)showGuideView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:[UIApplication sharedExtensionApplication].appVersion];
    
    [defaults setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"launchtime"];
    
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
