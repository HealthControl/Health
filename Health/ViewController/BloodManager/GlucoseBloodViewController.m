//
//  GlucoseBloodViewController.m
//  Health
//
//  Created by antonio on 15/10/22.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "GlucoseBloodViewController.h"

@interface GlucoseBloodViewController () {
    IBOutlet UILabel *noteLabel;
    IBOutlet UIButton *bloodDeviceButton;
    IBOutlet UIButton *inputButton;
    NSString *Identifer;
}


@end

@implementation GlucoseBloodViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测血糖";
    noteLabel.text = @"请选择您的默认设备：";
    [bloodDeviceButton setTitle:@"血糖仪" forState: UIControlStateNormal];
    [inputButton setTitle:@"手动输入" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//界面将要显示时调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - IBAction
- (IBAction)chooseDevice:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:
            // button1 执行的方法
            NSLog(@"button1 pressed");
            break;
        case 2:
            // button2 执行的方法
            NSLog(@"button2 pressed");
            Identifer = @"bloodInputIdentifer";
            break;
        default:
            break;
    }
    if (Identifer) {
        [self performSegueWithIdentifier:Identifer sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (Identifer) {
//        [self performSegueWithIdentifier:Identifer sender:self];
    }
    
}


@end
