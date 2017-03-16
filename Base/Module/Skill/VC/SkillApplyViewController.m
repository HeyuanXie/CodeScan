//
//  SkillApplyViewController.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillApplyViewController.h"
#import "BaseNavigationController.h"
#import "HYAddressController.h"
#import "ApplyTitleCell.h"
#import "ApplyCommonCell.h"
#import "SkillDeclarationCell.h"

@interface SkillApplyViewController () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(strong,nonatomic)NSArray* infos;
@property(strong,nonatomic)NSMutableArray* payMethods;
@property(assign,nonatomic)NSInteger selectIndex;   //记录选中的支付方式

@property(nonatomic,strong)UILabel *priceLbl;
@property(nonatomic,assign)NSInteger total;

@property(nonatomic,assign)BOOL isAgree;

@property(strong,nonatomic)BaseNavigationController* addressNVC;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *gender;

@property(nonatomic,strong)NSString *faceUrl;   //宝宝头像url



@end

@implementation SkillApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, zoom(120), 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[ApplyTitleCell identify] bundle:nil] forCellReuseIdentifier:[ApplyTitleCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[ApplyCommonCell identify] bundle:nil] forCellReuseIdentifier:[ApplyCommonCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[SkillDeclarationCell identify] bundle:nil] forCellReuseIdentifier:[SkillDeclarationCell identify]];


    [self dataInit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1003:
            textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 1006:
            textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1001:
            break;
        default:
            break;
    }
}

#pragma mark - imagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:data];
        [self.tableView reloadData];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.infos.count : self.payMethods.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* title = self.infos[indexPath.row][@"title"];
        //MARK:报名费cell
        if ([title isEqualToString:@"报名费"]) {
            static NSString* cellId = @"moneyCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:self.priceLbl];
                [self.priceLbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
            }
            return cell;
        }else if ([title isEqualToString:@"参赛宣言:"]){
            //MARK:参赛宣言cell
            SkillDeclarationCell* cell = [tableView dequeueReusableCellWithIdentifier:[SkillDeclarationCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            return cell;
            /*
             
             else if([title isEqualToString:@"上传宝宝头像:"]) {
             //MARK:上传头像cell
             ApplyCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:[ApplyCommonCell identify]];
             
             UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
             [cell.contentView addSubview:imgV];
             [imgV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
             [imgV autoSetDimensionsToSize:CGSizeMake(62, 62)];
             [imgV autoAlignAxisToSuperviewAxis:ALAxisVertical];
             
             [cell configSkillApplyCommonCell:self.infos[indexPath.row]];
             
             //            static NSString* cellId = @"imageCell";
             //            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
             //            if (cell == nil) {
             //                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
             //                [HYTool configTableViewCellDefault:cell];
             //                cell.contentView.backgroundColor = [UIColor whiteColor];
             //                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             //
             //
             //
             //                UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
             //                imgV.tag = 1000;
             //                [cell.contentView addSubview:imgV];
             //                [imgV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
             //                [imgV autoSetDimensionsToSize:CGSizeMake(62, 62)];
             //                [imgV autoAlignAxisToSuperviewAxis:ALAxisVertical];
             //            }
             //            UIImageView* imgV = [cell.contentView viewWithTag:1000];
             //TODO:设置图片
             return cell;
             }*/
        }else if (indexPath.row == 0) {
            ApplyTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTitleCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            //TODO:
            
            [cell configSkillApplyTitleCell:nil];
            return cell;
        }else{
            ApplyCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:[ApplyCommonCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            cell.addressLbl.text = [title isEqualToString:@"所在城市:"] ? self.address : self.gender;
            cell.addressLbl.hidden = ([title isEqualToString:@"所在城市:"] || [title isEqualToString:@"性别:"]) ? NO : YES;

            cell.inputTf.tag = 1000 + indexPath.row;
            cell.inputTf.delegate = self;
            
            if ([title isEqualToString:@"上传宝宝头像:"]) {
                UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 62)];
                [cell.contentView addSubview:imgV];
                [imgV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
                [imgV autoSetDimensionsToSize:CGSizeMake(62, 62)];
                [imgV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
                [HYTool configViewLayerRound:imgV];
                [imgV sd_setImageWithURL:[NSURL URLWithString:self.faceUrl] placeholderImage:ImageNamed(@"yazi")];
            }
            
            [cell configSkillApplyCommonCell:self.infos[indexPath.row]];
            return cell;
        }
    }else{
        static NSString* cellId = @"payCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            UIButton* selectBtn = [HYTool getButtonWithFrame:CGRectZero title:nil titleSize:0 titleColor:nil backgroundColor:[UIColor clearColor] blockForClick:nil];
            [selectBtn setImage:ImageNamed(@"on") forState:UIControlStateSelected];
            [selectBtn setImage:ImageNamed(@"off") forState:UIControlStateNormal];
            selectBtn.tag = 1000 + indexPath.row;
            [cell.contentView addSubview:selectBtn];
            [selectBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
            [selectBtn autoSetDimension:ALDimensionWidth toSize:48];
        }
        UIButton* selectBtn = [cell.contentView viewWithTag:1000+indexPath.row];
        selectBtn.selected = indexPath.row == self.selectIndex;
        selectBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.selectIndex = indexPath.row;
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            return [RACSignal empty];
        }];
        if (indexPath.row == 0) {
            selectBtn.hidden = YES;
            cell.textLabel.text = @"支付方式";
            cell.textLabel.textColor = [UIColor blackColor];
            cell.imageView.image = nil;
            cell.imageView.hidden = YES;
        }else{
            selectBtn.hidden = NO;
            cell.imageView.image = ImageNamed(@"cart");
            cell.imageView.hidden = NO;
            cell.textLabel.text = self.payMethods[indexPath.row];
            cell.textLabel.textColor = [UIColor hyBlackTextColor];
        }
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    return section == 0 ? nil : headView;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* title = self.infos[indexPath.row][@"title"];
        return [title isEqualToString:@"参赛宣言:"] ? 118 : (indexPath.row <= 1 ? 76 : 50);
    }else{
        return indexPath.row == 0 ? 50 : 68;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0: {
            NSString* title = self.infos[indexPath.row][@"title"];
            if ([title isEqualToString:@"上传宝宝头像:"]) {
                [self selectPhoto];
            }
            if ([title isEqualToString:@"所在城市:"]) {
                [self filterAddress:nil];
                return;
            }
            if ([title isEqualToString:@"性别:"]) {
                [self chooseGender];
                return;
            }
            break;
        }
        default: {
            if (indexPath.row == 0) {
                return;
            }
            self.selectIndex = indexPath.row;
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

#pragma mark - IBActions
- (IBAction)agree:(id)sender {
    self.isAgree = !self.isAgree;
}

- (IBAction)submitApply:(id)sender {
    if (!self.isAgree) {
        [self showMessage:@"清先同意报名协议"];
        return;
    }
    //TODO:报名
    //    [APIHELPER ]
    APPROUTE(kSkillUploadViewController);
}

#pragma mark - private methods
- (UILabel *)priceLbl {
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] init];
        _priceLbl.text = [NSString stringWithFormat:@"报名费: ¥%ld",self.total];
        _priceLbl.textAlignment = NSTextAlignmentRight;
        _priceLbl.textColor = RGB(65, 65, 65, 1.0);
        _priceLbl.font = [UIFont systemFontOfSize:14];
    }
    return _priceLbl;
}

