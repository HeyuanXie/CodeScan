//
//  MineCommentController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineCommentController.h"
#import "JYSlideSegmentController.h"
#import "MineCommentCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UITableViewCell+HYCell.h"

@interface CommentController : BaseTableViewController

@property(nonatomic,assign)BOOL isTheater;
@property(nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation CommentController

-(void)viewDidLoad {
    [self subviewStyle];
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[MineCommentCell identify] bundle:nil] forCellReuseIdentifier:[MineCommentCell identify]];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self subviewStyle];
    [self fetchData];
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
    
    [cell configMineCommentCell:nil];
    [cell addLine:NO leftOffSet:0 rightOffSet:0];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[MineCommentCell identify] cacheByIndexPath:indexPath configuration:^(MineCommentCell* cell) {
        
        [cell configMineCommentCell:nil];
        [cell addLine:NO leftOffSet:0 rightOffSet:0];
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

-(void)fetchData {
    self.dataArray = [@[@"",@""] mutableCopy];
    [self.tableView reloadData];
}

-(void)subviewStyle {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, zoom(15))];
    headView.backgroundColor = [UIColor hyViewBackgroundColor];
    self.tableView.tableHeaderView = headView;
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
        _theaterVC.isTheater = YES;
        _theaterVC.title = @"剧评";
    }
    return _theaterVC;
}
-(CommentController *)productVC {
    if (!_productVC) {
        _productVC = [[CommentController alloc] init];
        _productVC.isTheater = NO;
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
