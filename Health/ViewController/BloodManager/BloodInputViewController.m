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

@interface BloodInputViewController () <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UISlider *slider;
    IBOutlet UILabel *mmLabel;
    
    IBOutlet UILabel *periodLabel;
    IBOutlet UILabel *timeLabel;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIDatePicker *datePicker;
    
    IBOutlet UIView *bottomView;
    IBOutlet UITextField *textField;
    NSArray *pickerArray;
}

@end

@implementation BloodInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试结果";
    slider.backgroundColor = [UIColor clearColor];
    UIImage *thumbImage = [UIImage imageNamed:@"bloodThumb"];
    [slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    periodLabel.text = @"空腹";
    timeLabel.text = [[NSDate date] stringWithFormat:@"MM月dd日   HH:mm"];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerArray = @[@"空腹", @"饭前", @"饭后"];
    datePicker.maximumDate = [NSDate date];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [self removeTimerPicker];
        [self removePeriodPicker];
        [textField resignFirstResponder];
    }];
    [bottomView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (void)showPeriodPicker {
    [self removeTimerPicker];
    pickerView.transform = CGAffineTransformMakeTranslation(0, -pickerView.height);
}

- (void)showTimePicker {
    datePicker.transform = CGAffineTransformMakeTranslation(0, -datePicker.height);
}

- (void)removePeriodPicker {
    pickerView.transform = CGAffineTransformIdentity;
}

- (void)removeTimerPicker {
    datePicker.transform = CGAffineTransformIdentity;
}

- (void)commit {
    NSDictionary *dic = @{@"userid": [UserCentreData singleton].userInfo.userid, @"token":[UserCentreData singleton].userInfo.token, @"value":mmLabel.text, @"period":periodLabel.text, @"time":timeLabel.text, @"remark":textField.text, @"type":@"2"};
    
    [[BloodRequest singleton] postInputData:dic complete:^{
        [self.view makeToast:@"提交成功"];
        [self performSegueWithIdentifier:@"showresult" sender:self];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

- (IBAction)sliderChange:(id)sender {
    mmLabel.text = [NSString stringWithFormat:@"%0.1f", ((UISlider *)sender).value];
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

@end
