//
//  UIView+DTTextInput.m
//  Health
//
//  Created by VickyCao on 11/25/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "UIView+DTTextInput.h"
#import "NSString+UI.h"

@implementation UIView (DTTextInput)

- (UITextField *)textTitle:(NSString *)titleString frame:(CGRect)frame superView:(UIView *)superView type:(int)type{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view.layer setCornerRadius:5];
    [view.layer setBorderWidth:0.5f];
    [view.layer setBorderColor:[[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1] CGColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 16)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    titleLabel.text = titleString;
    CGSize size = [titleString getUISize:titleLabel.font limitWidth:200];
    titleLabel.frame = CGRectMake(titleLabel.left, titleLabel.top, size.width, titleLabel.height);
    titleLabel.center = CGPointMake(titleLabel.center.x, view.height/2);
    [view addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right+10, titleLabel.top, view.width - titleLabel.right - 10, 30)];
    textField.center = CGPointMake(textField.center.x, view.height/2);
    [view addSubview:textField];
    [superView addSubview:view];
    return textField;
}

@end
