//
//  MineViewController.m
//  Health
//
//  Created by antonio on 15/11/16.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "MineViewController.h"
#import "UserCentreData.h"
#import "DTNetImageView.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *dataArray;
    IBOutlet UITableView *mineTableView;
}
@end

@implementation MineViewController

//xib加载完毕时调用
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mineTableView.dataSource = self;
    mineTableView.delegate =self;
    NSDictionary *dic1 = @{@"image":@"gerndangan",@"title":@"个人档案",@"identifier":@"Identifier1"};
    NSDictionary *dic2 = @{@"image":@"guanzhuqinyou",@"title":@"关注亲友",@"identifier":@"Identifier2"};
    NSDictionary *dic3 = @{@"image":@"tuijianxiazai",@"title":@"推荐下载",@"identifier":@"Identifier3"};
    NSDictionary *dic4 = @{@"image":@"xiugaimima",@"title":@"修改密码",@"identifier":@"Identifier4"};
    NSDictionary *dic5 = @{@"image":@"wodejifen",@"title":@"我的积分",@"identifier":@"Identifier5"};
    NSDictionary *dic6 = @{@"image":@"wodedianping",@"title":@"我的的点评",@"identifier":@"Identifier6"};
    dataArray = @[dic1,dic2,dic3,dic4,dic5,dic6];
}

//界面将要显示时调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"infoCell";
    if (indexPath.section == 1) {
        Identifier = @"meauCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (indexPath.section == 0) {
        DTNetImageView *headImage = [(DTNetImageView *)cell.contentView viewWithTag:1];
        UILabel        *userNameLabel = [(UILabel *)cell.contentView viewWithTag:2];
        UILabel        *userIDLabel = [(UILabel *)cell.contentView viewWithTag:3];
//        [UserCentreData singleton].userInfo.username
        [headImage setImageWithUrl:[NSURL URLWithString:@""] defaultImage:nil];
        userNameLabel.text = @"sssss";
        userIDLabel.text = @"aaaa";
    } else {
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        imageView.image = [UIImage imageNamed:dic[@"image"]];
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:2];
        titleLabel.text = dic[@"title"];
    }
    
    return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *identifier = nil;
    if (indexPath.section == 0) {
        identifier = @"complete userInfo";
    } else {
        identifier = [[dataArray objectAtIndex:indexPath.row] objectForKey : @"identifier" ];
    }
    if (identifier) {
        NSLog(@"identifier = %@", identifier);
//        [self performSegueWithIdentifier:identifier sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 84;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

@end

