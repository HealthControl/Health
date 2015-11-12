//
//  AppDelegate.m
//  Health
//
//  Created by vickycao1221 on 10/13/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "AppDelegate.h"
#import "DTInit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.tabbarController = (UITabBarController *)self.window.rootViewController;
    [self setupTabbarItems];
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
    NSArray *selectImageArray = @[@"xuetang", @"zhuanjia", @"shangcheng", @"wode"];
    NSArray *originImageArray= @[@"xuetang-weidianji", @"zhuanjia-weidianji", @"shangcheng-weidianji", @"wode-weidianji"];
    for (int i = 0; i < self.tabbarController.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabbarController.tabBar.items[i];
        [item setFinishedSelectedImage:[UIImage imageNamed:selectImageArray[i]] withFinishedUnselectedImage:[UIImage imageNamed:originImageArray[i]]];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      rgb_color(150, 150, 150, 1), NSForegroundColorAttributeName, nil]
                            forState:UIControlStateNormal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      rgb_color(230, 109, 106, 1), NSForegroundColorAttributeName,
                                      nil] forState:UIControlStateSelected];
    }
    
}

@end
