//
//  CustomRuleView.m
//  aa
//
//  Created by VickyCao on 12/24/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "CustomRuleView.h"

@interface CustomRuleView () <UIScrollViewDelegate>{
    UIScrollView *ruleScrollView;
    UIImageView *indicatorImageView;
}

@end

@implementation CustomRuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.clipsToBounds = YES;
    ruleScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    ruleScrollView.backgroundColor = [UIColor whiteColor];
    ruleScrollView.delegate = self;
    [self addSubview:ruleScrollView];
    
    UIImage *indicatorImage = [UIImage imageNamed:@"bloodThumb"];
    indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, indicatorImage.size.width, indicatorImage.size.height)];
    indicatorImageView.image = indicatorImage;
    [self addSubview:indicatorImageView];
    self.ruleDirction = RuleDirection_V;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.ruleDirction == RuleDirection_H) {
        UIImage *image = [UIImage imageNamed:@"blood_thumb_h"];
        indicatorImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        indicatorImageView.image = image;
    }
    ruleScrollView.frame = self.bounds;
    indicatorImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    [self reloadView];
}

- (void)reloadView {
    float x = self.ruleDirction == RuleDirection_H?ruleScrollView.bounds.size.height/2.0:ruleScrollView.bounds.size.width/2.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backImage.size.width, self.backImage.size.height)];
    imageView.image = self.backImage;
    [ruleScrollView addSubview:imageView];
    ruleScrollView.contentSize =  self.ruleDirction == RuleDirection_H? CGSizeMake(ruleScrollView.bounds.size.width , imageView.bounds.size.height): CGSizeMake(imageView.bounds.size.width , ruleScrollView.bounds.size.height);
    ruleScrollView.contentInset = self.ruleDirction == RuleDirection_H? UIEdgeInsetsMake(x, 0, x, 0): UIEdgeInsetsMake(0, x, 0, x);
    ruleScrollView.contentOffset = self.ruleDirction == RuleDirection_H? CGPointMake(ruleScrollView.contentOffset.x, ((self.value-self.minimumValue) * ruleScrollView.contentSize.height)/(self.maximumValue - self.minimumValue) - x): CGPointMake((self.value * ruleScrollView.contentSize.width)/(self.maximumValue - self.minimumValue) - x, ruleScrollView.contentOffset.y) ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.value = self.ruleDirction == RuleDirection_H? (scrollView.contentOffset.y + scrollView.bounds.size.height/2.0)*((self.maximumValue - self.minimumValue)/scrollView.contentSize.height) + self.minimumValue:(scrollView.contentOffset.x + scrollView.bounds.size.width/2.0)*((self.maximumValue - self.minimumValue)/scrollView.contentSize.width)+self.minimumValue;
    if (self.value < 0) {
        self.value = 0;
    }
    if (self.value > self.maximumValue) {
        self.value = self.maximumValue;
    }
    if (self.onvalueChange) {
        self.onvalueChange(self.value);
    }
}

@end
