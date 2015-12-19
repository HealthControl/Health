//
//  JifenViewController.m
//  Health
//
//  Created by VickyCao on 12/9/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "JifenViewController.h"
#import "MineRequest.h"
#import "UserCentreData.h"

@interface JifenViewController() {
    IBOutlet UILabel *jifenLabel;
}

@end

@implementation JifenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[MineRequest singleton] getJifen:[UserCentreData singleton].userInfo.userid complete:^{
//        jifenLabel.text = @"";
//    } failed:^(NSString *state, NSString *errmsg) {
//        
//    }];
}

@end
