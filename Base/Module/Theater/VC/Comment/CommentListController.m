//
//  CommentListController.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommentListController.h"
#import "SDPhotoBrowser.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "CommentListCell.h"
#import "CustomJumpBtns.h"

typedef enum : NSUInteger {
    CommentAll = 0,
    CommentImage,
    CommentNew,
} CommentStyle;

typedef enum : NSUInteger {
    TypeTheater,
    TypeDerive,
} ContentType;

@interface CommentListController ()

@property(assign,nonatomic)NSInteger playId;
@property(assign,nonatomic)NSInteger goodId;
@property(strong,nonatomic)NSMutableArray* dataArray;

@property(assign,nonatomic)CommentStyle commentStyle;
@property(assign,nonatomic)ContentType contentType;

@end

@implementation CommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentStyle = CommentAll;
    self.contentType = TypeTheater;
    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    if (self.schemaArgu[@"playId"]) {
        self.playId = [[self.schemaArgu objectForKey:@"playId"] integerValue];
    }
    if (self.schemaArgu[@"goodId"]) {
        self.goodId = [[self.schemaArgu objectForKey:@"goodId"] integerValue];
    }
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(42, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[CommentListCell identify] bundle:nil] forCellReuseIdentifier:[CommentListCell identify]];

    [self subviewStyle];
    [self fetchData];
    [self headerViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommentListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    CommentModel* model = self.dataArray[indexPath.section];
    [cell configListCell:model type:self.contentType];
    @weakify(cell);
    [cell setImgClick:^(NSInteger index) {
        @strongify(cell);
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = index;
        browser.currentImage = ((UIImageView*)(cell.botScroll.subviews[index])).image;
        browser.sourceImagesContainerView = cell.botScroll;
        browser.images = model.showImg;
        [browser show];
    }];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[CommentListCell identify] cacheByIndexPath:indexPath configuration:^(CommentListCell* cell) {
        
        CommentModel* model = self.dataArray[indexPath.section];
        [cell configListCell:model type:self.contentType];
        @weakify(cell);
        [cell setImgClick:^(NSInteger index) {
            @strongify(cell);
            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
            browser.currentImageIndex = index;
            browser.currentImage = ((UIImageView*)(cell.botScroll.subviews[index])).image;
            browser.sourceImagesContainerView = cell.botScroll;
            browser.images = model.showImg;
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
    
    switch (self.contentType) {
        case TypeTheater:{
            [self showLoadingAnimation];
            [APIHELPER theaterCommentList:0 limit:6 playId:self.playId type:self.commentStyle complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                [self hideLoadingAnimation];
                
                if (isSuccess) {
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CommentModel class] array:responseObject[@"data"][@"list"]] ];
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
        }break;
        case TypeDerive:{
            [self showLoadingAnimation];
            [APIHELPER deriveCommentList:0 limit:6 goodId:self.goodId type:self.commentStyle complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                [self hideLoadingAnimation];
                
                if (isSuccess) {
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CommentModel class] array:responseObject[@"data"][@"list"]] ];
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
        }break;
            
        default:
            break;
    }
}

-(void)headerViewInit {
    @weakify(self);
    [self addHeaderRefresh:^{
        @strongify(self);
        switch (self.contentType) {
            case TypeTheater:{
                [self showLoadingAnimation];
                [APIHELPER theaterCommentList:0 limit:6 playId:self.playId type:self.commentStyle complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    
                    if (isSuccess) {
                        [self.dataArray removeAllObjects];
                        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CommentModel class] array:responseObject[@"data"][@"list"]] ];
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
            }break;
            case TypeDerive:{
                [self showLoadingAnimation];
                [APIHELPER deriveCommentList:0 limit:6 goodId:self.goodId type:self.commentStyle complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    
                    if (isSuccess) {
                        [self.dataArray removeAllObjects];
                        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CommentModel class] array:responseObject[@"data"][@"list"]] ];
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
            }break;
                
            default:
                break;
        }
    }];
}

-(void)appendFooterView {
    @weakify(self);
    [self addFooterRefresh:^{
        @strongify(self);
        switch (self.contentType) {
            case TypeTheater:{
                [self showLoadingAnimation];
                [APIHELPER theaterCommentList:self.dataArray.count limit:6 playId:self.playId type:self.commentStyle complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    
                    if (isSuccess) {
                        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CommentModel class] array:responseObject[@"data"][@"list"]] ];
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
            }break;
            case TypeDerive:{
                [self showLoadingAnimation];
                [APIHELPER deriveCommentList:self.dataArray.count limit:6 goodId:self.goodId type:self.commentStyle complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    
                    if (isSuccess) {
                        [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CommentModel class] array:responseObject[@"data"][@"list"]] ];
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
            }break;
                
            default:
                break;
        }
    }];
}

-(void)subviewStyle {
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 42)];
    topView.backgroundColor = [UIColor whiteColor];
    
    NSArray* titles = @[@"全部",@"晒图"];
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, kScreen_Width, 42) menuTitles:titles textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:YES];
    [topView addSubview:btns];
    NSArray* styles = @[@(CommentAll),@(CommentImage),@(CommentNew)];
    [btns setFinished:^(NSInteger index) {
        self.commentStyle = [styles[index] integerValue];
        [self fetchData];
    }];
    [self.view addSubview:topView];
}

@end
