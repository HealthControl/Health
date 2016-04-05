//
//  JIazuBingViewController.m
//  Health
//
//  Created by 朵朵 on 16/4/6.
//  Copyright © 2016年 vickycao1221. All rights reserved.
//

#import "JIazuBingViewController.h"
#import "RiskModel.h"
#import "BloodRequest.h"

@interface JIazuBingViewController () {
    IBOutlet UIButton *yesButton;
    IBOutlet UIButton *noButton;
    IBOutlet UIImageView *sexImageView;
}

@end

@implementation JIazuBingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [yesButton.layer setCornerRadius:yesButton.width/2];
    [noButton.layer setCornerRadius:noButton.width/2];
    yesButton.clipsToBounds = YES;
    noButton.clipsToBounds = YES;
    
    noButton.selected = YES;
    
    if ([[RiskModel singleton].sex isEqualToString:@"1"]) {
        sexImageView.image = [UIImage imageNamed:@"male"];
    } else {
        sexImageView.image = [UIImage imageNamed:@"female"];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)YesButtonSelect:(id)sender {
    yesButton.selected = YES;
    noButton.selected = NO;
}

- (IBAction)NoButtonSelect:(id)sender {
    yesButton.selected = NO;
    noButton.selected = YES;
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submit:(id)sender {
//    NSMutableString *str = [NSMutableString stringWithString:@""];
//    if ([RiskModel singleton].contentDic.allKeys.count > 0) {
//        for (NSString *keys in [RiskModel singleton].contentDic.allKeys) {
//            [str appendFormat:@"%@,%@;", keys, [[RiskModel singleton].contentDic objectForKey:keys]];
//        }
//        [str replaceCharactersInRange:NSMakeRange(str.length-1, 1) withString:@""];
//        [RiskModel singleton].content = str;
//    }
    [RiskModel singleton].family_history = yesButton.isSelected;
    NSDictionary *postDic = (NSDictionary *)[[RiskModel singleton] modelToJSONObject];
    [[BloodRequest singleton] postRiskData:postDic complete:^{
        [self performSegueWithIdentifier:@"getResult" sender:self];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
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
