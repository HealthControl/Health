//
//  ProfileViewController.m
//  Health
//
//  Created by VickyCao on 12/17/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ProfileViewController.h"
#import "RETableViewManager.h"
#import "MineRequest.h"
#import "RETableViewOptionsController.h"
#import "SelectionRequest.h"

@interface ProfileViewController () <RETableViewManagerDelegate>{
    IBOutlet UITableView *profileTableView;
    RETableViewManager    *manager;
    
    // tableView Item
    RETextItem          *nameItem;
    RESegmentedItem     *sexItem;
    RERadioItem         *heightItem;
    RERadioItem         *weightItem;
    RERadioItem         *jobItem;
//    RERadioItem         *areaItem;
    REPickerItem        *areaItem;
    RERadioItem         *kindItem;
    RETextItem          *bloodItem;
    RETextItem          *afterItem;
    RERadioItem         *sickItem;
    REDateTimeItem      *timeItem;
    REDateTimeItem      *birthdayItem;
    
    RELongTextItem      *recordItem;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [[RETableViewManager alloc] initWithTableView:profileTableView delegate:self];
    manager.style.cellHeight = 50;
    __weak typeof(self) weakSelf = self;
    [[MineRequest singleton] getProfileComplete:^{
        [weakSelf reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadData {
    UserInfo *profile = [MineRequest singleton].profileInfo;
    
    RETableViewSection *section = [RETableViewSection section];
    [manager addSection:section];
    
    nameItem = [RETextItem itemWithTitle:@"姓名 *" value:profile.username];
    [section addItem:nameItem];
    
    sexItem = [RESegmentedItem itemWithTitle:@"性别 *" segmentedControlTitles:@[@"男", @"女"] value:[profile.sex integerValue]==1?0:1];
    [section addItem:sexItem];
    
    __weak typeof(self) weakSelf = self;
    
//    REPickerItem
    NSMutableArray *heightArray = [NSMutableArray array];
    for (int i = 130 ; i< 201; i++) {
        NSString *str = [NSString stringWithFormat:@"%d厘米", i];
        [heightArray addObject:str];
    }
    
    heightItem = [RERadioItem itemWithTitle:@"身高" value:[NSString stringWithFormat:@"%@厘米", profile.height] selectionHandler:^(RERadioItem *item) {
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:heightArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        [item deselectRowAnimated:YES];
    }];
    [section addItem:heightItem];
    
    NSMutableArray *weightArray = [NSMutableArray array];
    for (int i = 350 ; i< 1000; i++) {
        NSString *str = [NSString stringWithFormat:@"%0.1f千克", i/10.0];
        [weightArray addObject:str];
    }
    weightItem = [RERadioItem itemWithTitle:@"体重" value:[NSString stringWithFormat:@"%@千克", profile.weight] selectionHandler:^(RERadioItem *item) {
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:weightArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        [item deselectRowAnimated:YES];
    }];
    [section addItem:weightItem];
    
    jobItem = [RERadioItem itemWithTitle:@"职业" value:profile.profession selectionHandler:^(RERadioItem *item) {
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:[SelectionRequest singleton].professionNameArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
        [item deselectRowAnimated:YES];
    }];
    [section addItem:jobItem];
    
    NSArray *area = [[MineRequest singleton].profileInfo.area componentsSeparatedByString:@","];

  
    areaItem = [REPickerItem itemWithTitle:@"地区" value:area placeholder:@"请选择地区" options:[SelectionRequest singleton].areaArray];
    areaItem.onChange = ^(REPickerItem *item){
        NSLog(@"Value: %@", item.value);
    };
    
    areaItem.inlinePicker = NO;
    [section addItem:areaItem];
    
    NSString *titleName = @"";
    for (NSDictionary *dic in [SelectionRequest singleton].bloodTypeArray) {
        BOOL hasFind = NO;
        if ([[MineRequest singleton].profileInfo.type intValue] == [dic[@"key"] intValue]) {
            titleName = dic[@"value"];
            break;
        }
        if (hasFind)
            break;
    }
    
    kindItem = [RERadioItem itemWithTitle:@"糖尿病类型 *" value:titleName selectionHandler:^(RERadioItem *item) {
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:[SelectionRequest singleton].bloodTypeNameArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        [item deselectRowAnimated:YES];
    }];
    [section addItem:kindItem];
    
    bloodItem = [RETextItem itemWithTitle:@"空腹血糖" value:@"" placeholder:profile.bloodsugar_empty];
    [section addItem:bloodItem];
    afterItem = [RETextItem itemWithTitle:@"餐后血糖（2小时）" value:@"" placeholder:profile.bloodsugar_dinner];
    [section addItem:afterItem];
    
    recordItem = [RELongTextItem itemWithTitle:@"" value:profile.medication?:@"" placeholder:@"请输入用药记录"];
    recordItem.cellHeight = 80;
    [section addItem:recordItem];
    
    sickItem = [RERadioItem itemWithTitle:@"并发症" value:profile.complication selectionHandler:^(RERadioItem *item) {
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:[SelectionRequest singleton].complicationNameArray multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [item reloadRowWithAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        [item deselectRowAnimated:YES];
    }];
    [section addItem:sickItem];
    NSDate *confirmdate = [NSDate dateWithString:profile.confirmed_date format:@"yyyy-mm-dd"];
    timeItem = [REDateTimeItem itemWithTitle:@"确诊时间" value:confirmdate placeholder:@"请选择时间" format:@"MM月dd日 hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:timeItem];
    
    NSDate *date = [NSDate dateWithString:profile.birthday format:@"yyyy-mm-dd"];
    birthdayItem = [REDateTimeItem itemWithTitle:@"出生日期" value:date placeholder:@"出生日期" format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    birthdayItem.onChange = ^(REDateTimeItem *item){
        NSLog(@"Value: %@", item.value.description);
    };
    [section addItem:birthdayItem];
    [profileTableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            ((UILabel *)view).font = [UIFont systemFontOfSize:14];
        ((UILabel *)view).textColor = rgb_color(153, 153, 153, 1);
        }
    }
}

- (IBAction)submit:(id)sender {
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    postDic[@"userid"] = [UserCentreData singleton].userInfo.userid;
    postDic[@"token"] = [UserCentreData singleton].userInfo.token;
    if ([nameItem.value isEqualToString:@""]) {
        [self.view makeToast:@"请输入姓名"];
        return;
    }
    postDic[@"name"] = nameItem.value;
    postDic[@"sex"] = sexItem.value == 0?@"1":@"2";
    
    if (areaItem.value.count == 0) {
        [self.view makeToast:@"请选择地区"];
    }
   
    NSString *area = [areaItem.value componentsJoinedByString:@", "];
    postDic[@"area"] = area;
    
    NSString *type ;
    for (NSDictionary *dic in [SelectionRequest singleton].bloodTypeArray) {
        BOOL hasFind = NO;
        if ([kindItem.value isEqualToString:dic[@"value"]]) {
            type = dic[@"key"];
            break;
        }
        if (hasFind)
            break;
    }
    postDic[@"type"] = type;
    
    postDic[@"profession"] = jobItem.value;
    postDic[@"weight"] = [weightItem.value stringByReplacingOccurrencesOfString:@"千克" withString:@""];
    postDic[@"height"] = [heightItem.value stringByReplacingOccurrencesOfString:@"厘米" withString:@""];

    
    postDic[@"bloodsugar_empty"] = bloodItem.value;
    postDic[@"bloodsugar_dinner"] = afterItem.value;
    postDic[@"confirmed_date"] = [timeItem.value stringWithFormat:@"yyyy-MM-dd"];
    postDic[@"birthday"] = [birthdayItem.value stringWithFormat:@"yyyy-MM-dd"];

    postDic[@"complication"] = sickItem.value;
    postDic[@"medication"] = recordItem.value?:@"";
    [[MineRequest singleton] postProfile:postDic complete:^{
        [self.view makeToast:@"提交成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

@end
