//
//  FeedbackController.m
//  Template
//
//  Created by hitao on 16/9/30.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "FeedbackController.h"
#import "UITextView+Placeholder.h"
#import <UIView+BlocksKit.h>
#import <UIControl+BlocksKit.h>
#import <UIActionSheet+BlocksKit.h>
#import "UIButton+HYButtons.h"
#import "MBProgressHUD+hyHUD.h"
#import "APIHelper+Common.h"

@interface FeedbackController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) NSMutableArray *selectTypeArray;

#pragma mark -- 图片选择
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addPhoneView;

@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) NSString *imageName;

#pragma mark -- 内容
@property (weak, nonatomic) IBOutlet UITextView *textView;

#pragma mark -- 反馈类型
@property (weak, nonatomic) IBOutlet UIView *bugView;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIView *netView;
@property (weak, nonatomic) IBOutlet UIView *otherView;

#pragma mark -- phone
@property (weak, nonatomic) IBOutlet UITextField *textField;

#pragma mark -- submit
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataInit];
    [self subViewStyle];
    [self subViewBind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- private funtion & binding
- (void)dataInit{
    self.selectTypeArray = [NSMutableArray arrayWithArray:@[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)]];
}

- (void)subViewStyle{
    self.selectView.hidden = YES;
    self.shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(2, 2);
    self.shadowView.layer.shadowOpacity = 0.8;
    self.shadowView.layer.shadowRadius = 2;
    
    self.textView.placeholder = @"请写下您的建议(不少于10字)";
    [self refreshTypeViews];
    [self.submitButton setBlackDisableGrayStyle];
    
}

- (void)refreshTypeViews{
    NSArray *typeViews = @[self.bugView, self.functionView, self.contentView, self.adView, self.netView, self.otherView];
    for (int i=0; i<typeViews.count; i++) {
        UIView *view = typeViews[i];
        UIImageView *imageView = [view viewWithTag:10086];
        imageView.image = [self.selectTypeArray[i] boolValue] ? ImageNamed(@"勾选协议"):ImageNamed(@"未选择");
    }
}

- (void)subViewBind{
    @weakify(self);
    [self.shadowView bk_whenTapped:^{
        @strongify(self);
        [self selectImageBind];
    }];
    
    NSArray *typeViews = @[self.bugView, self.functionView, self.contentView, self.adView, self.netView, self.otherView];
    for (UIView *view in typeViews) {
        [view bk_whenTapped:^{
            @strongify(self);
            NSArray *typeViews = @[self.bugView, self.functionView, self.contentView, self.adView, self.netView, self.otherView];
            for (int i=0; i<typeViews.count; i++) {
                UIView *typeView = typeViews[i];
                if (typeView == view) {
                    self.selectTypeArray[i] = @(YES);
                }else{
                    self.selectTypeArray[i] = @(NO);
                }
            }
            [self refreshTypeViews];
        }];
    }
    
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectImageBind{
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"添加图片"];
    @weakify(self);
    [actionSheet bk_addButtonWithTitle:@"相册" handler:^{
        @strongify(self);
        [self showPhotoLibrary];
    }];
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
        @strongify(self);
        [self showCamera];
    }];
    if (!self.selectView.hidden) {
        [actionSheet bk_addButtonWithTitle:@"删除" handler:^{
            @strongify(self);
            [self clearImage];
        }];
    }
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet showInView:self.view];
}


- (UIImagePickerController*)createImagePicker {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBar.barTintColor = [UIColor hyBarTintColor];
    return imagePicker;
}
- (void)showCamera{

    UIImagePickerController * imagePicker = [self createImagePicker];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoLibrary{
    
    UIImagePickerController * imagePicker = [self createImagePicker];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)clearImage{
    self.selectImage = nil;
    self.imageName = nil;
    self.selectView.hidden = YES;
}
- (IBAction)dissmissKB:(id)sender {
    [self.textView resignFirstResponder];
}

- (void)submit{
    if (self.textView.text.length < 10) {
        [MBProgressHUD hy_showMessage:@"建议不能小于10字！" inView:self.view];
        return;
    }
    if (self.textField.text.length == 0) {
        [MBProgressHUD hy_showMessage:@"请输入联系方式！" inView:self.view];
        return;
    }
    
    if (![self.selectTypeArray containsObject:@(YES)]) {
        [MBProgressHUD hy_showMessage:@"请选择类型！" inView:self.view];
        return;
    }
    NSInteger type = ([self.selectTypeArray indexOfObject:@(YES)] + 1);
    
    [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [APIHELPER feedback:self.textView.text type:[NSString stringWithFormat:@"%ld", type] pic:self.imageName contact:self.textField.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
        }else{
            [MBProgressHUD hy_showMessage:@"意见反馈成功!" inView:self.view completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)setSelectImage:(UIImage *)selectImage{
    if (_selectImage != selectImage) {
        _selectImage = selectImage;
        self.selectImageView.image = selectImage;
    }
}
#pragma mark -- imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    self.selectView.hidden = NO;
    self.selectImage = img;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        @weakify(self);
        [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
        [APIHELPER uploadFileByType:@"feedback" file:data progress:nil complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (isSuccess) {
                self.imageName = responseObject[@"data"][@"filename"];
            }else{
                [self clearImage];
                if (error) {
                    [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
                }
            }
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
