//
//  AppDelegate.m
//  Health
//
//  Created by vickycao1221 on 10/13/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "AppDelegate.h"
#import "DTInit.h"
#import "UserCentreData.h"
#import "SelectionRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "MineRequest.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.tabbarController = (UITabBarController *)self.window.rootViewController;
    [self setupTabbarItems];
    [WXApi registerApp:@"wx5b8e2d8083fd6016" withDescription:@"health1.0"];
    [self preload];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupTabbarItems {
    NSArray <NSString *> *selectImageArray = @[@"xuetang", @"zhuanjia", @"shangcheng", @"wode"];
    NSArray <NSString *> *originImageArray= @[@"xuetang-weidianji", @"zhuanjia-weidianji", @"shangcheng-weidianji", @"wode-weidianji"];
    
    for (int i = 0; i < self.tabbarController.viewControllers.count; i++) {
        UINavigationController *navVC = self.tabbarController.viewControllers[i];
        navVC.tabBarItem.image = [UIImage imageNamed:originImageArray[i]];
        navVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        [navVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      rgb_color(150, 150, 150, 1), NSForegroundColorAttributeName, nil]
                            forState:UIControlStateNormal];
        [navVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      rgb_color(230, 109, 106, 1), NSForegroundColorAttributeName,
                                      nil] forState:UIControlStateSelected];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"ptangAlipay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)preload {
    [[SelectionRequest singleton] professionTypeComplete:^{
    }];
    
    [[SelectionRequest singleton] getAreaComplete:^{
    }];
    
    [[SelectionRequest singleton] bloodTypeComplete:^{
    }];
    
    [[SelectionRequest singleton] complicationComplete:^{
    }];
}

-(void) onReq:(BaseReq*)req {
    
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *errmsg = @"";
        switch (resp.errCode) {
            case 0:
                // 发送成功
            {
                errmsg = @"发送成功";
                [[MineRequest singleton] addJifenComplete:^{
                    
                } failed:^(NSString *state, NSString *errmsg) {
                    
                }];
                
            }
                break;
            case -2:
                // 发送取消
                errmsg = @"取消发送";
                break;
            default:
                errmsg = @"发送失败";
                break;
        }
        [self.window makeToast:errmsg];
    } else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        BOOL isSuccess;
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                isSuccess = YES;
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付失败: %@",resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatpayResult" object:nil userInfo:@{@"result":@(isSuccess)}];
        [self.window makeToast:strMsg];
    }
}

@end
