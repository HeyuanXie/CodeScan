//
//  SkillUploadViewController.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillUploadViewController.h"

@interface SkillUploadViewController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray* videoArray;
@property (strong, nonatomic) NSMutableArray* imageArray;

@end

@implementation SkillUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, zoom(60), 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self subviewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        switch (indexPath.row) {
            case 0:{
                static NSString* cellId = @"headCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                }
                for (id obj in cell.contentView.subviews) {
                    [obj removeFromSuperview];
                }
                UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(12, 0, kScreen_Width-24, 48) text:@"上传参赛视频" fontSize:15 textColor:[UIColor hyGrayTextColor] textAlignment:NSTextAlignmentLeft];
                [cell.contentView addSubview:lbl];
                return cell;
            }
            case 1: {
                static NSString* cellId = @"titleCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(0, 0, 60, 48) text:@"标题:" fontSize:14 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentCenter];
                    [cell.contentView addSubview:lbl];
                    UITextField* tf = [HYTool getTextFieldWithFrame:CGRectMake(63, 0, kScreen_Width-63-12, 48) placeHolder:@"请输入标题" fontSize:15 textColor:[UIColor hyBlackTextColor]];
                    tf.delegate = self;
                    [cell.contentView addSubview:tf];
                }
                return cell;
            }
            default:{
                static NSString* cellId = @"uploadCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:cell.bounds];
                    scroll.tag = 1000;
                    [cell.contentView addSubview:scroll];
                }
                [self configUploadCellWithArray:self.videoArray cell:cell section:0];
                return cell;
            }
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                static NSString* cellId = @"headCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                }
                for (id obj in cell.contentView.subviews) {
                    [obj removeFromSuperview];
                }
                UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(12, 0, kScreen_Width-24, 48) text:@"上传参赛照片" fontSize:15 textColor:[UIColor hyGrayTextColor] textAlignment:NSTextAlignmentLeft];
                [cell.contentView addSubview:lbl];
                return cell;
            }
            case 1:{
                static NSString* cellId = @"descCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(0, 0, 90, 48) text:@"个人简介:" fontSize:14 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentCenter];
                    [cell.contentView addSubview:lbl];
                    UITextView* textView = [HYTool getTextViewWithFrame:CGRectMake(93, 2, kScreen_Width-93-10, 92) placeHolder:@"写点什么帮你宝宝拉票吧！" fontSize:15 textColor:[UIColor hyBlackTextColor]];
                    [HYTool configViewLayer:textView withColor:[UIColor hySeparatorColor]];
                    textView.delegate = self;
                    [cell.contentView addSubview:textView];
                }
                return cell;
            }
                
            default:{
                static NSString* cellId = @"uploadCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:cell.bounds];
                    scroll.tag = 1000;
                    [cell.contentView addSubview:scroll];
                }
                [self configUploadCellWithArray:self.imageArray cell:cell section:1];
                return cell;
            }
        }
    }
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return indexPath.row == 2 ? 96 : 48;
        default:
            return indexPath.row == 0 ? 48 : 96;
    }
}

#pragma mark - private methods
-(NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(void)subviewInit {
    UIView* headerView = LOADNIB(@"SkillUseView", 0);
    headerView.frame = CGRectMake(0, 0, kScreen_Width, 210);
    UIButton* laterBtn = (UIButton*)[headerView viewWithTag:1000];
    [HYTool configViewLayer:laterBtn withColor:[UIColor hyBarTintColor]];
    [laterBtn bk_whenTapped:^{
        //TODO:稍后上传
    }];
    self.tableView.tableHeaderView = headerView;
}

-(void)configUploadCellWithArray:(NSArray*)array cell:(UITableViewCell*)cell section:(NSInteger)section {
    UIScrollView* scroll = [cell.contentView viewWithTag:1000];
    for (UIView* view in scroll.subviews) {
        [view removeFromSuperview];
    }
    CGFloat x = array.count*(60+12)+12,y = 18;
    UIButton* selectBtn = [HYTool getButtonWithFrame:CGRectMake(x, y, 60, 60) title:@"" titleSize:0 titleColor:nil backgroundColor:nil blockForClick:^(id sender) {
        switch (section) {
            case 0:{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"上传参赛视频" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertC addAction:[UIAlertAction actionWithTitle:@"录制视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self recordVideo];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"本地视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self chooseVideo];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            
            default:{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"上传参赛图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showCamera];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showPhotoLibrary];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
        }
    }];
    [selectBtn setImage:ImageNamed(@"cart") forState:UIControlStateNormal];
    [scroll addSubview:selectBtn];
    for (int i=0; i<array.count; i++) {
        UIImage* image = array[i];
        UIImageView* imgV = [[UIImageView alloc] initWithImage:image];
        imgV.frame = CGRectMake(12+i*(12+60), y, 60, 60);
        [scroll addSubview:imgV];
    }
    scroll.contentSize = CGSizeMake(x+60, 0);
}

//MARK:选择图片
- (void)showCamera{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoLibrary{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//MARK:选择视频
- (void)chooseVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:imagePicker animated:YES completion:nil];
    imagePicker.delegate = self;//设置委托
    
}

- (void)recordVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:imagePicker animated:YES completion:nil];
    imagePicker.videoMaximumDuration = 30.0f;//30秒
    imagePicker.delegate = self;//设置委托
    
}


#pragma mark - IBActions
- (IBAction)upload:(id)sender {
    APPROUTE(kSkillApplySucceedController);
}


#pragma mark - imagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.imageArray addObject:img];
        [self.tableView reloadData];
    }];
}

@end