-(NSMutableArray *)payMethods {
    if (!_payMethods) {
        _payMethods = [NSMutableArray array];
    }
    return _payMethods;
}

-(void)dataInit {
    self.infos = @[  @{@"title":@"title:",@"necessary":@(0)},
                     @{@"title":@"上传宝宝头像:",@"necessary":@(1)},
                     @{@"title":@"家长姓名:",@"necessary":@(1)},
                     @{@"title":@"宝宝姓名:",@"necessary":@(1)},
                     @{@"title":@"年龄:",@"necessary":@(1)},
                     @{@"title":@"性别:",@"necessary":@(1)},
                     @{@"title":@"所在城市:",@"necessary":@(0)},
                     @{@"title":@"手机号:",@"necessary":@(1)},
                     @{@"title":@"参赛宣言:",@"necessary":@(0)},
                     @{@"title":@"报名费",@"necessary":@(0)},
                   ];
    self.payMethods = [@[@"支付方式",@"微信支付",@"支付宝支付"] mutableCopy];
    //TODO:self.total获取
    self.total = 30;
}


-(BaseNavigationController *)addressNVC {
    if (!_addressNVC) {
        HYAddressController *addressC = (HYAddressController *)VIEWCONTROLLER(kAddressController);
        addressC.backItemHidden = YES;
        @weakify(self);
        [addressC setSelectAddress:^(NSString *areaName, NSString *areaID) {
            @strongify(self);
            self.address = areaName;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self hiddenFilterAddress];
        }];
        [addressC setFilterDismiss:^{
            @strongify(self);
            [self hiddenFilterAddress];
        }];
        addressC.isFilter = YES;
        _addressNVC = [[BaseNavigationController alloc] initWithRootViewController:addressC];
        [_addressNVC.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setTintColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setBarTintColor:[UIColor whiteColor]];
        [_addressNVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor hyBlackTextColor],
                                                            NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    }
    return _addressNVC;
}

- (void)filterAddress:(UIButton *)button{
    if (self.addressNVC.view.superview) {
        //如果self.addressNVC已经加载，点击后移除self.addressNVC
        [self hiddenFilterAddress];
        return;
    }
    button.enabled = NO;    //避免多次addressNVC未加载成功时点击多次，而加载多个addressNVC
    [self addChildViewController:self.addressNVC];
    [self.view addSubview:self.addressNVC.view];
    [self.view bringSubviewToFront:self.addressNVC.view];
    [self.addressNVC popToRootViewControllerAnimated:NO];
    self.addressNVC.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-64);
    [UIView animateWithDuration:0.3 animations:^{
        self.addressNVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        button.enabled = YES;   //addressNVC加载成功后恢复button.enabled
    }];
    
}

- (void)hiddenFilterAddress{
    [self.addressNVC removeFromParentViewController];
    [self.addressNVC.view removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.addressNVC.view.alpha = CGFLOAT_MIN;
    }];
}


- (void)chooseGender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    [alertC addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.gender = @"男";
        [self.tableView reloadData];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.gender = @"女";
        [self.tableView reloadData];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertC animated:YES completion:nil];
}


//MARK:上传头像
- (UIImagePickerController*)createImagePicker {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.navigationBar.barTintColor = [UIColor hyBarTintColor];
    return imagePicker;
}
- (void)selectPhoto {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self showCamera];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self showPhotoLibrary];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)showCamera{
    UIImagePickerController * imagePicker = [self createImagePicker];
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
-(void)uploadImage:(NSData*)data {
//    self.faceUrl = @"";
}

@end
