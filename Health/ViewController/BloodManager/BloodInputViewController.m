//
//  BloodInputViewController.m
//  Health
//
//  Created by antonio on 15/10/24.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "BloodInputViewController.h"
#import "BloodInputResultViewController.h"
#import "BloodRequest.h"
#import "CustomRuleView.h"
#import "GlucoseBloodViewController.h"

@interface BloodInputViewController () <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet CustomRuleView *bloodRuleView;
    
    IBOutlet UILabel *mmLabel;
    
    IBOutlet UILabel *periodLabel;
    IBOutlet UILabel *timeLabel;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIDatePicker *datePicker;
    
    IBOutlet UIView *bottomView;
    IBOutlet UITextField *textField;
    NSMutableArray *pickerArray;
}

@end

@implementation BloodInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试结果";
    
    periodLabel.text = @"空腹";
    timeLabel.text = [[NSDate date] stringWithFormat:@"MM月dd日   HH:mm"];
    pickerArray = [NSMutableArray array];
    datePicker.maximumDate = [NSDate date];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [self removeTimerPicker];
        [self removePeriodPicker];
        [textField resignFirstResponder];
    }];
    [bottomView addGestureRecognizer:tapGesture];
    
    bloodRuleView.maximumValue = 40;
    bloodRuleView.minimumValue = 0;
    bloodRuleView.backImage = [UIImage imageNamed:@"cexuetang"];
    bloodRuleView.value = 10;
    if (self.resultStr) {
        bloodRuleView.value = [self.resultStr floatValue];
    }
    
    mmLabel.text = [NSString stringWithFormat:@"%0.2f",bloodRuleView.value];
    __weak typeof(self) weakSelf = self;
    bloodRuleView.onvalueChange = ^(float value) {
        [weakSelf sliderChange:value];
    };
    [[BloodRequest singleton] getperiod:^{
        for (NSDictionary *dic in [BloodRequest singleton].periodArray) {
            [pickerArray addObject:dic[@"value"]];
        }
        
        if (pickerArray.count > 0) {
            periodLabel.text = pickerArray[0];
        }
        pickerView.delegate = self;
        pickerView.dataSource = self;
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    pickerView.frame = CGRectMake(0, self.view.height, pickerView.width, pickerView.height);
//    datePicker.frame = CGRectMake(0, self.view.height, datePicker.width, datePicker.height);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (void)showPeriodPicker {
    [self removeTimerPicker];
    pickerView.superview.transform = CGAffineTransformMakeTranslation(0, -pickerView.height);
}

- (void)showTimePicker {
    [self removePeriodPicker];
    datePicker.superview.transform = CGAffineTransformMakeTranslation(0, -datePicker.height);
}

- (void)removePeriodPicker {
    pickerView.superview.transform = CGAffineTransformIdentity;
}

- (void)removeTimerPicker {
    datePicker.superview.transform = CGAffineTransformIdentity;
}

- (void)commit {
    NSDictionary *dic = @{@"userid": [UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"value":mmLabel.text, @"period":periodLabel.text, @"time":timeLabel.text, @"remark":textField.text, @"type":self.isFromDevice?@"1":@"2"};
    
    [[BloodRequest singleton] postInputData:dic complete:^{
        [self.view makeToast:@"提交成功"];
        [self performSegueWithIdentifier:@"showresult" sender:self];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

- (void)sliderChange:(float)sender {
    mmLabel.text = [NSString stringWithFormat:@"%0.1f", sender];
}

- (IBAction)buttonClick:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 1:
            [self showPeriodPicker];
            break;
        case 2:
            [self showTimePicker];
            break;
        case 3:
            [self commit];
            break;
        default:
            break;
    }
}

- (IBAction)datePickerChange:(id)sender {
     timeLabel.text = [datePicker.date stringWithFormat:@"MM月dd日   HH:mm"];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return pickerArray[row];
}

- (void)pickerView:(UIPickerView *)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self removePeriodPicker];
    periodLabel.text = pickerArray[row];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    BloodInputResultViewController *resultVC = [segue destinationViewController];
    resultVC.resultDic = [BloodRequest singleton].testResultDic;
}

-(BOOL)navigationShouldPopOnBackButton{
    UIViewController *vc = nil;
    for (UIViewController *v in self.navigationController.viewControllers) {
        if ([v isKindOfClass:[GlucoseBloodViewController class]]) {
            vc = v;
        }
    }
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}
@end
