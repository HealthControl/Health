//
//  FriendsViewController.m
//  Health
//
//  Created by VickyCao on 12/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "FriendsViewController.h"
#import "MineRequest.h"
#import "FriendsDetailViewController.h"
#import "CalendarViewController.h"
#import "UIView+Toast.h"
#import "GoodsRequest.h"

@interface AddFriendsCell : UITableViewCell {
    
}

@property (nonatomic, weak)IBOutlet UITextField *relationField;
@property (nonatomic, weak)IBOutlet UITextField *phoneField;

@end

@implementation AddFriendsCell

- (IBAction)sumbitAdd:(id)sender {
    if (_relationField.text.length == 0) {
        [self.viewController.view makeToast:@"关系不能为空"];
        return;
    }
    if (_phoneField.text.length == 0) {
        [self.viewController.view makeToast:@"手机号不能为空"];
        return;
    }
    
    [[MineRequest singleton] addFriendsReletion:_relationField.text mobil:_phoneField.text complete:^{
        [(FriendsViewController *)self.viewController loadData];
        
    } failed:^(NSString *state, NSString *errmsg) {
        [self makeToast:errmsg];
    }];
}

- (void)reloadcell {
    [self.relationField resignFirstResponder];
    self.relationField.text = @"";
    self.phoneField.text = @"";
    [self.phoneField resignFirstResponder];
}

@end

@interface DeleteFriendsCell : UITableViewCell {
    IBOutlet UILabel *relationLabel;
    IBOutlet UILabel *phoneLabel;
    IBOutlet UIButton *deleteButton;
    NSDictionary *saveDic;
    int from;
}

@property (nonatomic, copy) void (^onEvent)();
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *productID;

@end

@implementation DeleteFriendsCell

- (void)cellForDic:(NSDictionary *)dic isAdd:(int)isAdd{
    saveDic = dic;
    relationLabel.text = dic[@"relation"];
    phoneLabel.text = dic[@"mobile"];
    if (isAdd == 1) {
        deleteButton.hidden = YES;
    } else
    {
        deleteButton.hidden = NO;
    }
    from = isAdd;
}

- (IBAction)deleteFriends:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (from == 0) {
        [[MineRequest singleton] deleteFriends:saveDic[@"id"] complete:^{
            [(FriendsViewController *)weakSelf.viewController loadData];
        } failed:^(NSString *state, NSString *errmsg) {
        }];
    } else {
        [[GoodsRequest singleton] addFriendsBuy:saveDic[@"mobile"] productId:self.productID number:self.number complete:^{
            if (weakSelf.onEvent) {
                [self.viewController.view makeToast:@"邀请成功"];
                weakSelf.onEvent();
            }
        } failed:^(NSString *state, NSString *errmsg) {
            
        }];
    }
    
}

@end

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *friendsTableView;
    NSMutableArray *dataArray;
}

@end

@implementation FriendsViewController

- (void)loadView {
    [super loadView];
}

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
    if (self.fromWhere == 1) {
        return dataArray.count;
    }
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
        [(DeleteFriendsCell *)cell cellForDic:dic isAdd:self.fromWhere];
        __weak typeof(self) weakSelf = self;
        ((DeleteFriendsCell *)cell).onEvent = ^() {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        if (self.fromWhere == 2) {
            ((DeleteFriendsCell *)cell).productID = self.productID;
            ((DeleteFriendsCell *)cell).number = self.number;
        }
    } else {
        [(AddFriendsCell *)cell reloadcell];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    if (!dic[@"info"] || [dic[@"info"] isKindOfClass:[NSNull class]]) {
        [self.view makeToast:@"该亲友信息不完整, 请重新添加"];
        return;
    }
    switch (self.fromWhere) {
        case 0:
            if (indexPath.row < dataArray.count) {
                [self performSegueWithIdentifier:@"showfriendsDetail" sender:dic];
            }
            break;
        case 1:
            [self performSegueWithIdentifier:@"friendsCalendar" sender:dic];
            break;
        case 2: {
            // 添加代购
        }
            
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    switch (self.fromWhere) {
        case 0:
        {
            FriendsDetailViewController *detailVC = [segue destinationViewController];
            detailVC.friendsDic = (NSDictionary *)sender;
        }
            break;
        case 1:{
            CalendarViewController *calendarVC = [segue destinationViewController];
            calendarVC.userID = ((NSDictionary *)sender)[@"info"][@"userid"];
        }
            break;
        default:
            break;
    }
}

@end
