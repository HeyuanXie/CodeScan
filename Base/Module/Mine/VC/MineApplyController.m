//
//  MineApplyController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineApplyController.h"
#import "JYSlideSegmentController.h"
#import "MyApplyCell.h"

@interface ApplyController : BaseTableViewController

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isLecture;  //是否为专家讲座

@end

@implementation ApplyController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:[MyApplyCell identify] bundle:nil] forCellReuseIdentifier:[MyApplyCell identify]];

    [self fetchData];
}

#pragma mark - talbeView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyApplyCell* cell = [tableView dequeueReusableCellWithIdentifier:[MyApplyCell identify]];
    [HYTool configTableViewCellDefault:cell];
    [cell configMineApplyCell:nil isLecture:self.isLecture];
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isLecture ? zoom(190) : zoom(152);
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


@end

@interface MineApplyController ()

@property(nonatomic,strong)JYSlideSegmentController* slideController;
@property(nonatomic,strong)ApplyController* lectureVC;
@property(nonatomic,strong)ApplyController *skillVC;

@end

@implementation MineApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.slideController.view];
    self.slideController.view.frame = [[UIScreen mainScreen] bounds];
    [self addChildViewController:self.slideController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
-(ApplyController *)lectureVC {
    if (!_lectureVC) {
        _lectureVC = [[ApplyController alloc] init];
        _lectureVC.isLecture = YES;
        _lectureVC.title = @"专家讲座";
    }
    return _lectureVC;
}
-(ApplyController *)skillVC {
    if (!_skillVC) {
        _skillVC = [[ApplyController alloc] init];
        _skillVC.isLecture = NO;
        _skillVC.title = @"才艺竞赛";
    }
    return _skillVC;
}
-(JYSlideSegmentController *)slideController {
    if (!_slideController) {
        _slideController = [[JYSlideSegmentController alloc] initWithViewControllers:@[self.lectureVC,self.skillVC]];
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
