
//
//  XieyiViewController.m
//  Health
//
//  Created by VickyCao on 1/10/16.
//  Copyright © 2016 vickycao1221. All rights reserved.
//

#import "XieyiViewController.h"
#import "MineRequest.h"

@interface XieyiViewController () {
    IBOutlet UIWebView *webView;
    YYImage *yyImage;
}

@end

@implementation XieyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"注册协议";

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xuetang.libokai.cn/Api/other/agreement"]]];
}

@end
