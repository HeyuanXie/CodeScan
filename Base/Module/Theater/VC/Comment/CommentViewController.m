//
//  CommentViewController.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentImageCell.h"
#import "CommentScoreCell.h"

@interface CommentViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic)NSArray* infos;

@property(assign,nonatomic)int score;               //评价的分
@property(strong,nonatomic)NSMutableArray* images;  //晒图的数组
@property(strong,nonatomic)NSMutableArray* imageUrls;//晒图链接的数组
@property(strong,nonatomic)UITextView* textView;    //方便得到评论的文字


@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.score = 5; //默认为5分满分
    self.infos = @[@{@"height":@(90)},@{@"height":@(36)},@{@"height":@(230)},@{@"height":@(110)}];

    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 60, 0)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:[CommentImageCell identify] bundle:nil] forCellReuseIdentifier:[CommentImageCell identify]];
    [self.tableView registerNib:[UINib nibWithNibName:[CommentScoreCell identify] bundle:nil] forCellReuseIdentifier:[CommentScoreCell identify]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infos.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CommentImageCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommentImageCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            switch (self.type) {
                case CommentTypeTheater:
                    [cell configTheaterCell:self.data];
                    break;
                case CommentTypeLecture:
                    [cell configLectureCell:self.data];
                    break;
                case CommentTypeDerive:
                    [cell configDeriveCell:self.data];
                    break;
                case CommentTypeSkill:
                    [cell configSkillCell:self.data];
                    break;
                default:
                    break;
            }
            return cell;
        }
            
        case 1:
        {
            CommentScoreCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommentScoreCell identify]];
            [HYTool configTableViewCellDefault:cell];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell setScoreBtnClick:^(int index) {
                self.score = index + 1;
                [self.tableView reloadData];
            }];
            [cell configScoreCell:self.score];
            return cell;
        }
        case 2:
        {
            static NSString* cellId = @"commentCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UIView* grayView = [[UIView alloc] initWithFrame:CGRectZero];
                grayView.backgroundColor = RGB(243, 243, 243, 1.0);
                [cell.contentView addSubview:grayView];
                [grayView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
                
                self.textView = [HYTool getTextViewWithFrame:CGRectMake(20, 20, kScreen_Width-40, 208) placeHolder:@"写下您的评价吧..." placeHolderColor:[UIColor hyGrayTextColor] fontSize:14 textColor:[UIColor hyBlackTextColor]];
                [cell.contentView addSubview:self.textView];
                self.textView.backgroundColor = RGB(243, 243, 243, 1.0);
                [self.textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
                self.textView.delegate = self;
                self.textView.tag = 1000;
            }
            
            //                    UITextView* textView = [cell.contentView viewWithTag:1000];
            return cell;
        }
        default:
        {
            static NSString* cellId = @"uploadCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [HYTool configTableViewCellDefault:cell];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                UILabel* label = [HYTool getLabelWithFrame:CGRectMake(12, 0, kScreen_Width-24, 30) text:@"晒图:" fontSize:14 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentLeft];
                [cell.contentView addSubview:label];
                
                UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreen_Width, 80)];
                [cell.contentView addSubview:scroll];
                scroll.tag = 1000;
            }
            
            UIScrollView* scroll = [cell.contentView viewWithTag:1000];
            [self configScroll:scroll images:self.images];
            return cell;
        }
    }
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.infos[indexPath.section][@"height"] floatValue];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - textView Delegate
-(void)textViewDidChange:(UITextView *)textView {
    UILabel* placeHolder = [textView viewWithTag:10000];
    if (![textView.text isEmpty]) {
        placeHolder.hidden = YES;
    }else{
        placeHolder.hidden = NO;
    }
}

#pragma mark - private methods

- (NSMutableArray *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (IBAction)submit:(id)sender {
    //TODO:提交评论
    if ([self.textView.text isEmpty] && self.score != 5) {
        [self showMessage:@"请输入评论"];
        return;
    }
    switch (self.type) {
        case CommentTypeSkill:
            break;
        case CommentTypeDerive:
            [self commentDerive];
            break;
        case CommentTypeLecture:
            break;
        case CommentTypeTheater:
            [self commentTheater];
            break;
        default:
            break;
    }

}

-(void)commentDerive {
    [APIHELPER deriveComment:[self.data[@"goods_id"] integerValue] orderSn:self.data[@"order_id"] score:self.score comment:self.textView.text images:self.imageUrls complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            [self showMessage:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}
-(void)commentTheater {
    [APIHELPER theaterComment:[self.data[@"play_id"] integerValue] orderId:[self.data[@"order_id"] integerValue] score:self.score content:self.textView.text images:self.imageUrls complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            [self showMessage:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)configScroll:(UIScrollView*)scroll images:(NSArray *)images {
    
    for (UIView* subview in scroll.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat width = 60;
    for (int i=0; i<self.images.count; i++) {
        UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(12+(12+width)*i, 10, width, width)];
        [HYTool configViewLayer:imgV];
        imgV.image = self.images[i];
        [scroll addSubview:imgV];
    }
    UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(12+(12+width)*self.images.count, 10, width, width) title:nil titleSize:0 titleColor:nil backgroundColor:nil blockForClick:^(id sender) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"晒图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showCamera];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showPhotoLibrary];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }];
    [btn setImage:ImageNamed(@"upload") forState:(UIControlStateNormal)];
    [scroll addSubview:btn];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        @weakify(self);
        [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
        [APIHELPER uploadFileByType:@"face" file:data progress:nil complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @strongify(self);
            if (isSuccess) {
                [self.imageUrls addObject:responseObject[@"data"][@"filename"]];
                [self.images addObject:img];
                [self.tableView reloadData];
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
