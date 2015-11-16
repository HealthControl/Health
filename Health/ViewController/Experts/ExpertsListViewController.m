//
//  ExpertsListViewController.m
//  Health
//
//  Created by VickyCao on 11/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ExpertsListViewController.h"
#import "ExpertRequest.h"
#import "ExpertData.h"

@interface ExpertsListCell : UITableViewCell 

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *positionLabel;
@property (nonatomic, weak) IBOutlet UILabel *hospitalLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

- (void)cellForExpert:(ExpertData *)expert;

@end

@implementation ExpertsListCell

- (void)cellForExpert:(ExpertData *)expert {
    self.titleLabel.text = expert.title;
    self.positionLabel.text = expert.position;
    self.hospitalLabel.text = expert.hospital;
    self.descriptionLabel.text = expert.introduce;
}

@end

@interface ExpertsListViewController () <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *expertsListTableView;
    NSInteger currentTag;
}

@end

@implementation ExpertsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentTag = 1;
    expertsListTableView.delegate = self;
    expertsListTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ExpertRequest singleton] getExpertsList:^{
        NSLog(@"bb");
    } failed:^(NSString *state, NSString *errmsg) {
        NSLog(@"aa");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (currentTag) {
        case 1:
            // 高级营养师
            return [ExpertRequest singleton].expertsArray.count;
            break;
        case 2:
            return [ExpertRequest singleton].questionArray.count;
            // 专家咨询
            break;
        case 3:
            // 糖友资讯
            return [ExpertRequest singleton].newsArray.count;
            break;
        default:
            break;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (<#condition#>) {
        <#statements#>
    }
}

@end
