//
//  BloodControlViewController.m
//  Health
//
//  Created by antonio on 15/10/21.
//  Copyright © 2015年 vickycao1221. All rights reserved.
//

#import "BloodControlViewController.h"
#import "LoginRequest.h"

@interface BloodControlViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *dataArray;
}

@end

@implementation BloodControlViewController

//xib加载完毕时调用
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"血糖管理";
    NSDictionary *dic1 = @{@"image":@"first",@"title":@"测血糖"};
    NSDictionary *dic2 = @{@"image":@"first",@"title":@"糖历"};
    NSDictionary *dic3 = @{@"image":@"first",@"title":@"健康报告"};
    NSDictionary *dic4 = @{@"image":@"first",@"title":@"风险评估"};
    
    NSDictionary *dic5 = [NSDictionary dictionary];
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setObject:@"first" forKey:@"image"];
    
    //dataArray = @[@"1111",@"22222", @"333333",@"44444"];
    dataArray = @[dic1, dic2, dic3, dic4];
//    dataArray = [[NSArray alloc] initWithContentsOfFile:@""];
//    dataArray = [NSArray array];
//    NSMutableArray *dataArray1 = [[NSMutableArray alloc] init];
//
//    [dataArray1 addObject:@""];
    
    
    /***   登陆测试
    
    NSDictionary *dic = @{@"username":@"aaa", @"mobile":@"13716366680", @"code":@"1234", @"invitecode":@"", @"password":@"aaa"};
    [[LoginRequest singleton] registerWithDictionary:dic complete:^{
        NSLog(@"complete");
    } failed:^(NSString *state, NSString *errmsg) {
        NSLog(@"failed");
    }];
    
     
    **/

    

    NSDictionary *loginDic = @{@"loginname":@"15652767777", @"password":@"aaaa"};
    [[LoginRequest singleton] loginWithDictionary:loginDic complete:^{
        NSLog(@"登陆成功");
    } failed:^(NSString *state, NSString *errmsg){
        NSLog(@"登陆失败");
    }];

    
    /***  验证码测试  **/
    
//    NSDictionary *mobileDic = @{@"mobile":@"15652767687"};
//    [[LoginRequest singleton] sendSms:mobileDic complete:^{
//        NSLog(@"发送成功");
//    } failed:^(NSString *state, NSString *errMsg){
//        NSLog(@"发送失败");
//    }];
}

//界面将要显示时调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"BloodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
//    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
//    //cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dic objectForKey:@"title"];
//    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = nil;
    switch (indexPath.row) {
        case 0:
            Identifier = @"glucoseBloodIdentifier";
            break;
        
        default:
            break;
    }
    if (Identifier) {
        [self performSegueWithIdentifier:Identifier sender:self];
    }
    
}




@end
