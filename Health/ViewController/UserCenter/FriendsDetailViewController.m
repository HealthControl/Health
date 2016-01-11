//
//  FriendsDetailViewController.m
//  Health
//
//  Created by VickyCao on 1/10/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "FriendsDetailViewController.h"
#import "MineRequest.h"

@interface FriendsDetailViewController() {
    IBOutlet UILabel *friendsName;
    IBOutlet UILabel *friendsPhone;
    IBOutlet UIWebView *webView;
}

@end

@implementation FriendsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    friendsName.text = self.friendsDic[@"relation"];
    friendsPhone.text = self.friendsDic[@"mobile"];
    
    [[MineRequest singleton] getFriendsBlood:self.friendsDic[@"mobile"] complete:^{
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[MineRequest singleton].friendsBloodUrl]]];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

@end
