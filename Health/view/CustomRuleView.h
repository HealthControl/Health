//
//  CustomRuleView.h
//  aa
//
//  Created by VickyCao on 12/24/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, RuleDirection) {
    RuleDirection_V,              // 列表样式
    RuleDirection_H              // 按钮样式
};

@interface CustomRuleView : UIView

@property(nonatomic) float value;
@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nullable, nonatomic,strong) UIImage *backImage;
@property(nonatomic, assign) RuleDirection ruleDirction;

@property (nullable, nonatomic, copy) void (^onvalueChange)(float returnValue);


@end
