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
#import "LoginRequest.h"
#import "MineRequest.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSArray *dataArray;
    IBOutlet UITableView *mineTableView;
    IBOutlet UIView *qrcodeView;
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
    NSDictionary *dic3 = @{@"image":@"tuijianxiazai",@"title":@"二维码下载",@"identifier":@"Identifier3"};
    NSDictionary *dic4 = @{@"image":@"xiugaimima",@"title":@"修改密码",@"identifier":@"Identifier4"};
    NSDictionary *dic5 = @{@"image":@"wodejifen",@"title":@"我的积分",@"identifier":@"Identifier5"};
    NSDictionary *dic6 = @{@"image":@"wodedianping",@"title":@"我的点评",@"identifier":@"Identifier6"};
    dataArray = @[dic1,dic2,dic3, dic4,dic5,dic6];
    [self refreshUserInfo];
    
    __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [weakSelf hideQrcodeView];
    }];
    [qrcodeView addGestureRecognizer:gesture];
}

//界面将要显示时调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUserInfo {
    [[MineRequest singleton] getMyInfo:^{
        [mineTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
}

- (void)openCamara {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)openPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];
    image = [image imageByResizeToSize:CGSizeMake(image.size.width/5, image.size.height/5)];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.1)];
    [[MineRequest singleton] uploadHeadImage:image complete:^{
        [self refreshUserInfo];
    } failed:^(NSString *state, NSString *errmsg) {
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)uploadHeaderImage {
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamara];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhoto];
    }];
    [actionsheet addAction:cancelAction];
    [actionsheet addAction:cameraAction];
    [actionsheet addAction:photoAction];
    [self presentViewController:actionsheet animated:YES
                     completion:nil];
}

- (void)showQcodeView {
    qrcodeView.hidden = NO;
    qrcodeView.frame = self.view.bounds;
    qrcodeView.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        qrcodeView.alpha = 1;
    }];
}

- (void)hideQrcodeView {
    [UIView animateWithDuration:0.3f animations:^{
        qrcodeView.alpha = 0;
    } completion:^(BOOL finished) {
        qrcodeView.hidden = YES;
    }];
}

- (IBAction)logout:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@{} forKey:@"userData"];
    [self showLoginVC];
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
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadHeaderImage)];
        [headImage addGestureRecognizer:tapG];
        [headImage.layer setCornerRadius:headImage.height/2];
        headImage.clipsToBounds = YES;
        UILabel        *userNameLabel = [(UILabel *)cell.contentView viewWithTag:2];
        UILabel        *userIDLabel = [(UILabel *)cell.contentView viewWithTag:3];
        LoginData *data = [UserCentreData singleton].userInfo;
        [headImage setImageWithUrl:[NSURL URLWithString:data.userpic] defaultImage:nil];
        userNameLabel.text = data.username;
        userIDLabel.text = [NSString stringWithFormat:@"账号: %@", data.userid];
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
        identifier = @"Identifier1";
    } else {
        identifier = [[dataArray objectAtIndex:indexPath.row] objectForKey : @"identifier" ];
    }
    if (identifier) {
        NSLog(@"identifier = %@", identifier);
        if ([identifier isEqualToString:@"Identifier3"]) {
            [self showQcodeView];
        } else {
            [self performSegueWithIdentifier:identifier sender:self];
        }
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

