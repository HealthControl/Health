//
//  ExpertsDetailViewController.m
//  Health
//
//  Created by VickyCao on 11/21/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "ExpertsDetailViewController.h"
#import "ExpertRequest.h"
#import "DTNetImageView.h"

@interface ExpertsDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet UITableView *detailTabelView;
    IBOutlet UITextView *submitTextView;
    UIImage *selectImage;
    NSMutableArray *commentArray;
}

@end

@implementation ExpertsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    detailTabelView.delegate = self;
    detailTabelView.dataSource = self;
    commentArray = [NSMutableArray array];
    [[ExpertRequest singleton] getExpertDetail:self.doctorID complete:^{
        [detailTabelView reloadData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [submitTextView resignFirstResponder];
    }];
    [detailTabelView addGestureRecognizer:gesture];
    [self getReplyAndComment];
}

- (void)getReplyAndComment {
    @weakify(self)
    [[ExpertRequest singleton] getReplyAndComment:self.doctorID complete:^{
        @strongify(self);
        [self reloadCommentData];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)reloadCommentData {
    [commentArray removeAllObjects];
    [commentArray addObjectsFromArray:[ExpertRequest singleton].commentArray];
    [detailTabelView reloadData];
}

- (void)commitComment {
    if (submitTextView.text.length == 0) {
        [submitTextView resignFirstResponder];
        [self.view makeToast:@"请输入内容"];
        return;
    }
    
    @weakify(self)
    [[ExpertRequest singleton] postComment:submitTextView.text expertID:self.doctorID fileData:UIImageJPEGRepresentation(selectImage, 0.2) complete:^{
        @strongify(self)
        [self.view makeToast:@"提问成功"];
        submitTextView.text = @"";
        [submitTextView resignFirstResponder];
        [self getReplyAndComment];
    } failed:^(NSString *state, NSString *errmsg) {
        [self.view makeToast:errmsg];
    }];
}

- (void)selectImageAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"选取照片方式" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImagePicker:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
                      
- (void)selectImagePicker:(UIImagePickerControllerSourceType) type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES
                     completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    selectImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            
        case 1:
            return 1;
        case 2:
            return commentArray.count;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        ExpertDetail *detail = [ExpertRequest singleton].expertsDetail;
        if (indexPath.row == 0) {
            identifier = @"expertsInfo";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            DTNetImageView *headerView = [cell.contentView viewWithTag:1];
            UILabel *nameLabel = [cell.contentView viewWithTag:2];
            UILabel *titleLabel = [cell.contentView viewWithTag:3];
            UILabel *IDLabel = [cell.contentView viewWithTag:4];
            [headerView setImageWithUrlString:[NSString stringWithFormat:@"%@", detail.headpic]  defaultImage:nil];
            nameLabel.text = detail.name;
            titleLabel.text = [NSString stringWithFormat:@"%@  %@", detail.position,detail.title];
            IDLabel.text = [NSString stringWithFormat:@"医生编码: %@", detail.number];
        } else {
            identifier = @"expertsDetail";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *introLabel = [cell.contentView viewWithTag:1];
            introLabel.text = detail.introduce;
        }
    } else if (indexPath.section == 1) {
        identifier = @"referExperts";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UITextView *textView = [cell.contentView viewWithTag:1];
        if (!submitTextView) {
            submitTextView = textView;
            [submitTextView.layer setBorderColor:[rgb_color(153, 153, 153, 1) CGColor]];
            [submitTextView.layer setBorderWidth:0.5f];
            [submitTextView.layer setCornerRadius:5];
        } else {
            textView = submitTextView;
        }
        
        UIButton *button = [cell.contentView viewWithTag:2];
        [button addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button2 = [cell.contentView viewWithTag:3];
        [button2 addTarget:self action:@selector(selectImageAlert) forControlEvents:UIControlEventTouchUpInside];
    } else if (indexPath.section == 2) {
        identifier = @"questions";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        UILabel *timeLabel = [cell.contentView viewWithTag:1];
        UILabel *contentLabel = [cell.contentView viewWithTag:2];
        UIImageView *commentImageView = [cell.contentView viewWithTag:3];
        
        CommentData *data = [commentArray objectAtIndex:indexPath.row];
        [commentImageView setImageWithURL:[NSURL URLWithString:data.picture] placeholder:nil];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[data.addtime  floatValue]];
        timeLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
        if (!data.isreply) {
            contentLabel.text = [NSString stringWithFormat:@"咨询内容: %@",data.content];
        } else {
            contentLabel.text = [NSString stringWithFormat:@"回复: %@",data.reply];
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return 100;
            } else {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                UILabel *label = [cell.contentView viewWithTag:1];
                ExpertDetail *detail = [ExpertRequest singleton].expertsDetail;
                label.text = detail.introduce;

                [cell setNeedsUpdateConstraints];
                [cell updateConstraintsIfNeeded];
                return [detail.introduce heightForFont:label.font width:label.width]+60;
            }
        }
        case 1:
            return 244;
        case 2: {
            CommentData *dic = [commentArray objectAtIndex:indexPath.row];
            float height = 0;
            if (dic.isreply) {
                height = [[NSString stringWithFormat:@"回复内容: %@",dic.reply]  heightForFont:[UIFont systemFontOfSize:14] width:[UIScreen mainScreen].bounds.size.width - 16]+43;
            } else {
                height = [[NSString stringWithFormat:@"咨询内容: %@",dic.content]  heightForFont:[UIFont systemFontOfSize:14] width:[UIScreen mainScreen].bounds.size.width - 16]+43;
            }
            if (dic.picture && ![dic.picture isEqualToString:@""]) {
                height += 180;
            } 
            return height;
        }
            break;
        default:
            break;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (void)detailView:(BOOL)isForHeight {
    
}

@end
