//
//  BuyViewController.m
//  Health
//
//  Created by VickyCao on 12/12/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "BuyViewController.h"
#import "GoodsRequest.h"
#import "MineRequest.h"
#import "DTNetImageView.h"
#import "ChoiseAddressViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface BuyViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>{
    IBOutlet UITableView *buyTableView;
    NSString *points;
}

@property (nonatomic, strong) IBOutlet UILabel     *totalLabel;

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buyTableView.delegate = self;
    buyTableView.dataSource = self;
    points = @"0";
//    __weak typeof(self) weakSelf = self;
//    if (![GoodsRequest singleton].buyArray) {
//        [[GoodsRequest singleton] getCharts:^{
//            [buyTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf total];
//        } failed:^(NSString *state, NSString *errmsg) {
//            
//        }];
//    } else {
//        
//    }
    
    [self total];
    [[MineRequest singleton] getJifen:[UserCentreData singleton].userInfo.userid complete:^{
        [buyTableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
    
    __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [weakSelf keybordHidden];
    }];
    tapG.delegate = self;
    [buyTableView addGestureRecognizer:tapG];
    [buyTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [buyTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)total {
    float total = 0;
    for (BuyDetail *d in self.buyArray) {
        total += [d.number intValue]*[d.price floatValue];
    }
    self.totalLabel.text = [NSString stringWithFormat:@"实付: %0.2f",total];
}

- (void)addAddress {
    [self performSegueWithIdentifier:@"newAddress" sender:self];
}

- (IBAction)submitOrder:(id)sender {
//    addressid 地址id
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userid"] = [UserCentreData singleton].userInfo.userid;
    dic[@"token"] = [UserCentreData singleton].userInfo.token;
    
    NSMutableString *str = [NSMutableString stringWithString:@""];
    for (int i = 0; i < self.buyArray.count; i++) {
        BuyDetail *detail = self.buyArray[i];
        [str appendFormat:@"%@,%d;", detail.id, [detail.number intValue]];
    }
    [str replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
    dic[@"product"] = str;
    dic[@"point"] = points;
    dic[@"addressid"] = [GoodsRequest singleton].addressDic[@"id"];
    dic[@"delivery_method"] = @"顺丰";
    
    [[GoodsRequest singleton] postOrder:dic complete:^{
        [self openAlipay];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)openAlipay {
    NSDictionary *orderDic = [GoodsRequest singleton].orderDic;
    [[AlipaySDK defaultService] payOrder:orderDic[@"alipay_string"] fromScheme:@"ptangAlipay" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.buyArray.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifter = @"";
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:{
            identifter = @"addressCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifter];
            UIButton *button = [cell.contentView viewWithTag:1];
            UILabel *addressLabel = [cell.contentView viewWithTag:2];
            if ([GoodsRequest singleton].addressDic) {
                button.hidden = YES;
                addressLabel.hidden = NO;
                addressLabel.text = [NSString stringWithFormat:@"%@   %@   %@",[[GoodsRequest singleton].addressDic objectForKey:@"name"], [[GoodsRequest singleton].addressDic objectForKey:@"mobile"], [[GoodsRequest singleton].addressDic objectForKey:@"address"]];
            } else {
                addressLabel.hidden = YES;
                button.hidden = NO;
                [button.layer setBorderColor:[rgb_color(229, 87, 87, 1) CGColor]];
                [button.layer setBorderWidth:0.5f];
                [button.layer setCornerRadius:4];
                [button addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
            break;
        case 1:
        {
            identifter = @"goodsDetail";
            cell = [tableView dequeueReusableCellWithIdentifier:identifter];
            BuyDetail *detail = [self.buyArray objectAtIndex:indexPath.row];
            DTNetImageView *netImageView = [cell.contentView viewWithTag:1];
            [netImageView setImageWithURL:[NSURL URLWithString:detail.thumb] options:YYWebImageOptionProgressiveBlur];
            UILabel *label1 = [cell.contentView viewWithTag:2];
            label1.text = [NSString stringWithFormat:@"%@    ￥%@", detail.title, detail.price];
            UILabel *label2 = [cell.contentView viewWithTag:3];
            label2.text = [NSString stringWithFormat:@"药品规格:%@ ", detail.specification];
            UILabel *label3 = [cell.contentView viewWithTag:4];
            label3.text = [NSString stringWithFormat:@"药品介绍:%@ ", detail.newsDescription];
            UILabel *label4 = [cell.contentView viewWithTag:5];
            label4.text = [NSString stringWithFormat:@"药品数量:%d", [detail.number intValue]];
    }
            break;
        case 2:{
            identifter = @"wodejifencell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifter];
            UILabel *label = [cell.contentView viewWithTag:1];
            label.text = [MineRequest singleton].jifen;
            UITextField *field = [cell.contentView viewWithTag:2];
            [field.layer setCornerRadius:5];
            [field.layer setBorderColor:[rgb_color(229, 87, 87, 1) CGColor]];
            [field.layer setBorderWidth:0.5f];
//            label.text = [MineRequest singleton].jifen;
        }
            
            break;
        case 3:
            identifter = @"payCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifter];
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    switch (indexPath.section) {
        case 0:
            height = 80;
            break;
         case 1:
            height = 180;
            break;
        case 2:
            height = 100;
            break;
        case 3:
            height = 44;
            break;
        default:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"showAddress" sender:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text intValue] > [[MineRequest singleton].jifen intValue]) {
        [self.view makeToast:@"您的积分不够，请重新填写"];
        return NO;
    }
    points = textField.text;
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAddress"]) {
        ChoiseAddressViewController *modifyVC = [segue destinationViewController];
        __weak typeof(self) weakSelf = self;
        modifyVC.select = ^() {
            [weakSelf.navigationController popToViewController:self animated:YES];
        };
    }
}

- (void)keybordHidden {
    NSArray *cells = [buyTableView visibleCells];
    for (UITableViewCell *cell in cells) {
        for (UIView *v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UITextField class]]) {
                [v resignFirstResponder];
            }
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([YYTextKeyboardManager defaultManager].isKeyboardVisible) {
        return YES;
    }
    return NO;
}

@end
