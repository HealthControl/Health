//
//  GuideViewController.m
//  Health
//
//  Created by VickyCao on 12/22/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "GuideViewController.h"

@implementation GuideViewController {
    IBOutlet UIScrollView *scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
     [self initGuide];
}

- (void)initGuide {
     [scrollView setContentSize:CGSizeMake(self.view.width * 4, scrollView.height)];
     [scrollView setPagingEnabled:YES];  //视图整页显示
     //    [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来

    NSArray<NSString *> *imageArray = @[@"guide-01.jpg",@"guide-02.jpg", @"guide-03.jpg", @"guide-04.jpg"];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*scrollView.width, 0, scrollView.width, scrollView.height)];
        [imageView setImage:[UIImage imageNamed:imageArray[i]]];
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
        
        if (i == 3) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setFrame:imageView.bounds];
            [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
    }
}

- (void)firstpressed {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onEvent) {
            self.onEvent();
        }
    }];
}

@end
