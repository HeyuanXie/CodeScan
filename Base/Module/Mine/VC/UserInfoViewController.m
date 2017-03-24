//
//  UserInfoController.m
//  Template
//
//  Created by hitao on 16/10/3.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "UserInfoViewController.h"
#import "InfoHeaderCell.h"
#import "UIButton+HYButtons.h"
#import "APIHelper+User.h"
#import <UIActionSheet+BlocksKit.h>
#import "DatePickerController.h"
#import "UIViewController+KNSemiModal.h"
#import "MBProgressHUD+hyHUD.h"
#import "APIHelper+Common.h"
#import "HYAddressController.h"

#define kCellMineIdentify @"CellMineIdentify"

@interface UserInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic, strong) NSArray *infos;
@property(nonatomic, strong) UserInfoModel *userInfo;
@end

@implementation UserInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[InfoHeaderCell identify] bundle:nil] forCellReuseIdentifier:[InfoHeaderCell identify]];
    
    [self dataInit];
    [self.tableView reloadData];
    self.tableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataInit{
    self.userInfo = [APIHELPER.userInfo copy];
//    self.infos = @[@[@"头像",
//                     @"昵称",
//                     @"性别",
//                     @"生日",
//                     @"所在城市",
//                     @"手机号"],
//                   @[@"修改密码",@"loginout"]
//                   ];
    self.infos = @[@[@"头像",
                     @"昵称",
                     @"性别",
                     @"生日",
                     @"所在城市"],
                   ];
}

#pragma mark tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.infos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.infos[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        InfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:[InfoHeaderCell identify]];
        if(self.userInfo.faceUrl){
            [cell setHeaderUrlString:self.userInfo.faceUrl];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellMineIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellMineIdentify];
        }
        cell.textLabel.text = self.infos[indexPath.section][indexPath.row];
        cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor hyBlackTextColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch(indexPath.row){
            case 1:{//昵称
                cell.detailTextLabel.text = self.userInfo.nickName;
            }break;
            case 2:{//性别
                cell.detailTextLabel.text = [self.userInfo.sex isEqualToString:@"1"] ? @"男": @"女";
            }break;
            case 3:{//生日
                cell.detailTextLabel.text = self.userInfo.birthday;
            }break;
            case 4:{//所在地区
                cell.detailTextLabel.text = self.userInfo.areaName;
            }break;
            case 5:{//手机号
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = self.userInfo.account;
            }break;
        }
        return cell;
    }
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return  [InfoHeaderCell height];
    }else if(indexPath.section == self.infos.count -1 && indexPath.row == [self.infos[indexPath.section] count] - 1){
        return 60.0;
    }
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self showCamera];
                    }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self showPhotoLibrary];
                    }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertC animated:YES completion:nil];
                }break;
                case 1:{
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = @"昵称";
                    }];
                    @weakify(self);
                    [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        UITextField *textField = alertC.textFields[0];
                        self.userInfo.nickName = textField.text;
                        [self updateUserInfo];
                    }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertC animated:YES completion:nil];
                }break;
                case 2:{
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    @weakify(self);
                    [alertC addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        self.userInfo.sex = @"1";
                        [self updateUserInfo];
                    }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        self.userInfo.sex = @"2";
                        [self updateUserInfo];
                    }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertC animated:YES completion:nil];
                }break;
                case 3:{
                    DatePickerController *picker = [[DatePickerController alloc] init];
                    CGRect frame = picker.view.frame;
                    frame.size.height = 216;
                    picker.view.frame = frame;
                    @weakify(self);
                    [picker setSelectDate:^(NSString *dateString) {
                        @strongify(self);
                        self.userInfo.birthday = dateString;
                        [self updateUserInfo];
                    }];
                    [self presentSemiViewController:picker withOptions:@{KNSemiModalOptionKeys.pushParentBack: @(NO),
                                                                         KNSemiModalOptionKeys.animationDuration: @(0.2),
                                                                         KNSemiModalOptionKeys.shadowOpacity: @(0.6)}];
                }break;
                case 4:{
                    HYAddressController *addressC = (HYAddressController *)VIEWCONTROLLER(kAddressController);
                    [addressC setSelectAddress:^(NSString *areaName, NSString *areaID) {
                        self.userInfo.areaID = areaID;
                        self.userInfo.areaName = areaName;
                        [self updateUserInfo];
                    }];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:addressC] animated:YES completion:nil];
                }break;
                default:
                    break;
            }
        }break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    APPROUTE(kChangePasswordController);
                }break;
                default:
                    break;
            }
        }break;
        default:
            break;
    }
}

- (void)updateUserInfo{
    [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [APIHELPER updateUserInfo:self.userInfo.nickName face:self.userInfo.filename sex:self.userInfo.sex birthday:self.userInfo.birthday area:self.userInfo.areaID complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!isSuccess && error) {
            self.userInfo = [APIHELPER.userInfo copy];
            [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
        }else{
            APIHELPER.userInfo = [UserInfoModel yy_modelWithDictionary:responseObject[@"data"]];
        }
        [self.tableView reloadData];
    }];
}


- (UIImagePickerController*)createImagePicker {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.navigationBar.barTintColor = [UIColor hyBarTintColor];
    return imagePicker;
}
- (void)showCamera{
    UIImagePickerController* imagePicker = [self createImagePicker];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoLibrary{
    UIImagePickerController * imagePicker = [self createImagePicker];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)logout{
    [APIHELPER logout];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        @weakify(self);
        [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
        [APIHELPER uploadFileByType:@"face" file:data progress:nil complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            @strongify(self);
            if (isSuccess) {
                self.userInfo.filename = responseObject[@"data"][@"filename"];
                self.userInfo.faceUrl = responseObject[@"data"][@"url"];
                [self.tableView reloadData];
                [self updateUserInfo];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error) {
                    [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
                }
            }
        }];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
