//
//  LocationViewController.m
//  Health
//
//  Created by 朵朵 on 16/4/15.
//  Copyright © 2016年 vickycao1221. All rights reserved.
//

#import "LocationViewController.h"
//#import "RATreeView.h"
@interface LocationViewController () {
    UITableView *locationTableView;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    locationTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:locationTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
