//
//  FriendsViewController.m
//  Health
//
//  Created by VickyCao on 12/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "FriendsViewController.h"
#import "MineRequest.h"

@interface AddFriendsCell : UITableViewCell {
    IBOutlet UITextField *relationField;
    IBOutlet UITextField *phoneField;
}

@end

@implementation AddFriendsCell

- (IBAction)sumbitAdd:(id)sender {
    if (relationField.text.length == 0) {
        [self.viewController.view makeToast:@"关系不能为空"];
        return;
    }
    if (phoneField.text.length == 0) {
        [self.viewController.view makeToast:@"手机号不能为空"];
        return;
    }
    
    [[MineRequest singleton] addFriendsReletion:relationField.text mobil:phoneField.text complete:^{
        [(FriendsViewController *)self.viewController loadData];
        [self.viewController.view makeToast:@"添加成功"];
        relationField.text = @"";
        phoneField.text = @"";
        [relationField resignFirstResponder];
        [phoneField resignFirstResponder];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.viewController.view makeToast:errmsg];
    }];
}

@end

@interface DeleteFriendsCell : UITableViewCell {
    IBOutlet UILabel *relationLabel;
    IBOutlet UILabel *phoneLabel;
    NSDictionary *saveDic;
}

@end

@implementation DeleteFriendsCell

- (void)cellForDic:(NSDictionary *)dic {
    saveDic = dic;
    relationLabel.text = dic[@"relation"];
    phoneLabel.text = dic[@"mobile"];
}

- (IBAction)deleteFriends:(id)sender {
    [[MineRequest singleton] deleteFriends:saveDic[@"id"] complete:^{
        [(FriendsViewController *)self.viewController loadData];
        [self.viewController.view makeToast:@"删除成功"];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.viewController.view makeToast:errmsg];
    }];
}

@end

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *friendsTableView;
    NSMutableArray *dataArray;
}

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    friendsTableView.delegate = self;
    friendsTableView.dataSource = self;
    dataArray = [NSMutableArray array];
    [self loadData];
}

- (void)loadData {
    [[MineRequest singleton] getFriendsListComplete:^{
        [self reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadData {
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:[MineRequest singleton].friendsArray];
    [friendsTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"deleteFriends";
    if (indexPath.row == dataArray.count) {
        identifier = @"addFriends";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UIView *view = [cell.contentView viewWithTag:1];
    UIButton *button = [cell.contentView viewWithTag:2];
    [view.layer setCornerRadius:5];
    [view.layer setBorderColor:[rgb_color(221, 221, 221, 1) CGColor]];
    [view.layer setBorderWidth:0.5f];
    [button.layer setBorderWidth:0.5f];
    [button.layer setBorderColor:[rgb_color(224, 87, 87, 1) CGColor]];
    [button.layer setCornerRadius:5];

    if (indexPath.row < dataArray.count) {
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        [(DeleteFriendsCell *)cell cellForDic:dic];
    }
    
    return cell;
}

@end
