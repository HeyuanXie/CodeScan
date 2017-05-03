//
//  MineCommentController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineCommentController.h"
#import "JYSlideSegmentController.h"
#import "SDPhotoBrowser.h"
#import "MineCommentCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UITableViewCell+HYCell.h"

typedef enum : NSUInteger {
    TypeTheater = 1,
    TypeDerive,
} ContentType;

@interface CommentController : BaseTableViewController

@property(nonatomic,assign)ContentType contentType;
@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation CommentController

-(void)viewDidLoad {
    
    self.haveTableFooter = YES;
    [self subviewStyle];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[MineCommentCell identify] bundle:nil] forCellReuseIdentifier:[MineCommentCell identify]];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self subviewStyle];
    [self fetchData];
    [self headerViewInit];
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:[MineCommentCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    NSDictionary* model = self.dataArray[indexPath.row];
    if (self.contentType == TypeTheater) {
        [cell configTheaterCell:model];
    }else{
        [cell configDeriveCell:model];
    }
    @weakify(cell);
    [cell setImageClick:^(NSInteger index) {
        @strongify(cell);
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = index;
        browser.currentImage = ((UIImageView*)(cell.scrollView.subviews[index])).image;
        browser.sourceImagesContainerView = cell.scrollView;
        browser.images = model[@"show_img"];
        [browser show];
    }];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[MineCommentCell identify] cacheByIndexPath:indexPath configuration:^(MineCommentCell* cell) {
        
        NSDictionary* model = self.dataArray[indexPath.row];
        if (self.contentType == TypeTheater) {
            [cell configTheaterCell:model];
        }else{
            [cell configDeriveCell:model];
        }
        @weakify(cell);
        [cell setImageClick:^(NSInteger index) {
            @strongify(cell);
            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
            browser.currentImageIndex = index;
            browser.currentImage = ((UIImageView*)(cell.scrollView.subviews[index])).image;
            browser.sourceImagesContainerView = cell.scrollView;
            browser.images = model[@"show_img"];
            [browser show];
        }];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)fetchData {
    self.tableView.tableFooterView = nil;
    [self showLoadingAnimation];
    [APIHELPER mineCommentList:0 limit:6 type:self.contentType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        
        if (isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];

            self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
            if (self.haveNext) {
                [self appendFooterView];
            }else{
                [self removeFooterRefresh];
            }
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER mineCommentList:0 limit:6 type:self.contentType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];

            if (isSuccess) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        [self showLoadingAnimation];
        [APIHELPER mineCommentList:self.dataArray.count limit:6 type:self.contentType complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            [self hideLoadingAnimation];
            
            if (isSuccess) {
                [self.dataArray addObjectsFromArray:responseObject[@"data"][@"list"]];
                [self.tableView reloadData];
                
                self.haveNext = [responseObject[@"data"][@"have_next"] boolValue];
                if (self.haveNext) {
                    [self appendFooterView];
                }else{
                    [self removeFooterRefresh];
                }
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
            [self endRefreshing];
        }];
    }];
}

-(void)subviewStyle {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    self.tableView.tableHeaderView = headView;
    
    self.tableView.backgroundColor = [UIColor hyViewBackgroundColor];
}

@end



@interface MineCommentController ()

@property(nonatomic,strong)JYSlideSegmentController* slideController;
@property(nonatomic,strong)CommentController* theaterVC;
@property(nonatomic,strong)CommentController* productVC;

@end

@implementation MineCommentController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.slideController.view];
    self.slideController.view.frame = self.view.bounds;
    [self addChildViewController:self.slideController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
-(CommentController *)theaterVC {
    if (!_theaterVC) {
        _theaterVC = [[CommentController alloc] init];
        _theaterVC.contentType = TypeTheater;
        _theaterVC.title = @"剧评";
    }
    return _theaterVC;
}

-(CommentController *)productVC {
    if (!_productVC) {
        _productVC = [[CommentController alloc] init];
        _productVC.contentType = TypeDerive;
        _productVC.title = @"商品评价";
    }
    return _productVC;
}

-(JYSlideSegmentController *)slideController {
    if (!_slideController) {
        _slideController = [[JYSlideSegmentController alloc] initWithViewControllers:@[self.theaterVC,self.productVC]];
        _slideController.topBarHidden = NO;
        _slideController.separatorColor = [UIColor hySeparatorColor];
        _slideController.segmentBarColor = [UIColor whiteColor];
        _slideController.indicatorColor = [UIColor hyBarTintColor];
        _slideController.indicatorHeight = 1.f;
        _slideController.indicatorInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        _slideController.itemWidth = kScreen_Width/[[_slideController viewControllers] count];
    }
    return _slideController;
}

@end
