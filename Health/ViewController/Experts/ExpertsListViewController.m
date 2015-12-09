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
#import "DTNetImageView.h"
#import "ExpertsDetailViewController.h"
#import "NewsDetailViewController.h"

@interface ExpertsListCell : UITableViewCell 

@property (nonatomic, weak) IBOutlet DTNetImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *positionLabel;
@property (nonatomic, weak) IBOutlet UILabel *hospitalLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

- (void)cellForExpert:(ExpertData *)expert;

@end

@interface NewsListCell : UITableViewCell {
    IBOutlet DTNetImageView *newsImageView;
    IBOutlet UILabel     *titleLabel;
    IBOutlet UILabel     *introLabel;
}

- (void)cellForNews:(NewsData*)news;

@end

@implementation ExpertsListCell

- (void)cellForExpert:(ExpertData *)expert {
    [self.headerImageView setImageWithUrl:[NSURL URLWithString:expert.headpic] defaultImage:nil];
    self.titleLabel.text = expert.title;
    self.positionLabel.text = expert.position;
    self.hospitalLabel.text = expert.hospital;
    self.descriptionLabel.text = expert.introduce;
}

@end

@implementation NewsListCell

- (void)cellForNews:(NewsData*)news {
    [newsImageView setImageWithUrl:[NSURL URLWithString:news.thumb] defaultImage:nil];
    titleLabel.text = news.title;
    introLabel.text = news.newsDescription;
}

@end

@interface ExpertsListViewController () <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *expertsListTableView;
    NSInteger currentTag;
    
    IBOutlet UIView *lineView1;
    IBOutlet UIView *lineView2;
    IBOutlet UIView *lineView3;
}

@end

@implementation ExpertsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    expertsListTableView.delegate = self;
    expertsListTableView.dataSource = self;
    currentTag = 1;
    [self doRequest];
    [self reloadLineView:currentTag];
}

- (void)reloadLineView:(NSInteger)tag {
    UIColor *unselectColor = rgb_color(153, 153, 153, 1);
    UIColor *selectColor = rgb_color(229, 87, 87, 1);
    switch (tag) {
        case 1:
            lineView1.backgroundColor = selectColor;
            lineView2.backgroundColor = unselectColor;
            lineView3.backgroundColor = unselectColor;
            break;
        case 2:
            lineView1.backgroundColor = unselectColor;
            lineView2.backgroundColor = selectColor;
            lineView3.backgroundColor = unselectColor;
            break;
        case 3:
            lineView1.backgroundColor = unselectColor;
            lineView2.backgroundColor = unselectColor;
            lineView3.backgroundColor = selectColor;
            break;
        default:
            break;
    }
}

- (void)doRequest {
    switch (currentTag) {
        case 1:
        {
            [[ExpertRequest singleton] getExpertsList:^{
                [expertsListTableView reloadData];
            } failed:^(NSString *state, NSString *errmsg) {
            }];
        }
            break;
        case 2:
        {
            [[ExpertRequest singleton] getExpertsQuestionList:^{
                [expertsListTableView reloadData];
            } failed:^(NSString *state, NSString *errmsg) {
            }];
        }
            break;
        case 3:
        {
            [[ExpertRequest singleton] getUserNewsList:^{
                [expertsListTableView reloadData];
            } failed:^(NSString *state, NSString *errmsg) {
                
            }];
        }
            break;
        default:
            break;
    }
}

- (IBAction)buttonClicked:(id)sender {
    
    
    UIControl *control = (UIControl *)sender;
    currentTag = control.tag;
    NSLog(@"buttonClicked %d" , (int)currentTag);
    [self doRequest];
    [self reloadLineView:currentTag];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array;
    switch (currentTag) {
        case 1:
            // 高级营养师
            array = [ExpertRequest singleton].expertsArray;
            break;
        case 2:
            array = [ExpertRequest singleton].questionArray;
            // 专家咨询
            break;
        case 3:
            // 糖友资讯
            array = [ExpertRequest singleton].newsArray;
            break;
        default:
            break;
    }
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (currentTag) {
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"expertscell"];
            NSMutableArray *array = [ExpertRequest singleton].expertsArray;
            [(ExpertsListCell *)cell cellForExpert:array[indexPath.row]];
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"expertscell"];
            NSMutableArray *array = [ExpertRequest singleton].expertsArray;
            [(ExpertsListCell *)cell cellForExpert:array[indexPath.row]];
        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
            NSMutableArray *array = [ExpertRequest singleton].newsArray;
            [(NewsListCell *)cell cellForNews:array[indexPath.row]];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentTag == 1 || currentTag == 2) {
        NSMutableArray *array = [ExpertRequest singleton].expertsArray;
        ExpertData *experts = array[indexPath.row];
        [self performSegueWithIdentifier:@"expertsDetail" sender:experts];
    } else {
        NSMutableArray *array = [ExpertRequest singleton].newsArray;
        NewsData *newsData = [array objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"newsDetail" sender:newsData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[ExpertData class]]) {
        ExpertsDetailViewController *detailVC = [segue destinationViewController];
        detailVC.doctorID = ((ExpertData *)sender).id;
    } else {
        NewsDetailViewController *newsVC = [segue destinationViewController];
        newsVC.newsID = ((NewsData *)sender).id;
    }
    
}

@end
