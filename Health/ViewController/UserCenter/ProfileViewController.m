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
    RERadioItem         *jobItem;
    RERadioItem         *areaItem;
    RERadioItem         *kindItem;
    RETextItem          *bloodItem;
    RETextItem          *afterItem;
    RERadioItem         *sickItem;
    REDateTimeItem      *timeItem;
    REDateTimeItem      *birthdayItem;
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
    NSDictionary *dic = [MineRequest singleton].profileDic;
    
    RETableViewSection *section = [RETableViewSection section];
    [manager addSection:section];
    
    nameItem = [RETextItem itemWithTitle:@"姓名 *" value:dic[@"username"]];
    [section addItem:nameItem];
    sexItem = [RESegmentedItem itemWithTitle:@"性别 *" segmentedControlTitles:@[@"男", @"女"] value:[dic[@"sex"] integerValue]];
    [section addItem:sexItem];
    
    __weak typeof(self) weakSelf = self;
    
    heightItem = [RERadioItem itemWithTitle:@"身高" value:[NSString stringWithFormat:@"%@厘米", dic[@"height"]] selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
    }];
    [section addItem:heightItem];
    jobItem = [RERadioItem itemWithTitle:@"体重" value:[NSString stringWithFormat:@"%@千克", dic[@"height"]] selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
    }];
    [section addItem:jobItem];
    areaItem = [RERadioItem itemWithTitle:@"地区 *" value:@"北京" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        
        [[SelectionRequest singleton] getAreaComplete:^{
            NSMutableArray *options = [SelectionRequest singleton].dataArray;
            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            // Push the options controller
            //
            [weakSelf.navigationController pushViewController:optionsController animated:YES];
        }];
    }];
    [section addItem:areaItem];
    kindItem = [RERadioItem itemWithTitle:@"糖尿病类型 *" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        
        [[SelectionRequest singleton] bloodTypeComplete:^{
            NSMutableArray *options = [SelectionRequest singleton].dataArray;
            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            // Push the options controller
            //
            [weakSelf.navigationController pushViewController:optionsController animated:YES];
        }];
    }];
    [section addItem:kindItem];
    bloodItem = [RETextItem itemWithTitle:@"空腹血糖" value:nil];
    [section addItem:bloodItem];
    afterItem = [RETextItem itemWithTitle:@"餐后血糖（2小时）" value:nil];
    [section addItem:afterItem];
    sickItem = [RERadioItem itemWithTitle:@"并发症" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        [[SelectionRequest singleton] complicationComplete:^{
            NSMutableArray *options = [SelectionRequest singleton].dataArray;
            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            // Push the options controller
            //
            [weakSelf.navigationController pushViewController:optionsController animated:YES];
        }];
    }];
    [section addItem:sickItem];
    timeItem = [REDateTimeItem itemWithTitle:@"确诊时间" value:[NSDate date] placeholder:@"" format:@"MM月dd日 hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:timeItem];
    
    birthdayItem = [REDateTimeItem itemWithTitle:@"出生日期" value:[NSDate date] placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
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

@end
