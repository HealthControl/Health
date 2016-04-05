//
//  BloodControlViewController.m
//  Health
//
//  Created by antonio on 15/10/21.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "BloodControlViewController.h"
#import "LoginRequest.h"
#import "BloodRequest.h"
#import "FriendsViewController.h"

@interface BloodControlViewController () {
    IBOutlet UILabel *bloodLabel;
    IBOutlet UIImageView *bannerImageView;
}
@end

@implementation BloodControlViewController

//xib加载完毕时调用
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"血糖管理";
    @weakify(self)
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        @strongify(self);
        [self showFriendsViewController];
    }];
    [bannerImageView addGestureRecognizer:imageTap];
    
}

//界面将要显示时调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:[UIApplication sharedExtensionApplication].appVersion]) {
        [self showLoginVC];
    } else {
        [self showGuideView];
    }
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
    if (userInfoDic && userInfoDic.allKeys.count > 0) {
        [[BloodRequest singleton] getTodayBloodComplete:^{
            bloodLabel.text = [BloodRequest singleton].todayBlood;
        } failed:^(NSString *state, NSString *errmsg) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    UIControl *controlView = (UIControl*)sender;
    NSString *identifer = nil;
    switch (controlView.tag) {
        case 1:
            identifer = @"glucoseBloodIdentifier";
            break;
        case 2:
            identifer = @"calendar";
            break;
        case 3:
            identifer = @"healthReportIdentifer";
            break;
        case 4:
            identifer = @"riskIdentifiter";
            break;
        default:
            break;
    }
    
    if (identifer) {
        [self performSegueWithIdentifier:identifer sender:self];
    }

}

- (IBAction)showFriendsViewController {
    [self performSegueWithIdentifier:@"showFriends" sender:self];
}

@end
