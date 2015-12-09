//
//  NewsDetailViewController.m
//  Health
//
//  Created by VickyCao on 12/6/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ExpertRequest.h"

@interface NewsDetailViewController () {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIWebView  *contentView;
}

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.newsID) {
        __weak typeof(self) weakSelf = self;
        [[ExpertRequest singleton] getNewsDetail:self.newsID complete:^{
            [weakSelf reloadView];
        } failed:^(NSString *state, NSString *errmsg) {
            
        }];
    }
    // Do any additional setup after loading the view.
}

- (void)reloadView {
    NewsDetail *detail = [ExpertRequest singleton].newsDetail;
    self.title = detail.title;
    titleLabel.text = detail.title;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[detail.inputtime doubleValue]];
    timeLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
    
    [contentView loadHTMLString:detail.content baseURL:nil];
}


@end
