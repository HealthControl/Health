//
//  NewAddressViewController.m
//  Health
//
//  Created by VickyCao on 12/23/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "NewAddressViewController.h"
#import "RETableViewManager.h"
#import "GoodsRequest.h"

@interface NewAddressViewController () <RETableViewManagerDelegate>

@end

@implementation NewAddressViewController {
    IBOutlet UITableView *addTableView;
    
    RETableViewManager    *manager;
    
    // tableView Item
    RETextItem          *nameItem;
    RETextItem          *phoneItem;
    RETextItem          *codeItem;
    RETextItem          *proviceItem;
    RETextItem          *streetItem;
    RELongTextItem      *addItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [[RETableViewManager alloc] initWithTableView:addTableView delegate:self];
    manager.style.cellHeight = 60;
    [self addSection];
}

- (void)addSection {
    RETableViewSection *section = [RETableViewSection section];
    [manager addSection:section];
    
    nameItem = [RETextItem itemWithTitle:@"收货人姓名" value:@"" placeholder:@"收货人姓名"];
    [section addItem:nameItem];
    phoneItem = [RETextItem itemWithTitle:@"手机号码" value:@"" placeholder:@"手机号码"];
    [section addItem:phoneItem];
    codeItem = [RETextItem itemWithTitle:@"邮政编码" value:@"" placeholder:@"邮政编码"];
    [section addItem:codeItem];
    proviceItem = [RETextItem itemWithTitle:@"省市区" value:@"" placeholder:@""];
    [section addItem:proviceItem];
    streetItem = [RETextItem itemWithTitle:@"街道" value:@"" placeholder:@""];
    [section addItem:streetItem];
    addItem = [RELongTextItem itemWithValue:@"" placeholder:@"详细地址"];
    [section addItem:addItem];

    [addTableView reloadData];
}

- (IBAction)save:(id)sender {
    if ([nameItem.value isEqualToString:@""]) {
        [self.view makeToast:@"姓名不能为空"];
        return;
    }
    if ([phoneItem.value isEqualToString:@""]) {
        [self.view makeToast:@"手机号不能为空"];
        return;
    }
    if ([proviceItem.value isEqualToString:@""]) {
        [self.view makeToast:@"省份不能为空"];
        return;
    }
    if ([streetItem.value isEqualToString:@""]) {
        [self.view makeToast:@"街道不能为空"];
        return;
    }
    if ([addItem.value isEqualToString:@""]) {
        [self.view makeToast:@"地址不能为空"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"userid"] = [UserCentreData singleton].userInfo.userid;
    dic[@"token"] = [UserCentreData singleton].userInfo.token;
    dic[@"name"] = nameItem.value;
    dic[@"province"] = proviceItem.value;
    dic[@"city"] = streetItem.value;
    dic[@"address"] = addItem.value;
    dic[@"postcode"] = codeItem.value;
    dic[@"mobile"] = phoneItem.value;
    [[GoodsRequest singleton] addAddress:dic complete:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}


@end
