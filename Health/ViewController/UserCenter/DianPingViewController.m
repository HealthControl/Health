//
//  DianPingViewController.m
//  Health
//
//  Created by VickyCao on 12/11/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "DianPingViewController.h"
#import "MineRequest.h"

@interface DianPingViewController () <UITextViewDelegate> {
    IBOutlet UITextView *subjectTextView;
    IBOutlet UILabel *tipsLabel;
}

@end

@implementation DianPingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [subjectTextView.layer setCornerRadius:4];
    [subjectTextView.layer setBorderWidth:0.5f];
    [subjectTextView.layer setBorderColor:[rgb_color(204, 204, 204, 1) CGColor]];
    subjectTextView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapView {
    [subjectTextView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    tipsLabel.hidden = textView.text.length > 0?YES:NO;
}

- (IBAction)submit:(id)sender {
    if (subjectTextView.text.length == 0) {
        [self.view makeToast:@"点评不能为空"];
        return;
    }
    [[MineRequest singleton] postDianping:subjectTextView.text complete:^{
        [self.view makeToast:@"点评成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

@end
