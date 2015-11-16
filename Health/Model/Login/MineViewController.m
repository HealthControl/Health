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
    NSDictionary *dic1 = @{@"image":@"first",@"title":@"个人档案",@"identifier":@"Identifier1"};
    NSDictionary *dic2 = @{@"image":@"first",@"title":@"关注亲友",@"identifier":@"Identifier2"};
    NSDictionary *dic3 = @{@"image":@"first",@"title":@"推荐下载",@"identifier":@"Identifier3"};
    NSDictionary *dic4 = @{@"image":@"first",@"title":@"修改密码",@"identifier":@"Identifier4"};
    NSDictionary *dic5 = @{@"image":@"first",@"title":@"我的积分",@"identifier":@"Identifier5"};
    dataArray = @[dic1,dic2,dic3,dic4,dic5];
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
        //cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"title"];
        cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 84;
    }
    return 50;
}

@end

